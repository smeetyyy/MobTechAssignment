

import UIKit
import FirebaseAuth

class MyProfileVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        let user = StoreSession.shared.getUserProfile()
        self.txtFieldName.text = user.name
        self.txtFieldEmail.text = user.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewMain.roundedCornerBy(radius: 5)
        self.viewName.roundedCornerBy(radius: 5)
        self.viewEmail.roundedCornerBy(radius: 5)
        self.viewLogout.roundedCornerBy(radius: 5)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.performLogout()
    }
    
    func performLogout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
