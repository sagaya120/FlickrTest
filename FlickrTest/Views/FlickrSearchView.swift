import SwiftUI
import Combine

struct FlickrSearchView: View {
    @StateObject private var viewModel = FlickrSearchViewModel()
    @State private var searchText = ""
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    
    private var columns: [GridItem] {
        let count = horizontalSizeClass == .regular ? 4 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("Searching for images")
                } else if let error = viewModel.error {
                    ErrorView(error: error)
                } else {
                    imageGrid
                }
            }
            .navigationTitle("Flickr Search")
            .searchable(text: $searchText, prompt: "Search images...")
            .accessibilityHint("Enter keywords to search for Flickr photos")
            .onChange(of: searchText) { query in
                viewModel.search(query: query)
            }
        }
    }
    
    private var imageGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.images) { item in
                    NavigationLink {
                        ImageDetailView(item: item, namespace: namespace)
                    } label: {
                        AsyncImage(url: item.parsedDescription.thumbnailURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                                    .accessibilityLabel("Loading thumbnail...")
                                    .accessibilityValue("Please wait while the image loads")
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 100)
                                    .clipped()
                                    .accessibilityLabel("Photo titled: \(item.title)")
                                    .accessibilityHint("Tap to view details")
                                    .accessibilityIdentifier("exampleImage")
                                    .accessibilityAddTraits(.isButton)
                                    .dynamicTypeSize(.large)
                                    .matchedTransitionSource(id: item, in: namespace)
                            case .failure:
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .frame(width: 100, height: 100)
                                    .accessibilityLabel("Failed to load image")
                                    .accessibilityHint("The image could not be loaded. Try refreshing the page.")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .animation(reduceMotion ? nil : .spring(), value: horizontalSizeClass)
            .accessibilityLabel("Search Results")
            .accessibilityValue("\(viewModel.images.count) images found")
        }
    }
}

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
                .accessibilityHidden(true)
            Text("Error: \(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .accessibilityLabel("Search error occurred")
                .accessibilityValue(error.localizedDescription)
                .accessibilityHint("Try adjusting your search terms or check your internet connection")
        }
        .padding()
    }
}

#Preview {
    FlickrSearchView()
} 
