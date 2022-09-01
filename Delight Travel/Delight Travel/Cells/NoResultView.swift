

import Foundation
import UIKit

class NoResultView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lblNoRecords: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib(nibName: "NoResultView")
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = self.bounds
        addSubview(view)
    }
}
