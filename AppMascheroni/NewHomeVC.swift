//
//  NewHomeVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 13/08/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import ChameleonFramework

class studentCell: UICollectionViewCell{
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var descrizione: UILabel!
    
    @IBOutlet weak var titolo: UITextView!
    
}

class medieCell: UICollectionViewCell{
    
    @IBOutlet weak var view: UIView!
}

class firstMainRow: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titoliMain = ["Orario scolastico", "Registro Elettronico", "Diario", "Annunci della scuola", "MyBooks"]
    var backMain = [ #imageLiteral(resourceName: "reg2"),#imageLiteral(resourceName: "reg1"),#imageLiteral(resourceName: "reg3"),#imageLiteral(resourceName: "reg4"), #imageLiteral(resourceName: "reg4-1")]
    var descrizioniMain = ["Visualizza orario di lezioni e professori", "Voti, compiti, agenda, assenze", "Eventi personali, registro e altri studenti", "Annunci da parte della scuola", "Compravendita di libri tra studenti"]
    
    @IBOutlet weak var topView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        topView.layer.shadowRadius = 18.0
        topView.layer.shadowOpacity = 0.2
        topView.layer.cornerRadius = 20.0
        topView.layer.shadowColor = UIColor.gray.cgColor
        
        
        //collactionViewMain.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var delegatez: selectedFirstRow!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titoliMain.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath) as! studentCell
        
        cell.view.layer.cornerRadius = 20.0
        cell.view.layer.shadowColor = UIColor.gray.cgColor
        cell.view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.view.layer.shadowRadius = 8.0
        cell.view.layer.shadowOpacity = 0.5
        
        cell.back.layer.cornerRadius = 14
        cell.back.clipsToBounds = true
        
        cell.descrizione.text! = descrizioniMain[indexPath.row];
        cell.titolo.text! = titoliMain[indexPath.row]
        cell.back.image = backMain[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegatez?.tapped(at: indexPath)//faccio array dei vari segue id
    }
    
    
    
}

protocol selectedFirstRow{
    func tapped(at index:IndexPath)
}


class NewHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, selectedFirstRow{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //------stud--------
    var titoliMain = ["Orario scolastico", "Registro Elettronico", "Diario", "Annunci della scuola", "MyBooks"]
    var backMain = [ #imageLiteral(resourceName: "reg2"),#imageLiteral(resourceName: "reg1"),#imageLiteral(resourceName: "reg3"),#imageLiteral(resourceName: "reg4"), #imageLiteral(resourceName: "reg4-1")]
    var descrizioniMain = ["Visualizza orario di lezioni e professori", "Voti, compiti, agenda, assenze", "Eventi personali, registro e altri studenti", "Annunci da parte della scuola", "Compravendita di libri tra studenti"]
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors = [FlatPurple(), FlatPurpleDark()]
        
        //topView.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: topView.frame, colors: colors as! [UIColor])
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath) as! firstMainRow
        cell.delegatez = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 431
    }
    
    func tapped(at index: IndexPath) {
        switch index.row {
        case 0:
            print("notYetMyBoy")
        case 1:
            performSegue(withIdentifier: "regW", sender: nil)
        case 4:
            performSegue(withIdentifier: "bks", sender: nil)
        default:
            print("gayBitchNot YEEET")
        }
    }
}
