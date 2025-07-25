import SwiftUI

struct KeywordsCell: View {
    let keywords: [Keyword]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keywords")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(keywords) { keyword in
                        Text(keyword.name)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}
