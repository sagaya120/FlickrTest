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
                AsyncImage(url: item.media.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .accessibilityLabel("Loading full resolution image...")
                            .accessibilityValue("Please wait while the full resolution image loads")
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .clipped()
                            .accessibilityLabel("Full size photo: \(item.title)")
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .accessibilityLabel("Failed to load full resolution image")
                            .accessibilityHint("The image could not be loaded. Try going back and opening the image again.")
                    @unknown default:
                        EmptyView()
                    }
                }
                .animation(reduceMotion ? nil : .spring(), value: horizontalSizeClass)
                .navigationTransition(.zoom(sourceID: item, in: namespace))

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .dynamicTypeSize(...dynamicTypeSize)
                        .accessibilityAddTraits(.isHeader)
                    
                    Link("By \(item.parsedDescription.authorName)",
                         destination: item.parsedDescription.authorURL ?? URL(string: "https://www.flickr.com")!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .dynamicTypeSize(...dynamicTypeSize)
                        .accessibilityLabel("Author: \(item.parsedDescription.authorName)")
                        .accessibilityHint("Tap to visit author's Flickr profile")
                    
                    Text(formatDate(item.dateTaken))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...dynamicTypeSize)
                        .accessibilityLabel("Published: \(formatDate(item.dateTaken))")
                    
                    Text("Original dimensions: \(item.parsedDescription.thumbnailWidth)×\(item.parsedDescription.thumbnailHeight)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...dynamicTypeSize)
                        .accessibilityLabel("Original image dimensions: \(item.parsedDescription.thumbnailWidth) by \(item.parsedDescription.thumbnailHeight) pixels")
                }
                .padding()
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Image Details")
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(
                    item: item.parsedDescription.photoURL?.absoluteString ?? "",
                    subject: Text(item.title),
                    message: Text("")
                )
                .accessibilityLabel("Share photo")
                .accessibilityHint("Share this photo with others")
            }
        }
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
