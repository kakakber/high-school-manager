//
//  mailCell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 12/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit

class mailCell: UITableViewCell {
    
    @IBOutlet weak var oggetto: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
