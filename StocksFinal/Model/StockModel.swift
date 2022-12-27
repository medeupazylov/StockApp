import UIKit

struct StockModel {
    let ticker: String
    let name: String
    let stockIcon: UIImage
    let stockLiveModel: StockLiveModel
    
    
    init(ticker: String, name: String, stockIcon: UIImage, stockLiveModel: StockLiveModel) {
        self.ticker = ticker
        self.name = name
        self.stockIcon = stockIcon
        self.stockLiveModel = stockLiveModel
    }
}

struct StockLiveModel {
    let price: Double
    let changePrice: Double
    let changePricePercent: Double
    
    init(price: Double, changePrice: Double, changePricePercent: Double) {
        self.price = price
        self.changePrice = changePrice
        self.changePricePercent = changePricePercent
    }
}
