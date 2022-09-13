//
//  SelectedBookVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 29/03/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

var idOfBookSel : String = ""

class SelectedBookVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var nomeLibro: UILabel!
    @IBOutlet weak var autore: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var venditore: UILabel!
    @IBOutlet weak var condizioni: UILabel!
    @IBOutlet weak var classe: UILabel!
    @IBOutlet weak var materia: UILabel!
    @IBOutlet weak var prezzo: UILabel!
    
    @IBOutlet weak var eliminaOut: UIButton!
    
    let hud = JGProgressHUD(style: .dark)
    
    @IBAction func eliminaAct(_ sender: Any) {
        wasAdded = true
        let ref = FIRDatabase.database().reference().child("books").child(idOfBookSel)
        
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        
        hud?.textLabel.text = "Libro eliminato con successo"
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 1.3, animated: true)
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                self.navigationController?.popViewController(animated: true)
                wasAdded = true
            }
        }
            ref.removeValue { error, _ in
                
                print(error)
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wasAdded = false
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
     self.navigationController?.isNavigationBarHidden = false
        self.title = "Libro Selezionato"
        LoadBook(id: idOfBookSel)
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var img: UIImageView!
    
    func LoadBook(id: String){
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser!.uid
        
        ref.child("books").child(id).observeSingleEvent(of: .value) { (Snapshot) in
                if let dizionario = Snapshot.value as? [String : AnyObject]{
                    
                    self.nomeLibro.text! = dizionario["nomeLibro"] as! String
                    self.autore.text! = dizionario["autore"] as! String
                    self.prezzo.text! = dizionario["prezzo"] as! String
                    self.materia.text! = dizionario["materia"] as! String
                    self.condizioni.text! = dizionario["condizioni"] as! String
                    self.classe.text! = dizionario["classe"] as! String
                    self.venditore.text! = dizionario["nomeUtente"] as! String
                    self.mail.text! = dizionario["mail"] as! String
                    var idVend = dizionario["idVenditore"] as! String
                    
                    if idVend == uid!{
                        self.eliminaOut.isHidden = false
                    }else{
                        self.eliminaOut.isHidden = true
                    }
                
                self.loadingView.isHidden = true
                }else{
                    print("error")
            }
        }
    }

}
