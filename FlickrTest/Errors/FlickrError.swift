import Foundation

enum FlickrError: LocalizedError {
    case networkError(Error)
    case invalidResponse
    case emptyResults
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .emptyResults:
            return "No images found for your search"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again"
        case .invalidResponse:
            return "Please try again later"
        case .emptyResults:
            return "Try different search terms"
        }
    }
} 