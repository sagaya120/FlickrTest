import Foundation
import Combine
import SwiftUI

@MainActor
class FlickrSearchViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([FlickrItem])
        case error(Error)
        
        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
        
        var error: Error? {
            if case .error(let error) = self { return error }
            return nil
        }
        
        var images: [FlickrItem] {
            if case .loaded(let images) = self { return images }
            return []
        }
    }
    
    @Published private(set) var state: State = .idle
    private let flickrService: FlickrServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let searchSubject = PassthroughSubject<String, Never>()
    private let debounceInterval: TimeInterval
    
    var images: [FlickrItem] { state.images }
    var isLoading: Bool { state.isLoading }
    var error: Error? { state.error }
    
    init(
        flickrService: FlickrServiceProtocol = FlickrService(),
        debounceInterval: TimeInterval = 0.3
    ) {
        self.flickrService = flickrService
        self.debounceInterval = debounceInterval
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
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
            state = .idle
            return
        }
        
        state = .loading
        
        searchTask = Task {
            do {
                let response = try await flickrService.searchImages(query: query)
                guard !Task.isCancelled else { return }
                
                if response.items.isEmpty {
                    state = .error(FlickrError.emptyResults)
                } else {
                    state = .loaded(response.items)
                }
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(FlickrError.networkError(error))
            }
        }
    }
    
    deinit {
        searchTask?.cancel()
        cancellables.removeAll()
    }
} 
