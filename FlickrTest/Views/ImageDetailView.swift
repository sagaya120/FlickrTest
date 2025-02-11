import SwiftUI

struct ImageDetailView: View {
    let item: FlickrItem
    @State private var imageSize: CGSize = .zero
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(
                    url: item.media.imageURL,
                    transaction: .init(animation: reduceMotion ? nil : .spring())
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .clipped()
                        .accessibilityLabel("Full size photo: \(item.title)")
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .accessibilityLabel("Loading full resolution image...")
                }
                .navigationTransition(.zoom(sourceID: item, in: namespace))

                VStack(alignment: .leading, spacing: 12) {
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .dynamicTypeSize(...dynamicTypeSize)
                        .accessibilityAddTraits(.isHeader)
                    
                    if let authorURL = item.parsedDescription.authorURL {
                        Link("By \(item.parsedDescription.authorName)",
                             destination: authorURL)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .dynamicTypeSize(...dynamicTypeSize)
                    } else {
                        Text("By \(item.parsedDescription.authorName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .dynamicTypeSize(...dynamicTypeSize)
                    }
                    
                    Text(formatDate(item.dateTaken))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let dimensions = imageDimensions {
                        Text(dimensions)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
    }
    
    private var shareButton: some View {
        ShareLink(
            item: item.parsedDescription.photoURL?.absoluteString ?? "",
            subject: Text(item.title),
            message: Text("Check out this photo on Flickr")
        )
        .disabled(item.parsedDescription.photoURL == nil)
        .accessibilityLabel("Share photo")
    }
    
    private var imageDimensions: String? {
        guard item.parsedDescription.thumbnailWidth > 0,
              item.parsedDescription.thumbnailHeight > 0 else {
            return nil
        }
        return "Original dimensions: \(item.parsedDescription.thumbnailWidth)×\(item.parsedDescription.thumbnailHeight)"
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    FlickrSearchView()
}
