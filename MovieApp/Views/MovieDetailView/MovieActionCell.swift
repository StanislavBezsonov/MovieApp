import SwiftUI

struct MovieActionCell: View {
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                print("Wishlist tapped")
            }) {
                Text("Wishlist")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                print("Seenlist tapped")
            }) {
                Text("Seenlist")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                print("List tapped")
            }) {
                Text("List")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }
}
