import Foundation
import Alamofire

protocol BackendAPIRequest {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var query: NetworkService.QueryType { get }
    var parameters: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
}

extension BackendAPIRequest {
    
    func defaultJSONHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}
