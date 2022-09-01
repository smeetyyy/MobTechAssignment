

import Foundation
import UIKit
import MBProgressHUD

class AppUtility {
    
    static let shared = AppUtility()
    private var hud : MBProgressHUD!
    
    func showAlert(withTitle title:String , andMessage message:String, onVC vc: UIViewController) -> Void{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showLoader(withText: String? = nil, _ vc: UIViewController) {
        if hud == nil {
            self.hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
            self.hud.mode = .indeterminate
            self.hud.label.text = withText ?? "Loading"
        }
        
    }
    
    func showLoaderOnView(view: UIView) {
        if hud == nil {
            self.hud = MBProgressHUD.showAdded(to: view, animated: true)
            self.hud.mode = .indeterminate
            self.hud.bezelView.style = .solidColor
            self.hud.bezelView.backgroundColor = .clear
        }
    }
    
    func dismissLoader() {
        if hud != nil {
            self.hud.hide(animated: true)
            hud = nil
        }
    }
}
