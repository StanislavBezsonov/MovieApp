import SwiftUI

struct CircularRatingView: View {
    let rating: Double
    let textColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0, to: CGFloat(min(rating / 10, 1)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(rating >= 7 ? .green : rating >= 4 ? .yellow : .red)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: rating)

            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundColor(textColor)
                .bold()
        }
        .frame(width: 35, height: 35)
    }
}
