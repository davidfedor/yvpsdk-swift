import AuthenticationServices
import Foundation

public enum YVPPermission: String, CaseIterable, Hashable, Codable, CustomStringConvertible {
    case bibles = "bibles"
    case highlights = "highlights"
    case votd = "votd"
    case demographics = "demographics"
    case bibleActivity = "bible_activity"

    public var description: String { rawValue }

    public static var all: [YVPPermission] { Self.allCases }
}

public func doBibleSDKLogin(appYvId: String,
                             contextProvider: ASWebAuthenticationPresentationContextProviding,
                              required: Set<YVPPermission>,
                              optional: Set<YVPPermission>,
                     completion: @escaping (_ lat: String?, _ permissions: [YVPPermission], _ errorMsg: String?) -> Void) {
    let nonce = generateNonce()
    guard let authURL = buildAuthURL(appYvId: appYvId,
                                     nonce: nonce,
                                     requiredPermissions: Array(required),
                                     optionalPermissions: Array(optional)
    ) else {
        completion(nil, [], "Invalid authentication URL")
        return
    }
    
    let session = ASWebAuthenticationSession(
        url: authURL,
        callbackURLScheme: "youversionauth"
    ) { callbackURL, error in
        if let error = error {
            completion(nil, [], error.localizedDescription)
        } else if let callbackURL = callbackURL {
            let (lat, permissions, errorMsg) = parseAuthCallback(callbackURL, nonce: nonce)
            completion(lat, permissions, errorMsg)
        } else {
            let errorMessage = "missing authURL; this shouldn't happen."
            print(errorMessage)
            completion(nil, [], errorMessage)
        }
    }
    
    session.presentationContextProvider = contextProvider
    session.start()
}
    

private func buildAuthURL(appYvId: String, nonce: String, requiredPermissions: [YVPPermission] = [], optionalPermissions: [YVPPermission] = []) -> URL? {
    let rp = requiredPermissions.map { $0.rawValue }.joined(separator: ",")
    let op = optionalPermissions.map { $0.rawValue }.joined(separator: ",")
    return URL(string: "\(youversion_api_host)/login-with-youversion?clientId=\(appYvId)&nonce=\(nonce)&rp=\(rp)&op=\(op)")
}

private func parseAuthCallback(_ callbackURL: URL, nonce: String) -> (String?, [YVPPermission], String?) {
    if let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
       let queryItems = components.queryItems {
        let status = queryItems.first(where: { $0.name == "status" })?.value
        let returnedNonce = queryItems.first(where: { $0.name == "nonce" })?.value
        let latValue = queryItems.first(where: { $0.name == "lat" })?.value
        let permissions = queryItems.first(where: { $0.name == "permissions" })?.value
        let perms = permissions?
            .split(separator: ",")
            .compactMap { YVPPermission(rawValue: String($0)) }
            ?? []
        
        if status == "success", let returnedNonce = returnedNonce, returnedNonce == nonce, let latValue = latValue {
            return (latValue, perms, nil)  // success!
        } else if status != "canceled" {
            return (nil, perms, callbackURL.query())  // error!
        }
    }
    return (nil, [], nil)  // the callback didn't have the expected params
}


/// returns a nonce suitable for passing to the login API
private func generateNonce(length: Int = 32) -> String {
    let charset: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    var result = ""
    for _ in 0..<length {
        if let randomChar = charset.randomElement() {
            result.append(randomChar)
        }
    }
    return result
}
