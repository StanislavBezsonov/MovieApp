import SwiftUI

struct ReviewRow: View {
    let review: Review
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.author)
                .font(.headline)
            
            Text(review.content)
                .lineLimit(isExpanded ? nil : 4)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if review.content.count > 200 {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Read Less" : "Read More")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}

struct ReviewsView: View {
    let reviews: [Review]

    var body: some View {
        List(reviews, id: \.id) { review in
            ReviewRow(review: review)
        }
        .navigationTitle("Reviews")
    }
}
