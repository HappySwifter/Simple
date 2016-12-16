import Foundation
import SwiftyJSON

public let DidPerformUnauthorizedOperation = "DidPerformUnauthorizedOperation"

class BackendService {
    
    private let conf: BackendConfiguration
    private let service = NetworkService()
    
    init(_ conf: BackendConfiguration) {
        self.conf = conf
    }
    
    func request(_ request: BackendAPIRequest,
                 success: ((JSON) -> ())? = nil,
                 failure: ((NSError) -> Void)? = nil) {
        
        let url = conf.baseURL.appendingPathComponent(request.endpoint)
        
        let headers = request.headers
        // Set authentication token if available.
//        headers?["X-Api-Auth-Token"] = BackendAuth.shared.token
        
        service.makeRequest(for: url, method: request.method, query: request.query, params: request.parameters, headers: headers, success: { data in
            
            let json = JSON(data)
            if json["error"].bool == true {
                print("😡 \(url) \(json["message"].string ?? "unknown error")")
                let info = [
                    NSLocalizedFailureReasonErrorKey: json["message"].string
                ]
                let error = NSError(domain: "BackendService", code: 0, userInfo: info)
                failure?(error)
            } else {
                print("😇 \(url) \(data)")
                success?(json)
            }
            
            
        }, failure: { error, statusCode in
            if statusCode == 401 {
                // Operation not authorized
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DidPerformUnauthorizedOperation), object: nil)
                return
            }
            
            let info = [ NSLocalizedFailureReasonErrorKey: error ]
            failure?(NSError(domain: "BackendService", code: statusCode ?? 0, userInfo: info))
                
        })
    }
    
    func cancel() {
        service.cancel()
    }
}
