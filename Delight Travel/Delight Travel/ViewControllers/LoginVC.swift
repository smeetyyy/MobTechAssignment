
import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.checkForAutoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewMain.roundedCornerBy(radius: 5)
        self.viewEmail.roundedCornerBy(radius: 5)
        self.viewPassword.roundedCornerBy(radius: 5)
        self.viewBtn.roundedCornerBy(radius: 5)
        
    }

    func checkForAutoLogin() {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            AppUtility.shared.showLoader(self)
            self.ref.child("AppUsers").queryOrdered(byChild: "userUid").queryEqual(toValue: Auth.auth().currentUser?.uid ?? "").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let self = self else { return }
                AppUtility.shared.dismissLoader()
                let value = snapshot.value as? [String: Any]
                guard let appUser = value else {
                    return
                }
                for user in appUser {
                    do {
                        let item = try FirebaseDecoder().decode(AppUser.self, from: user.value)
                        StoreSession.shared.setAppUser(user: item)
                        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
            }) { error in
                AppUtility.shared.dismissLoader()
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.performLogin()
    }

}

//Password login
extension LoginVC {
    
    func getUser() {
        if let user = Auth.auth().currentUser {
            self.ref.child("AppUsers").queryOrdered(byChild: "userUid").queryEqual(toValue: user.uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let self = self else { return }
                AppUtility.shared.dismissLoader()
                let value = snapshot.value as? [String: Any]
                guard let appUser = value else {
                    return
                }
                for user in appUser {
                    do {
                        let item = try FirebaseDecoder().decode(AppUser.self, from: user.value)
                        StoreSession.shared.setAppUser(user: item)
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                    } catch {
                        AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "Something went wrong.", onVC: self)
                    }
                }
            })
        }
    }

    
    func performLogin() {
        
        if !self.validateInput() { return }
        AppUtility.shared.showLoader(self)
        Auth.auth().signIn(withEmail: self.txtFieldEmail.text ?? "", password: self.txtFieldPassword.text ?? "") { [weak self] authResult, error in
            guard let self = self else { return }
            if error != nil {
                AppUtility.shared.dismissLoader()
                AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: error?.localizedDescription ?? "", onVC: self)
                return
            }
            self.getUser()
        }
    }
    
    func validateInput() -> Bool {
        if self.txtFieldEmail.text == "" || self.txtFieldPassword.text == "" {
            AppUtility.shared.showAlert(withTitle: "Error", andMessage: "Please enter all the fields.", onVC: self)
            return false
        }
        return true
    }
    
}
