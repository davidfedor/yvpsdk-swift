
import Foundation

public func fetchUserInfo(lat: String,
                   completion: @escaping (String?, String?, String?) -> Void) async {
    
    if lat == "preview" {
        completion("John",
                   "Smith",
                   "12345")
        return
    }
    
    struct AuthMeResponse: Codable {
        let first_name: String
        let last_name: String
        let id: Int
    }
    
    if let url = URL(string: "\(youversion_api_host)/auth/me?lat=\(lat)&platform=iOS") {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(AuthMeResponse.self, from: data) {
                completion(decodedResponse.first_name, decodedResponse.last_name, String(decodedResponse.id))
                return
            }
        } catch {
            print("error in fetchUserInfo: \(error)")
        }
    }
    completion(nil, nil, nil)
}

