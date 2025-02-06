import Foundation

struct ParsedDescription {
    let authorURL: URL?
    let authorName: String
    let photoURL: URL?
    let photoTitle: String
    let thumbnailURL: URL?
    let thumbnailWidth: Int
    let thumbnailHeight: Int
    
    static let empty = ParsedDescription(
        authorURL: nil,
        authorName: "",
        photoURL: nil,
        photoTitle: "",
        thumbnailURL: nil,
        thumbnailWidth: 0,
        thumbnailHeight: 0
    )
}
