

import Foundation

// MARK: - AppUser
struct AppUser: Codable {
    let userEmail, userFullName, userUid: String?

    enum CodingKeys: String, CodingKey {
        case userEmail, userFullName
        case userUid
    }
}
