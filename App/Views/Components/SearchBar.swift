import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "BUSCAR..."

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .font(.subheadline)

            TextField(placeholder, text: $text)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.white)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(14)
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gymBorder, lineWidth: 1))
    }
}
