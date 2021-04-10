import Foundation

extension Dictionary {
    func toJSON() -> Data {
        let body = try! JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)
        return body
    }
}

extension URL {
    public var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return [:] }
        
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
