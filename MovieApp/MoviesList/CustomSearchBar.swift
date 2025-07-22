import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
                .font(.system(size: 20))

            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.none)
        }
        .padding(.horizontal)
    }
}

