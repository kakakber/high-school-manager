//
//  ActChat2Cell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 29/04/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit

class ActChat2Cell: UITableViewCell {

    @IBOutlet weak var utente: UILabel!
    @IBOutlet weak var ora: UILabel!
    @IBOutlet weak var messaggio: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
