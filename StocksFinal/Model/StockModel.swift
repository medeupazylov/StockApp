import UIKit

class StockModel {
    let ticker: String
    let name: String
    let linkIcon: String
    let stockLiveData: StockLiveData
    var isFavourite = false
    
    
    init(ticker: String, name: String, linkIcon: String, stockLiveData: StockLiveData) {
        self.ticker = ticker
        self.name = name
        self.linkIcon = linkIcon
        self.stockLiveData = stockLiveData
    }
}

