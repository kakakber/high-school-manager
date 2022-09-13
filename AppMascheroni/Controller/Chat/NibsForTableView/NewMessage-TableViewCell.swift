//
//  NewMessage-TableViewCell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 13/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit

class NewMessage_TableViewCell: UITableViewCell {
//cell per gli utenti con cui messaggiare
    
    @IBOutlet weak var nomeUtente: UILabel!
    
    @IBOutlet weak var infoUtente: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
