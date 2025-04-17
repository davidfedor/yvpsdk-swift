
import Foundation

public func fetchVerseOfTheDay(lat: String,
                        trans: Int = 1,
                        completion: @escaping (String?, String?, String?, String?) -> Void) async {
    
    if lat == "preview" {
        completion("John 1:1",
                   "KJV",
                   "In the beginning was the Word, and the Word was with God, and the Word was God. PREVIEW ONLY.",
                   "Copyright goes here.")
        return
    }
    
    struct VotdResponse: Codable {
        let human: String
        let text: String
        let copyright: String
        let abbreviation: String
    }
    
    if let url = URL(string: "\(youversion_api_host)/votd/today?lat=\(lat)&translationId=\(trans)&platform=iOS") {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(VotdResponse.self, from: data) {
                completion(decodedResponse.human, decodedResponse.abbreviation, decodedResponse.text, decodedResponse.copyright)
                return
            }
        } catch {
            print("error in fetchVerseOfTheDay: \(error)")
        }
    }
    completion(nil, nil, nil, nil)
}


