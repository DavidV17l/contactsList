import UIKit

struct CatFact: Codable {
    var status: Status
    var id, user, text: String
    var v: Int
    var source, updatedAt, type, createdAt: String
    var deleted, used: Bool

    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case user, text
        case v = "__v"
        case source, updatedAt, type, createdAt, deleted, used
    }
}

struct Status: Codable {
    var verified: Bool
    var sentCount: Int
}

enum ClientSection: String, CaseIterable {
    case everything = "everything"
}

struct ClientList {
    var everything: [CatFact]
}

