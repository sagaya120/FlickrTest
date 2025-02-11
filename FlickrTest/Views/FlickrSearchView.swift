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
                    ErrorView(error: error) {
                        viewModel.search(query: searchText)
                    }
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
                        CachedAsyncImage(url: item.parsedDescription.thumbnailURL) { image in
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
                        } placeholder: {
                            ProgressView()
                                .accessibilityLabel("Loading thumbnail...")
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

#Preview {
    FlickrSearchView()
} 
