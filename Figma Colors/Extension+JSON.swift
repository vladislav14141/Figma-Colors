import Foundation

extension Dictionary {
    func toJSON() -> Data {
        let body = try! JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)
        return body
    }
}

