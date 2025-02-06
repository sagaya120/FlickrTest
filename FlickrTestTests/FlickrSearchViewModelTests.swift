import XCTest
@testable import FlickrTest

@MainActor
final class FlickrSearchViewModelTests: XCTestCase {
    var sut: FlickrSearchViewModel!
    var mockService: MockFlickrService!
    
    override func setUp() {
        super.setUp()
        mockService = MockFlickrService()
        sut = FlickrSearchViewModel(flickrService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testEmptyQueryClearsImages() async throws {
        let mockItem = FlickrItem(
            title: "Test",
            link: "https://test.com",
            media: FlickrMedia(m: "https://test.com/image.jpg"),
            dateTaken: "2024-02-06T12:00:00Z",
            description: "Test description",
            author: "Test author"
        )
        mockService.searchResult = .success(FlickrResponse(items: [mockItem]))
        
        sut.search(query: "test")
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(sut.images.count, 1)
        
        sut.search(query: "")
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertTrue(sut.images.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testSuccessfulSearch() async throws {
        let mockItem = FlickrItem(
            title: "Test",
            link: "https://test.com",
            media: FlickrMedia(m: "https://test.com/image.jpg"),
            dateTaken: "2024-02-06T12:00:00Z",
            description: "Test description",
            author: "Test author"
        )
        mockService.searchResult = .success(FlickrResponse(items: [mockItem]))

        sut.search(query: "test")
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertTrue(mockService.searchCalled)
        XCTAssertEqual(mockService.lastSearchQuery, "test")
        XCTAssertEqual(sut.images.count, 1)
        XCTAssertEqual(sut.images.first?.title, "Test")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testFailedSearch() async throws {
        struct TestError: Error {}
        mockService.searchResult = .failure(TestError())
        sut.search(query: "test")
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertTrue(mockService.searchCalled)
        XCTAssertEqual(mockService.lastSearchQuery, "test")
        XCTAssertTrue(sut.images.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
    }
}
