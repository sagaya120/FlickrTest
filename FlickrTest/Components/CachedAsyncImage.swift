import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let scale: CGFloat
    let transaction: Transaction
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let url = url {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                switch phase {
                case .empty:
                    placeholder()
                case .success(let image):
                    content(image)
                        .transition(.opacity.combined(with: .scale))
                case .failure:
                    Color.gray
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.white)
                        }
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            placeholder()
        }
    }
} 
