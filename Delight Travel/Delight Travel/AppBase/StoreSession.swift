

import Foundation

class StoreSession {
    
    var appUserData: AppUser?
    
    static let shared = StoreSession()
    
    func setAppUser(user: AppUser) {
        self.appUserData = user
    }
    
    func getUserProfile() -> (id: String, name: String, email: String) {
        
        if let user = appUserData {
            return (id: user.userUid ?? "", name: user.userFullName ?? "", email: user.userEmail ?? "")
        }
        
        return (id: "", name: "", email: "")
    }
}
