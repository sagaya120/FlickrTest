import Foundation
import Combine
import SwiftUI

@MainActor
class FlickrSearchViewModel: ObservableObject {
    @Published private(set) var images: [FlickrItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let flickrService: FlickrServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    
    init(flickrService: FlickrServiceProtocol = FlickrService()) {
        self.flickrService = flickrService
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) {
        searchSubject.send(query)
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            images = []
            isLoading = false
            return
        }
        
        isLoading = true
        error = nil
        
        searchTask = Task {
            do {
                let response = try await flickrService.searchImages(query: query)
                guard !Task.isCancelled else { return }
                images = response.items
            } catch {
                guard !Task.isCancelled else { return }
                self.error = error
            }
            isLoading = false
        }
    }
} 
