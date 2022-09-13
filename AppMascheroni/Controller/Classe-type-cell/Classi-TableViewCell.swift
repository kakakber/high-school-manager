//
//  Classi-TableViewCell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 08/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit

class Classi_TableViewCell: UITableViewCell {

    @IBOutlet weak var infosLabel: UILabel!
    
    @IBOutlet weak var grayView: UIView!
    
    @IBOutlet weak var mainLabel: UILabel!
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
