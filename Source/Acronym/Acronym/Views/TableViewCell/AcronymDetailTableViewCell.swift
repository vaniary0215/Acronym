//
//  AcronymDetailTableViewCell.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit

class AcronymDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDetails:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadData(item:Acronym) {
        lblTitle.text = item.lf
        lblDetails.text = item.allVars
    }
    
}
