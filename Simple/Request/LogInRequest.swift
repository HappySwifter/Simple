//
//  LogInRequest.swift
//  Simple
//
//  Created by guest2 on 19.12.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import Alamofire

final class LogInRequest: BackendAPIRequest {
    
    private let email: String
    private let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        
    }
    
    var endpoint: String {
        return "users/login"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var query: NetworkService.QueryType {
        return .json
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: email, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        return headers
    }
}
