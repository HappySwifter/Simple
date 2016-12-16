import Foundation
import SwiftyJSON

final class UserResponseMapper: ResponseMapper<UserItem>, ResponseMapperProtocol {
    
    static func process(_ obj: JSON?) throws -> UserItem {
        return try process(obj, parse: { json in
            let uniqueId = json["id"]?.int
            let email = json["email"]?.string
            let phoneNumber = json["phone_number"]?.string
            
            if let uniqueId = uniqueId, let email = email {
                return UserItem(uniqueId: uniqueId, email: email, phoneNumber: phoneNumber)
            }
            return nil
        })
    }
}
