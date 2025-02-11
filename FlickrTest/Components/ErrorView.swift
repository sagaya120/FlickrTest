import SwiftUI

struct ErrorView: View {
    let error: Error
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .accessibilityHidden(true)
                .accessibilityAddTraits(.isImage)

            Text(error.localizedDescription)
                .font(.headline)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isStaticText)

            if let recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion {
                Text(recoverySuggestion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
            }
            
            Button(action: retryAction) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .accessibilityHint("Retries the last search")
            .accessibilityAddTraits(.isButton)
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error occurred")
    }
} 
