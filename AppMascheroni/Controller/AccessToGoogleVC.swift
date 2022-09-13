//
//  AccessToGoogleVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 06/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import DropDown
import JSSAlertView

class AccessToGoogleVC: UIViewController{

    //dopo il login con google scegliere la classe
    
    @IBOutlet weak var scegliClasseView: UIView!
    
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var nomeUtenteLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mailUtente: UILabel!
    
    @IBOutlet weak var classeLablel: UILabel!
    @IBOutlet weak var classeButton: UIButton!
    
    @IBOutlet weak var continueActivInd: UIActivityIndicatorView!
    
    let dropDown = DropDown()//dropDown menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        userDataView.isHidden = true
        
        
        dropDown.anchorView = scegliClasseView
        //The list of items to display. Can be changed dynamically
        dropDown.dataSource = arrayClassi()
        
        nomeUtenteLabel.text! = GDnome
        mailUtente.text! = GDmail
        
        userDataView.isHidden = false
          
        mailUtente.text! = GDmail
        nomeUtenteLabel.text! = GDnome
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func classeButton(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    self.classeLablel.text! = "\(item)"
       }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.userDataView.frame = CGRect(x: 41, y: 111, width: self.userDataView.frame.width, height: self.userDataView.frame.height)
            
            //Frame Option 2:
            //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
            
        },completion: { finish in
            
            
        })
    }
    
    @IBOutlet weak var continuaButtonOut: UIButton!
    
    @IBAction func continua(_ sender: Any) {
        //se tutti i dati sono inseriti:
        if classeLablel.text! == "~"{
            JSSAlertView().danger(self, title: "Accesso",
                                  text: "inserisci la tua classe")
        }else{
            continuaButtonOut.titleLabel?.text! = ""
            continueActivInd.startAnimating()
            let userID = FIRAuth.auth()?.currentUser?.uid
            let ref = FIRDatabase.database().reference()
            
            let data: Dictionary<String, Any> = ["mail": GDmail, "nome": GDnome, "classe" : classeLablel.text!,  "immagine": ""];
            
            
            ref.child("studenti").child(userID!).child("messaggi").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild("numeroDiChat"){
                    ref.child("studenti").child(userID!).updateChildValues(data);
                    
                }else{
                    let dataTwo: Dictionary<String, Any> = ["numeroDiChat" : 0];
                    ref.child("studenti").child(userID!).updateChildValues(data);
                    //l'utente non esiste
               ref.child("studenti").child(userID!).child("messaggi").updateChildValues(dataTwo)
                }

            })
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.present(next, animated: true, completion: nil)
            
        }
    }
    
}
