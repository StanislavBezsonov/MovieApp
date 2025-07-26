import SwiftUI

struct KeywordsCell: View {
    let keywords: [Keyword]
    let onKeywordTapped: (Keyword) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keywords")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(keywords) { keyword in
                        Button(action: {
                            onKeywordTapped(keyword)
                        }) {
                            HStack(spacing: 8) {
                                Text(keyword.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}
