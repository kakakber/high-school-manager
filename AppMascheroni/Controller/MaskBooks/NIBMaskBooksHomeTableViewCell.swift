//
//  NIBMaskBooksHomeTableViewCell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 16/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit

class NIBMaskBooksHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLibro: UILabel!
    
    @IBOutlet weak var isMineImage: UIImageView!
    @IBOutlet weak var immagine: UIImageView!
    @IBOutlet weak var prezzo: UILabel!
    @IBOutlet weak var condizioni: UILabel!
    @IBOutlet weak var autore: UILabel!
    @IBOutlet weak var materia: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
