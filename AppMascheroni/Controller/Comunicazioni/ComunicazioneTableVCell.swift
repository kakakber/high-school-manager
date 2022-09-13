//
//  ComunicazioneTableVCell.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 29/01/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit

protocol visualizzaProtocol{
    func visualizza(at index:IndexPath)
}


class ComunicazioneTableVCell: UITableViewCell {
    @IBOutlet weak var titolo: UILabel!
    
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var data: UILabel!
    
    var indexPath: IndexPath!
    
    var delegate: visualizzaProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    @IBAction func visualizza(_ sender: Any) {
       self.delegate?.visualizza(at: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
