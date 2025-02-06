import Foundation

class FlickrDescriptionParser {
    static func parse(_ htmlString: String) -> ParsedDescription {
        guard let authorURLRange = htmlString.range(of: #"<a href="([^"]+)">([^<]+)</a>"#, options: .regularExpression),
              let photoURLRange = htmlString.range(of: #"<a href="([^"]+)" title="([^"]+)">"#, options: .regularExpression),
              let imgRange = htmlString.range(of: #"<img src="([^"]+)" width="(\d+)" height="(\d+)""#, options: .regularExpression)
        else {
            return .empty
        }
        
        let authorMatch = String(htmlString[authorURLRange])
        let authorURL = extractURL(from: authorMatch)
        let authorName = extractContent(between: ">", and: "</a>", from: authorMatch)
        
        let photoMatch = String(htmlString[photoURLRange])
        let photoURL = extractURL(from: photoMatch)
        let photoTitle = extractAttribute(named: "title", from: photoMatch) ?? ""
        
        let imgMatch = String(htmlString[imgRange])
        let thumbnailURL = extractAttribute(named: "src", from: imgMatch).flatMap { URL(string: $0) }
        let width = Int(extractAttribute(named: "width", from: imgMatch) ?? "0") ?? 0
        let height = Int(extractAttribute(named: "height", from: imgMatch) ?? "0") ?? 0
        
        return ParsedDescription(
            authorURL: authorURL,
            authorName: authorName,
            photoURL: photoURL,
            photoTitle: photoTitle,
            thumbnailURL: thumbnailURL,
            thumbnailWidth: width,
            thumbnailHeight: height
        )
    }
    
    private static func extractURL(from string: String) -> URL? {
        guard let urlString = extractAttribute(named: "href", from: string) else { return nil }
        return URL(string: urlString)
    }
    
    private static func extractAttribute(named attribute: String, from string: String) -> String? {
        let pattern = #"\#(attribute)="([^"]+)""#
        guard let range = string.range(of: pattern, options: .regularExpression),
              let valueRange = string[range].range(of: #""([^"]+)""#, options: .regularExpression) else {
            return nil
        }
        let value = string[valueRange]
        return String(value.dropFirst().dropLast())
    }
    
    private static func extractContent(between start: String, and end: String, from string: String) -> String {
        guard let startRange = string.range(of: start),
              let endRange = string.range(of: end) else {
            return ""
        }
        let content = string[startRange.upperBound..<endRange.lowerBound]
        return String(content)
    }
}
