

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddDestinationVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    var imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    var storage : Storage!
    private var imgDownloadUrl: String = ""
    private var isImgSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.ref = Database.database().reference()
    }
    
    func configureView() {
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(self.imgPressed))
        tabGesture.numberOfTapsRequired = 1
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tabGesture)
    }
    
    
    func showUploadOptions() {
        let alert = UIAlertController(title: "Upload Picture", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.configureImagePicker(isCamera: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.configureImagePicker(isCamera: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func configureImagePicker(isCamera: Bool) {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if isCamera {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "This device doesn't support camera.", onVC: self)
                return
            }
        }
        self.imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imgPressed() {
        print("img pressed")
        self.showUploadOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewMain.roundedCornerBy(radius: 5)
        self.imgView.roundedCornerBy(radius: 5)
        self.viewName.roundedCornerBy(radius: 5)
        self.viewDescription.roundedCornerBy(radius: 5)
        self.viewBtn.roundedCornerBy(radius: 5)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        self.uploadPicture()
    }
    
    func uploadPicture() {
        if !self.validateInput() { return }
        if !self.isImgSelected {
            self.addDestination()
            return
        }
        self.storage = FirebaseStorage.Storage.storage()
        let storageRef = storage.reference()
        let imgName = NSUUID().uuidString
        let profileImagesRef = storageRef.child("destination_pictures/\(imgName).jpg")
        
        let data = self.imgView.image!.pngData()!
        AppUtility.shared.showLoader(self)
        _ = profileImagesRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                AppUtility.shared.dismissLoader()
                AppUtility.shared.showAlert(withTitle: "Error", andMessage: "Something went wrong.", onVC: self)
                return
            }
            _ = metadata.size
            profileImagesRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    AppUtility.shared.dismissLoader()
                    AppUtility.shared.showAlert(withTitle: "Error", andMessage: "Something went wrong.", onVC: self)
                    return
                }
                self.imgDownloadUrl = "\(downloadURL)"
                self.addDestination()
            }
        }
    }
    
    func addDestination() {
        let thread = self.ref.child("Destinations").childByAutoId()
        
        
        let data: [String: Any] = [
            "id": thread.key ?? "",
            "title": self.txtFieldTitle.text!,
            "description": self.txtDescription.text!,
            "imgUrl": self.imgDownloadUrl,
            "postedById": StoreSession.shared.getUserProfile().id
        ]
        
        thread.setValue(data) { [weak self] error, ref in
            guard let self = self else { return }
            AppUtility.shared.dismissLoader()
            if error != nil {
                AppUtility.shared.showAlert(withTitle: "Oops!", andMessage: "Something went wrong.", onVC: self)
            }
            AppUtility.shared.showAlert(withTitle: "Success", andMessage: "Destination Added.", onVC: self)
            self.clearData()
        }
    }
    
    func clearData() {
        self.imgView.image = UIImage(named: "image_placeholder")
        self.txtFieldTitle.text = ""
        self.txtDescription.text = ""
    }
    
    func validateInput() -> Bool {
        if self.txtFieldTitle.text == "" || self.txtDescription.text == "" {
            AppUtility.shared.showAlert(withTitle: "Error", andMessage: "Please enter the required fields.", onVC: self)
            return false
        }
        return true
    }
}


//images
extension AddDestinationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let img = image.jpeg(.lowest) ?? Data()
                let imgNew = UIImage(data: img)
                self.imgView.image = imgNew
                self.isImgSelected = true
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("something went wrong")
            }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
