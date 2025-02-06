import XCTest
@testable import FlickrTest

final class FlickrDescriptionParserTests: XCTestCase {
    func testParseValidDescription() {
        let htmlString = #" <p><a href="https://www.flickr.com/people/crobart/">crobart</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/crobart/54309724292/" title="AAL_2907"><img src="https://live.staticflickr.com/65535/54309724292_e4f8c6b346_m.jpg" width="240" height="160" alt="AAL_2907" /></a></p> "#
        
        let parsed = FlickrDescriptionParser.parse(htmlString)
        XCTAssertEqual(parsed.authorURL?.absoluteString, "https://www.flickr.com/people/crobart/")
        XCTAssertEqual(parsed.authorName, "crobart")
        XCTAssertEqual(parsed.photoURL?.absoluteString, "https://www.flickr.com/photos/crobart/54309724292/")
        XCTAssertEqual(parsed.photoTitle, "AAL_2907")
        XCTAssertEqual(parsed.thumbnailURL?.absoluteString, "https://live.staticflickr.com/65535/54309724292_e4f8c6b346_m.jpg")
        XCTAssertEqual(parsed.thumbnailWidth, 240)
        XCTAssertEqual(parsed.thumbnailHeight, 160)
    }
    
    func testParseInvalidDescription() {
        let htmlString = "Invalid HTML string"
        let parsed = FlickrDescriptionParser.parse(htmlString)
        
        XCTAssertNil(parsed.authorURL)
        XCTAssertEqual(parsed.authorName, "")
        XCTAssertNil(parsed.photoURL)
        XCTAssertEqual(parsed.photoTitle, "")
        XCTAssertNil(parsed.thumbnailURL)
        XCTAssertEqual(parsed.thumbnailWidth, 0)
        XCTAssertEqual(parsed.thumbnailHeight, 0)
    }
}
