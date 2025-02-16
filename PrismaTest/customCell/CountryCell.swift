//
//  CountryCell.swift
//  PrismaTest
//
//  Created by saeed shaikh on 06/01/25.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var countryImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
