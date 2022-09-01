

import Foundation

// MARK: - AppUser
struct Destination: Codable {
    let description, id: String?
    let imgURL: String?
    let title: String?
    let postedById: String?

    enum CodingKeys: String, CodingKey {
        case description
        case id
        case imgURL = "imgUrl"
        case title
        case postedById
    }
}
