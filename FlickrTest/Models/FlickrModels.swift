import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrItem]
}

struct FlickrItem: Codable, Identifiable, Hashable {
    let title: String
    let link: String
    let media: FlickrMedia
    let dateTaken: String
    let description: String
    let author: String
    
    var id: String { link }
    
    var parsedDescription: ParsedDescription {
        FlickrDescriptionParser.parse(description)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, author
    }
}

struct FlickrMedia: Codable, Hashable {
    let m: String
    
    var imageURL: URL? {
        URL(string: m)
    }
} 
