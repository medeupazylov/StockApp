import UIKit


protocol StockManagerDelegate{
    func didUpdateStock(_ stockManager: StockManager, stockLiveModel: StockLiveModel)
    func didFailWithError(error: Error)
}


struct StockManager {
    
    var delegate: StockManagerDelegate?
    
    let baseURL = "https://finnhub.io/api/v1/quote"
    let apiKey = "ceji9b2ad3i2vm5l5930ceji9b2ad3i2vm5l593g"
    
    func fetchStockPrice(stockTicker: String) {
        let urlString = baseURL + "?token=" + apiKey + "&symbol=" + stockTicker
        DispatchQueue.main.async {
            self.performRequest(with: urlString)
        }
        
        print(urlString)
    }
    
    func performRequest(with urlString: String) {
        DispatchQueue.main.async {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let stockLiveModel = self.parseJSON(data: safeData) {
                        delegate?.didUpdateStock(self, stockLiveModel: stockLiveModel)
                        print(stockLiveModel.price)
                    }
            
                }
                
            }
            
            task.resume()
            
        }
    
        }
    }
    
    func parseJSON(data: Data) -> StockLiveModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(StockLiveData.self, from: data)
            let stockLiveModel = StockLiveModel(price: decodedData.currentPrice, changePrice: decodedData.change, changePricePercent: decodedData.changePercent)
            return stockLiveModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


