

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewMain.roundedCornerBy(radius: 5)
        self.viewName.roundedCornerBy(radius: 5)
        self.viewEmail.roundedCornerBy(radius: 5)
        self.viewPassword.roundedCornerBy(radius: 5)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.createUser()
    }
    
}

extension SignUpVC {
    
    func createUser() {
        if !self.validateInput() { return }
        AppUtility.shared.showLoader(self)
        Auth.auth().createUser(withEmail: self.txtFieldEmail.text ?? "", password: self.txtFieldPassword.text ?? "") { [weak self] authResult, error in
            guard let self = self else { return }
            if error != nil {
                AppUtility.shared.dismissLoader()
                AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "Something went wrong.", onVC: self)
                return
            }
            self.createUserInDb(userUid: authResult?.user.uid ?? "", email: authResult?.user.email ?? "", name: self.txtFieldName.text ?? "")
        }
    }
    
    func validateInput() -> Bool {
        if self.txtFieldEmail.text == "" || self.txtFieldName.text == "" || self.txtFieldPassword.text == "" {
            AppUtility.shared.showAlert(withTitle: "Error", andMessage: "Please enter all the fields.", onVC: self)
            return false
        }
        return true
    }
    
    func createUserInDb(userUid: String, email: String, name: String = "") {
        let thread = self.ref.child("AppUsers").child(userUid)
        
        let data: [String: Any] = [
            "userUid": userUid,
            "userEmail": email,
            "userFullName": name,
        ]
        
        thread.setValue(data) { [weak self] error, ref in
            guard let self = self else { return }
            AppUtility.shared.dismissLoader()
            if error != nil {
                AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "Something went wrong.", onVC: self)
            }
            let user = AppUser(userEmail: email, userFullName: name, userUid: userUid)
            StoreSession.shared.setAppUser(user: user)
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
    }

}
