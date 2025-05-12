import Foundation
import StoreKit

enum IAPProduct: String, CaseIterable {
    case seasonOnePack = "com.friendstrivia.seasonone"
    case seasonTwoPack = "com.friendstrivia.seasontwo"
    case seasonThreePack = "com.friendstrivia.seasonthree"
    case seasonFourPack = "com.friendstrivia.seasonfour"
    case seasonFivePack = "com.friendstrivia.seasonfive"
    case seasonSixPack = "com.friendstrivia.seasonsix"
    case seasonSevenPack = "com.friendstrivia.seasonseven"
    case seasonEightPack = "com.friendstrivia.seasoneight"
    case seasonNinePack = "com.friendstrivia.seasonnine"
    case seasonTenPack = "com.friendstrivia.seasonten"
    case allSeasonsPack = "com.friendstrivia.allseasons"
    
    var displayName: String {
        switch self {
        case .seasonOnePack: return "Season 1 Questions"
        case .seasonTwoPack: return "Season 2 Questions"
        case .seasonThreePack: return "Season 3 Questions"
        case .seasonFourPack: return "Season 4 Questions"
        case .seasonFivePack: return "Season 5 Questions"
        case .seasonSixPack: return "Season 6 Questions"
        case .seasonSevenPack: return "Season 7 Questions"
        case .seasonEightPack: return "Season 8 Questions"
        case .seasonNinePack: return "Season 9 Questions"
        case .seasonTenPack: return "Season 10 Questions"
        case .allSeasonsPack: return "All Seasons Bundle (Save 50%)"
        }
    }
    
    var description: String {
        switch self {
        case .allSeasonsPack:
            return "Unlock all questions from all 10 seasons of Friends at a 50% discount! Includes exclusive bonus questions and special achievements."
        default:
            let seasonNumber = displayName.components(separatedBy: " ")[1]
            return "Unlock additional trivia questions from Season \(seasonNumber) of Friends. Test your knowledge of iconic moments, quotes, and character storylines!"
        }
    }
    
    var price: Decimal {
        switch self {
        case .allSeasonsPack:
            return 4.99
        default:
            return 0.99
        }
    }
}

class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var products: [SKProduct] = []
    @Published var purchasedProducts: Set<IAPProduct> = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var productRequest: SKProductsRequest?
    private var completionHandler: ((Result<Bool, Error>) -> Void)?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
        
        // Load previously purchased products
        if let purchasedProductIDs = UserDefaults.standard.stringArray(forKey: "PurchasedProducts") {
            purchasedProducts = Set(purchasedProductIDs.compactMap { IAPProduct(rawValue: $0) })
        }
    }
    
    func fetchProducts() {
        isLoading = true
        let productIdentifiers = Set(IAPProduct.allCases.map { $0.rawValue })
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func purchase(_ product: SKProduct, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            completion(.failure(StoreError.paymentNotAllowed))
            return
        }
        
        completionHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(completion: @escaping (Result<Bool, Error>) -> Void) {
        completionHandler = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        guard let productId = IAPProduct(rawValue: transaction.payment.productIdentifier) else { return }
        
        DispatchQueue.main.async {
            self.purchasedProducts.insert(productId)
            
            // Save purchased products to UserDefaults
            let purchasedProductIDs = self.purchasedProducts.map { $0.rawValue }
            UserDefaults.standard.set(purchasedProductIDs, forKey: "PurchasedProducts")
            
            // If all seasons pack is purchased, unlock all seasons
            if productId == .allSeasonsPack {
                self.purchasedProducts = Set(IAPProduct.allCases)
            }
            
            // Unlock content in Firebase
            FirebaseManager.shared.unlockQuestionPack(packId: productId.rawValue) { result in
                switch result {
                case .success:
                    self.completionHandler?(.success(true))
                case .failure(let error):
                    self.completionHandler?(.failure(error))
                }
            }
            
            // Update available questions in QuestionDatabase
            NotificationCenter.default.post(name: .questionPackPurchased, object: nil)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func isProductPurchased(_ product: IAPProduct) -> Bool {
        return purchasedProducts.contains(product)
    }
    
    func getAvailableQuestions() -> [Question] {
        var questions: [Question] = []
        
        // Add free questions (basic pack)
        questions += QuestionDatabase.questions.prefix(20)
        
        // Add purchased question packs
        for product in purchasedProducts {
            switch product {
            case .seasonOnePack:
                questions += QuestionDatabase.questions.filter { $0.season == 1 }
            case .seasonTwoPack:
                questions += QuestionDatabase.questions.filter { $0.season == 2 }
            // Add cases for other seasons...
            case .allSeasonsPack:
                questions = QuestionDatabase.questions
            }
        }
        
        return questions
    }
}

// MARK: - SKProductsRequestDelegate
extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            self.isLoading = false
            
            if response.products.isEmpty {
                self.error = "No products found"
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.error = error.localizedDescription
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchased(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                completionHandler?(.failure(transaction.error ?? StoreError.unknown))
            case .restored:
                handlePurchased(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}

enum StoreError: LocalizedError {
    case paymentNotAllowed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .paymentNotAllowed:
            return "In-App Purchases are not allowed on this device."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension Notification.Name {
    static let questionPackPurchased = Notification.Name("questionPackPurchased")
}
