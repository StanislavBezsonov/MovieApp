import SwiftUI

struct OverviewCell: View {
    let overview: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
                .bold()
            
            Text(overview)
                .lineLimit(isExpanded ? nil : 4)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
        .padding()
    }
}
