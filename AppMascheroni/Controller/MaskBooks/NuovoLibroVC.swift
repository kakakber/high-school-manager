//
//  NuovoLibroVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 22/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager
import DropDown
import JGProgressHUD

class NuovoLibroVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var continuaView: UIView!
    
    @IBOutlet weak var riepilogoView: UIView!
    @IBOutlet weak var NuovoLibroTextField: UITextField!
    
    @IBOutlet weak var AutoreTextField: UITextField!
    
    @IBOutlet weak var prezzoDropDown: UIView!
    @IBOutlet weak var MateriaDropDown: UIView!
    @IBOutlet weak var PrezzoTextField: UITextField!
    
    @IBOutlet weak var classeDropDown: UIView!
    
    @IBOutlet weak var classeTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var aggiungiOutlet: UIButton!
    
    @IBOutlet weak var condizioniDropDown: UIView!
    @IBOutlet weak var CondizioniTextField: UITextField!
    @IBOutlet weak var MateriaTextField: UITextField!
    
    let materie = ["Matematica", "Fisica", "Italiano", "Scienze", "Inglese", "Storia", "Filosofia", "Informatica", "Arte", "Latino"]
    
    let dropDown = DropDown()//dropDown menu
    
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var fineView: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addToolBar(textField: NuovoLibroTextField)
        addToolBar(textField: AutoreTextField)
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Vendi un tuo libro"
        
        newView.isHidden = true
        
        continuaView.isHidden = true
        
        NuovoLibroTextField.delegate = self
        AutoreTextField.delegate = self
        PrezzoTextField.delegate = self
        CondizioniTextField.delegate = self
        MateriaTextField.delegate = self
        
        
       IQKeyboardManager.shared().toolbarDoneBarButtonItemText = "Fine"
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        newView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.newView.frame.size.width, height: self.newView.frame.size.height)
        wasAdded = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    
    @IBAction func goDown(_ sender: Any) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.newView.frame = CGRect(x: 0, y: self.view.frame.height+12, width: self.newView.frame.width, height: self.newView.frame.height)
            
        },completion: { finish in
            
            
        })
    }
    
    @IBAction func aggiungi(_ sender: Any) {
        aggiungiOutlet.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
        let uuidA = UUID().uuidString
        
        let data: Dictionary<String, Any> = ["mail": mailUser, "nomeLibro": NuovoLibroTextField.text!, "idVenditore": userID!, "materia": MateriaTextField.text!, "condizioni": CondizioniTextField.text!, "prezzo": PrezzoTextField.text!, "classe": classeTextField.text!, "autore": AutoreTextField.text!, "nomeUtente": nomeUser, "idLibro": uuidA];
        
        
       ref.child("books").child(uuidA).updateChildValues(data)
        
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        
        hud?.textLabel.text = "Libro aggiunto con successo"
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 1.3, animated: true)
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                self.navigationController?.popViewController(animated: true)
                wasAdded = true
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if allTextPutFunc(){
            continuaView.isHidden = false
        }else{
            continuaView.isHidden = true
        }
    }
    
    func allTextPutFunc() -> Bool{
        var retValue = false
        if NuovoLibroTextField.text! != "" && AutoreTextField.text! != "" && PrezzoTextField.text! != "" && CondizioniTextField.text! != "" && MateriaTextField.text! != "" && classeTextField.text != ""{
            retValue = true
        }
        return retValue
    }
    
    @IBAction func MateriaButton(_ sender: Any) {
        
        dropDown.dataSource = materie
        
        dropDown.anchorView = MateriaDropDown
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.MateriaTextField.text! = item
            if self.allTextPutFunc(){
                self.continuaView.isHidden = false
            }else{
                self.continuaView.isHidden = true
            }
        }
        
    }
    let condizioni = ["Eccellenti", "Ottime", "Buone", "Discrete", "Pessime"]
    @IBAction func condizioniButton(_ sender: Any) {
        
        dropDown.dataSource = condizioni
        
        dropDown.anchorView = condizioniDropDown
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.CondizioniTextField.text! = item
            if self.allTextPutFunc(){
                self.continuaView.isHidden = false
            }else{
                self.continuaView.isHidden = true
            }
        }
    }
    
    @IBAction func classeAct(_ sender: Any) {
        dropDown.dataSource = classi
        
        dropDown.anchorView = classeDropDown
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.classeTextField.text! = item
            if self.allTextPutFunc(){
                self.continuaView.isHidden = false
            }else{
                self.continuaView.isHidden = true
            }
        }
    }
    
    let classi = ["Prima", "Seconda", "Terza", "Quarta", "Quinta", "Biennio", "Triennio"]
    
    let prezzi = ["€0", "€5", "€10", "€15", "€20", "€25", "€30", "€35", "€40", "€45"]
    
    @IBAction func prezzoButton(_ sender: Any) {
        
        dropDown.dataSource = prezzi
        
        dropDown.anchorView = prezzoDropDown
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.PrezzoTextField.text! = item
            if self.allTextPutFunc(){
                self.continuaView.isHidden = false
            }else{
                self.continuaView.isHidden = true
            }
            
        }
    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Fine", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        NuovoLibroTextField.resignFirstResponder()
        AutoreTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var NomeLibro2: UILabel!
    @IBOutlet weak var materia2: UILabel!
    @IBOutlet weak var autore2: UILabel!
    @IBOutlet weak var condizioni2: UILabel!
    @IBOutlet weak var prezzo2: UILabel!
    
    @IBOutlet weak var newView: UIView!
    
    @IBAction func continuaButton(_ sender: Any) {
        self.NomeLibro2.text! = self.NuovoLibroTextField.text!
        self.materia2.text! = self.MateriaTextField.text!
        self.autore2.text! = self.AutoreTextField.text!
        self.condizioni2.text! = self.CondizioniTextField.text!
        self.prezzo2.text! = "\(self.PrezzoTextField.text!).00"
        newView.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.newView.frame = CGRect(x: 0, y: 20, width: self.newView.frame.width, height: self.newView.frame.height)
            
        },completion: { finish in
            
            
        })
        
    }
    
}
