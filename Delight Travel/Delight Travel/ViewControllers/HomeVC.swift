

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var viewDestList: UIView!
    @IBOutlet weak var viewAddDest: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewMyDest: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDestList.roundedCornerBy(radius: 5)
        self.viewAddDest.roundedCornerBy(radius: 5)
        self.viewProfile.roundedCornerBy(radius: 5)
        self.viewMyDest.roundedCornerBy(radius: 5)
        
        self.viewDestList.showShadow(radius: 5, opacity: 0.6)
        self.viewAddDest.showShadow(radius: 5, opacity: 0.6)
        self.viewProfile.showShadow(radius: 5, opacity: 0.6)
        self.viewMyDest.showShadow(radius: 5, opacity: 0.6)
    }
    
    @IBAction func destinationListPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toDestinationListVC", sender: nil)
    }
    
    @IBAction func myDestinationPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toMyDestinationVC", sender: nil)
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toMyProfileVC", sender: nil)
    }
    
    
    @IBAction func addDestinationPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddDestinationVC", sender: nil)
    }
    
    
}
