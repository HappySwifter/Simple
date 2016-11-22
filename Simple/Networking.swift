//
//  Networking.swift
//  Simple
//
//  Created by Artem Valiev on 20.11.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let userCredentials: [String: String] = [
    "key": registerKey,
    "email": "a.v@gmail.com",
    "password": "4005"
]

func print(response: DataResponse<Any>, caller: String) -> Bool {
    switch response.result {
    case .success(let value):
        let json = JSON(value)
        if json["error"].bool == true {
            print("😡 \(caller) \(json["message"].string ?? "unknown error")")
            return false
        } else {
            print("😇 \(caller) \(value)")
            return true
        }
    case .failure(let error):
         print("😡 \(caller) \(error.localizedDescription)")
        return false
    }
}



class Networking {
    
    static func modelVersion(cb: @escaping (String) -> ()) {
        Alamofire.request(serverURL + "version")
        .responseJSON { (response) in
            let _ = print(response: response, caller: #function)
            let data = JSON(response.result.value ?? "")[0]["version"].debugDescription
            cb(data)
        }
    }
    
    static func register() {
        Alamofire.request(usersUrl + "register", method: .post, parameters: userCredentials)
            .responseJSON(completionHandler: { (response) in
                 let _ = print(response: response, caller: #function)
        })
    }
    
    static func login() {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: userCredentials["email"]!, password: userCredentials["password"]!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        Alamofire.request(usersUrl + "login", method: .post, headers: headers)
            .responseJSON { response in
                 let _ = print(response: response, caller: #function)
        }
    }
    

    
    static func sendActions() {
    }
    
    static func addGoal(withName name: String, cb: @escaping (Bool) -> ()) {
        let params = [
            "name": name
        ]
        Alamofire.request(goalsUrl + "create", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                if print(response: response, caller: #function) {
                    let json = JSON(response.result.value!)
                    Model.instanse.saveNewGoal(json["name"].string!, id: json["id"].int!)
                    cb(true)
                } else {
                    cb(false)
                }
        }
    }
    
    static func addAction(forGoal goal: Goal, name: String, cb: @escaping (Bool) -> ()) {
        guard let goalId = goal.id as? Int else {
            assert(false)
            return
        }
        let params: [String: Any] = [
            "name": name,
            "parent": goalId,
            "is_done": false
        ]
        
        Alamofire.request(actionsUrl + "create", method: .post, parameters: params, encoding: JSONEncoding.default)
        .responseJSON { response in
            if print(response: response, caller: #function) {
                let json = JSON(response.result.value!)
                Model.instanse.insertAction(goal, name: json["name"].string!, id: json["id"].int!)
                cb(true)
            } else {
                cb(false)
            }
        }
    }
    
    static func remove(goal: Goal, cb: @escaping (Bool) -> ()) {
        guard let id = goal.id as? Int else { return }
        let params = ["id": id]
        Alamofire.request(goalsUrl + "delete", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if print(response: response, caller: #function) {
                    goal.deleteGoal()
                    cb(true)
                } else {
                    cb(false)
                }
        }
    }

    static func remove(action: Action, cb: @escaping (Bool) -> ()) {
        guard let id = action.id as? Int else { return }
        let params = ["id": id]
        Alamofire.request(actionsUrl + "delete", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if print(response: response, caller: #function) {
                    action.deleteAction()
                    cb(true)
                } else {
                    cb(false)
                }
        }
    }
    
    static func rename(action: Action, newName: String, cb: @escaping (Bool) -> ()) {
        guard let id = action.id as? Int else { return }
        let params: [String: Any] = ["id": id, "name": newName]
        Alamofire.request(actionsUrl + "rename", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if print(response: response, caller: #function) {
                    action.name = newName
                    Model.instanse.saveContext()
                    cb(true)
                } else {
                    cb(false)
                }
        }
    }
    
    static func set(done isDone: Bool, action: Action, cb: @escaping (Bool) -> ()) {
        guard let id = action.id as? Int else { return }
        let params: [String: Any] = ["id": id, "is_done": isDone]
        Alamofire.request(actionsUrl + "set_is_done", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if print(response: response, caller: #function) {
                    isDone ? action.setDone() : action.setUndone()
                    cb(true)
                } else {
                    cb(false)
                }
        }
    }
}







