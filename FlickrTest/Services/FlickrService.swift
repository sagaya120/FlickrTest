import Foundation

protocol FlickrServiceProtocol {
    func searchImages(query: String) async throws -> FlickrResponse
}

class FlickrService: FlickrServiceProtocol {
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    func searchImages(query: String) async throws -> FlickrResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: query)
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(FlickrResponse.self, from: data)
    }
} 