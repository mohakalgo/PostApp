//
//  PostTCell.swift
//  PostApp
//
//  Created by Aglowid IT Solutions on 03/12/21.
//

import UIKit

class PostTCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var obj : PostListModelElement? {
        didSet {
            lblTitle.text = obj?.title ?? ""
            lblDesc.text = obj?.body ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
