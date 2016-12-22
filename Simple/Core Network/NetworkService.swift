import Foundation
import Alamofire

class NetworkService {
    
    private var task: Alamofire.DataRequest?
    private var successCodes: CountableRange<Int> = 200..<299
    private var failureCodes: CountableRange<Int> = 400..<499
        
    enum QueryType {
        case json, path
    }

    
    func makeRequest(for url: URL, method: HTTPMethod, query type: QueryType,
                     params: [String: Any]? = nil,
                     headers: HTTPHeaders? = nil,
                     success: ((Any) -> ())? = nil,
                     failure: ((_ error: String?, _ responseCode: Int?) -> Void)? = nil) {
        
        let query = makeQuery(for: url, params: params, type: type)
        
        task = Alamofire.request(url, method: method, parameters: params, headers: headers)
            .validate(statusCode: successCodes)
            .responseJSON(completionHandler: { (response) in
            
            if let date = response.response?.allHeaderFields["Date"] {
                let def = UserDefaults.standard
                def.set(date, forKey: "LastServerModDate")
                def.synchronize()
            }
                
            switch response.result {
            case .success(let value):
                success?(value)
            case .failure(let error):
                print("😡 \(url) \(error.localizedDescription)")
                failure?(error.localizedDescription, response.response?.statusCode)
            }
        })
    }
    
    func cancel() {
        task?.cancel()
    }
    
    
    //MARK: Private
    private func makeQuery(for url: URL, params: [String: Any]?, type: QueryType) -> URLRequest {
        switch type {
        case .json:
            var mutableRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                            timeoutInterval: 10.0)
            if let params = params {
                mutableRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            }
            
            return mutableRequest
        case .path:
            var query = ""
            
            params?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            
            return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        }
        
    }
}


