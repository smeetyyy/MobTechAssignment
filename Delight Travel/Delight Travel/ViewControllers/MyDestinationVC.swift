
import UIKit
import FirebaseDatabase
import CodableFirebase

class MyDestinationVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var destinations: [Destination] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.configureView()
        self.getMyDestinations()
    }
    
    func configureView() {
        self.tblView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellReuseIdentifier: "DestinationCell")
        self.tblView.estimatedRowHeight = 200
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.separatorStyle = .none
        self.configureBgView()
    }
    
    func configureBgView() {
        let noRecordsView = NoResultView()
        self.tblView.backgroundView = noRecordsView
        self.tblView.backgroundView?.isHidden = true
    }
    
    func getMyDestinations() {
        AppUtility.shared.showLoader(self)
        self.ref.child("Destinations").queryOrdered(byChild: "postedById").queryEqual(toValue: StoreSession.shared.getUserProfile().id).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            AppUtility.shared.dismissLoader()
            self.destinations.removeAll()
            let value = snapshot.value as? [String: Any]
            guard let destinations = value else {
                self.tblView.backgroundView?.isHidden = false
                self.tblView.reloadData()
                return
            }
            
            self.tblView.backgroundView?.isHidden = true
            for destination in destinations {
                do {
                    let dest = try FirebaseDecoder().decode(Destination.self, from: destination.value)
                    self.destinations.append(dest)
                } catch {
                    AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "Something went wrong.", onVC: self)
                }
            }
            
            self.tblView.reloadData()
            
        }) { error in
            print(error.localizedDescription)
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MyDestinationVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        cell.selectionStyle = .none
        let destination = self.destinations[indexPath.row]
        cell.setupData(imgUrl: destination.imgURL ?? "", title: destination.title ?? "", description: destination.description ?? "")
        return cell
    }
    
}
