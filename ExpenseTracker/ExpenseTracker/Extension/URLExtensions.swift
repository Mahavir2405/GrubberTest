
import Foundation

extension URL {
    var queryItems:[URLQueryItem] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else
        {
            return []
        }
        return queryItems
    }
}
