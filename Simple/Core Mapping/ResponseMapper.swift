import Foundation
import SwiftyJSON

protocol ResponseMapperProtocol {
    associatedtype Item
    static func process(_ obj: JSON?) throws -> Item
}

internal enum ResponseMapperError: Error {
    case invalid
    case missingAttribute
}

class ResponseMapper<A: ParsedItem> {
    
    static func process(_ obj: JSON?, parse: (_ json: [String: JSON]) -> A?) throws -> A {
        guard let json = obj?.dictionary else { throw ResponseMapperError.invalid }
        if let item = parse(json) {
            return item
        } else {
            throw ResponseMapperError.missingAttribute
        }
    }
}
