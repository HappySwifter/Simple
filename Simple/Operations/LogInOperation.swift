//
//  LogInOperation.swift
//  Simple
//
//  Created by guest2 on 19.12.16.
//  Copyright © 2016 Артем Валиев. All rights reserved.
//

import Foundation
import SwiftyJSON

public class LogInOperation: ServiceOperation {
    
    private let request: LogInRequest
    
    public var success: ((UserItem) -> Void)? = nil
    public var failure: ((NSError) -> Void)? = nil
    
    public init(email: String, password: String) {
        self.request = LogInRequest(email: email, password: password)
        super.init()
    }
    
    public override func start() {
        super.start()
        service.request(request, success: handleSuccess, failure: handleFailure)
    }
    
    private func handleSuccess(_ response: JSON?) {
        do {
            let item = try UserResponseMapper.process(response)
            self.success?(item)
            self.finish()
        } catch {
            handleFailure(NSError.cannotParseResponse())
        }
    }
    
    private func handleFailure(_ error: NSError) {
        print("😡  \(error.localizedDescription)")
        self.failure?(error)
        self.finish()
    }
}
