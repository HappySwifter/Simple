//
//  Constants.swift
//  Simple
//
//  Created by Артем Валиев on 21.11.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation

let serverURL = URL(string: "https://limitless-tor-75060.herokuapp.com/")!
//let serverURL = URL(string: "http://0.0.0.0:8088/")!

let registerKey = "mysuperkey"



enum Users: String {
    case register, login, logout
    func getUrl() -> URL {
        return serverURL.appendingPathComponent("users").appendingPathComponent(self.rawValue)
    }
}

enum Goals: String {
    case all, create, delete, model, rename
    func getUrl() -> URL {
        return serverURL.appendingPathComponent("goals").appendingPathComponent(self.rawValue)
    }
}

enum Actions: String {
    case all, create, get, set_is_done, rename, delete
    func getUrl() -> URL {
        return serverURL.appendingPathComponent("actions").appendingPathComponent(self.rawValue)
    }
}
