import SwiftUI

struct VotdView: View {
    let votdTitle: String
    let votdText: String
    let votdCopyright: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(votdTitle)
                .font(.title.bold())
            Text(votdText)
                .font(.body)
                .padding(.vertical)
            Text(votdCopyright)
                .font(.caption)
        }
        .padding()
    }
}

#Preview {
    VotdView(
        votdTitle: "Today's Verse",
        votdText: "For God so loved the world...",
        votdCopyright: "John 3:16"
    )
}
