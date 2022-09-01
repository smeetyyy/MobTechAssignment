

import UIKit
import AlamofireImage

class DestinationCell: UITableViewCell {
    
    @IBOutlet weak var imgViewDest: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewParent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureView() {
        self.imgViewDest.roundedCornerBy(radius: 8)
        self.viewParent.roundedCornerBy(radius: 8)
        self.viewParent.showShadow(radius: 3, opacity: 0.3)
    }
    
    func setupData(imgUrl: String, title: String, description: String) {
        if let url = URL(string: imgUrl) {
            self.imgViewDest.af.setImage(withURL: url)
        } else {
            self.imgViewDest.image = UIImage(named: "AppBg")
        }
        self.lblTitle.text = title
        self.lblDescription.text = description
    }
}
