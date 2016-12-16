import Foundation

public class UserItem: ParsedItem {
    
    /// The property is nil when passed for sign in or sign up operations.
    public let uniqueId: Int!
    
    public let email: String
    public let phoneNumber: String?
    
    public init(uniqueId: Int! = nil, email: String, phoneNumber: String?) {
        self.uniqueId = uniqueId
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
