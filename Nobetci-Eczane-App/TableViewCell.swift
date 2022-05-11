//
//  TableViewCell.swift
//  Nobetci-Eczane-App
//
//  Created by Eyüp Emre Aygün on 11.05.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDist: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
