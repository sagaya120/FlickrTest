import XCTest
@testable import FlickrTest

class MockFlickrService: FlickrServiceProtocol {
    var searchResult: Result<FlickrResponse, Error> = .success(FlickrResponse(items: []))
    var searchCalled = false
    var lastSearchQuery: String?
    
    func searchImages(query: String) async throws -> FlickrResponse {
        searchCalled = true
        lastSearchQuery = query
        return try searchResult.get()
    }
}
