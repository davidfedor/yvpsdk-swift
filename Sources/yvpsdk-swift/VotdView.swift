import SwiftUI

public struct VotdView: View {
    public let votdTitle: String
    public let votdText: String
    public let votdCopyright: String
    
    public init(votdTitle: String, votdText: String, votdCopyright: String) {
        self.votdTitle = votdTitle
        self.votdText = votdText
        self.votdCopyright = votdCopyright
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(votdTitle)
                .font(.title.bold())
            Text(votdText)
                .font(.body)
                .padding(.vertical)
            Text(votdCopyright)
                .font(.caption)
        }
    }
}

#Preview {
    VotdView(
        votdTitle: "Today's Verse",
        votdText: "For God so loved the world...",
        votdCopyright: "John 3:16"
    ).padding()
}
