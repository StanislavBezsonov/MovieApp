import SwiftUI

struct ReviewsView: View {
    let reviews: [Review]

    var body: some View {
        List(reviews, id: \.id) { review in
            VStack(alignment: .leading, spacing: 8) {
                Text(review.author)
                    .font(.headline)
                Text(review.content)
                    .font(.body)
                    .lineLimit(nil)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Reviews")
    }
}
