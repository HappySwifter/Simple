import Foundation
import Alamofire

final class SignUpRequest: BackendAPIRequest {
    
    private let user: UserItem
    private let password: String
    private let keyword: String

    init(user: UserItem, password: String, keyword: String) {
        self.user = user
        self.password = password
        self.keyword = keyword

    }
    
    var endpoint: String {
        return "users/register"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var query: NetworkService.QueryType {
        return .json
    }
    
    var parameters: [String: Any]? {
        var params = [String: Any]()
        params["key"] =  self.keyword
        params["email"] = user.email
        params["password"] = self.password
        return params
    }
    
    var headers: [String: String]? {
        return nil
    }
}
