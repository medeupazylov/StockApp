import UIKit


struct GraphParameters {
    let resolution: String
    let from: String
    let to: String
}



protocol StockManagerDelegate{
    func didUpdateStock(_ stockManager: StockManager, stockLiveData: StockLiveData)
    func didFailWithError(error: Error)
}


class StockManager {
    
    var delegate: StockManagerDelegate?
    
    let baseURL = "https://finnhub.io/api/v1/quote"
    let baseURLforGraph = "https://finnhub.io/api/v1/stock/candle?"
    let from = "1572651390"
    let to = "1575243390"
    let resolution = "D"
    
    let apiKey = "ceji9b2ad3i2vm5l5930ceji9b2ad3i2vm5l593g"

    func getGraphParameters(period: String) -> GraphParameters { //returns [resolution, from, to]
        let to = Int(NSDate().timeIntervalSince1970)
        var from = 0
        var resolution = ""
        
        switch period {
        case Period.all:
            from = to - 360 * 24 * 3600
            resolution = "W"
        case Period.year:
            from = to - 360 * 24 * 3600
            resolution = "W"
        case Period.sixMonth:
            from = to - 6 * 30 * 24 * 3600
            resolution = "W"
        case Period.month:
            from = to - 30 * 24 * 3600
            resolution = "D"
        case Period.week:
            from = to - 7 * 24 * 3600
            resolution = "60"
        case Period.day:
            from = to - 24 * 3600
            resolution = "15"
        default:
            from = to - 24 * 3600
            resolution = "W"
        }
        
        return GraphParameters(resolution: resolution, from: String(from), to: String(to))
    }
    
    
    func performRequestGraphData(with stockTicker: String, period: String , completion: @escaping (StockGraphData?, Error?) -> Void) {
        
        let parameters = getGraphParameters(period: period)
        
        let urlString = baseURLforGraph + "resolution=" + parameters.resolution + "&from=" + parameters.from + "&to=" + parameters.to + "&token=" + apiKey + "&symbol=" + stockTicker
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                guard let stockGraphData = self.parseJSONgraph(data: data) else {
                    completion(nil, nil)
                    return
                }
                completion(stockGraphData, nil)
                
            }
            task.resume()
        }
    }
    

    
    func parseJSONgraph(data: Data) -> StockGraphData? {
        let decoder = JSONDecoder()
        do{
            let decodedStockGraphData = try decoder.decode(StockGraphData.self, from: data)
            for i in decodedStockGraphData.closePrices { print(i) }
            return decodedStockGraphData
        } catch {
            return nil
        }
    }
    
    func getStockProfiles() -> [StockData] {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let json = try JSONDecoder().decode([StockData].self, from: data)
                return json
            } catch {
                return []
            }
        }
        return []
    }
    
    func performRequest(with stockTicker: String, completion: @escaping (StockLiveData?, Error?) -> Void) {
        let urlString = baseURL + "?token=" + apiKey + "&symbol=" + stockTicker
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                guard let stockLiveData = self.parseJSON(data: data) else {
                    completion(nil, nil)
                    return
                }
                completion(stockLiveData, nil)
            }
            task.resume()
            
        }
    }
    
    func parseJSON(data: Data) -> StockLiveData? {
        let decoder = JSONDecoder()
        do{
            let decodedStockLiveData = try decoder.decode(StockLiveData.self, from: data)
            return decodedStockLiveData
        } catch {
            return nil
        }
    }
    
    
    
    
}


