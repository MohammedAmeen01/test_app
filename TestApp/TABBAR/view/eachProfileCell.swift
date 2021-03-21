//
//  eachProfileCell.swift
//  TestApp
//
//  Created by Rahul Sharma on 21/03/21.
//

import UIKit

class eachProfileCell: UITableViewCell {

    @IBOutlet weak var profilePicIV : UIImageView!
    @IBOutlet weak var profileNameLbl : UILabel!
    @IBOutlet weak var profileGenderLbl : UILabel!
    @IBOutlet weak var profileEmailLbl : UILabel!
    @IBOutlet weak var profilePhoneLbl : UILabel!
    @IBOutlet weak var profileFvtColorLbl : UILabel!
    @IBOutlet weak var ageLbl : UILabel!
    
    @IBOutlet weak var likedBtn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
