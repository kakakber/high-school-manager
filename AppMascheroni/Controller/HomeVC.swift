//
//  HomeVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 01/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import JSSAlertView
import ChameleonFramework
import RevealingSplashView
var log = 0

var cnttt = 0;

class HomeVC: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loadingTheUser: UIActivityIndicatorView!
    
    @IBOutlet weak var immagineProfilo: UIImageView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var nomeUtente: UILabel!
    
    @IBOutlet weak var mailOut: UIButton!
    
    @IBOutlet weak var mailBlock: UIButton!
    
    @IBOutlet weak var bookOut: UIButton!
    
    @IBOutlet weak var bookBlock: UIButton!
    
    @IBOutlet weak var chatOut: UIButton!
    
    @IBOutlet weak var chatBlock: UIButton!
    
    @IBOutlet weak var mailUtente: UILabel!
    
    @IBOutlet weak var notLoggedView: UIView!
    
    @IBOutlet weak var textViewss: UITextView!
    @IBOutlet weak var classeUtente: UILabel!
    
    @IBOutlet weak var comunView: UIView!
    @IBOutlet weak var loggedView: UIView!
    
    @IBOutlet weak var usrBackView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var booksView: UIView!
    @IBOutlet weak var mappaView: UIView!
    @IBOutlet weak var classeView: UIView!
    @IBOutlet weak var diarioView: UIView!
    @IBOutlet weak var orarioView: UIView!
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    @IBOutlet weak var esciV: UIView!
    @IBOutlet weak var classV: UIView!
    @IBOutlet weak var mainTop: UIView!
    @IBOutlet weak var impost: UIView!
    
    func setUNew(mainTop: UIView){
        mainTop.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainTop.layer.shadowRadius = 18.0
        mainTop.layer.shadowOpacity = 0.2
        mainTop.layer.cornerRadius = 20.0
        mainTop.layer.shadowColor = UIColor.gray.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //UserDefaults.standard.set("bfbfgruSKIIIIUTYYYYTTY", forKey: "token")
        notLoggedView.isHidden = true
        GIDSignIn.sharedInstance().uiDelegate = self
        loadingTheUser.startAnimating()
        
        setUNew(mainTop: mainTop)
        setUNew(mainTop: impost)
        setUNew(mainTop: classV)
        setUNew(mainTop: esciV)
        
        if log == 0{
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "initial")!,iconInitialSize: CGSize(width: 246, height: 246), backgroundColor: UIColor.black)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
            log += 1
        }
        chatOut.isHidden = true
        chatBlock.isHidden = false
        bookOut.isHidden = true
        bookBlock.isHidden = false
        mailOut.isHidden = true
        mailBlock.isHidden = false
        
        self.impostOutlet.isHidden = true
        self.esciOutlet.isHidden = true
        
        setView(view: comunView, color: FlatLimeDark(), colorD: FlatLime())
        setView(view: diarioView, color: FlatBlue(), colorD: FlatBlueDark())
        setView(view: classeView, color: FlatWatermelon(), colorD: FlatWatermelonDark())
        setView(view: orarioView, color: FlatWatermelon(), colorD: FlatWatermelonDark())
        setView(view: mappaView, color: FlatPurple(), colorD: FlatPurpleDark())
        setView(view: booksView, color: FlatPink(), colorD: FlatPinkDark())
        setView(view: chatView, color: FlatPink(), colorD: FlatPinkDark())
       
       setView(view: usrBackView, color: FlatRed(), colorD: FlatRedDark())
        
        
        setView(view: loggedView, color: FlatRed(), colorD: FlatRedDark())
        setView(view: classV, color: FlatRed(), colorD: FlatRedDark())
        setView(view: esciV, color: FlatRed(), colorD: FlatRedDark())
        setView(view: impost, color: FlatRed(), colorD: FlatRedDark())
        setView(view: mainTop, color: FlatRed(), colorD: FlatRedDark())
        
        self.navigationController?.isNavigationBarHidden = true
         AppUtility.lockOrientation(.all)
        
         self.navigationController?.isNavigationBarHidden = true
        notLoggedView.isHidden = true
        logUser()
        
    }
    
    func aggior(){
        if isKeyPresentInUserDefaults(key: "1.2.00") == false{
            print("\n\nnon esiste!")
            logOut()
            notLoggedView.isHidden = true
            loggedView.isHidden = true
            ClasseDellUtente = ""
            loadingTheUser.startAnimating()
            UserDefaults.standard.set("itsIn", forKey: "1.2.00")
        }else{
            print("\n\nesiste!")
        }
    }
    
    func fetchInitialError(){
        logOut()
        ClasseDellUtente = ""
        self.loadingTheUser.stopAnimating()
        self.notLoggedView.isHidden = false
        self.loggedView.isHidden = true
    }
    
    func exists(id: String){
        let ref = FIRDatabase.database().reference()
        
        ref.child("studenti").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(id){
                
                print("esiste")
                
            }else{
                self.fetchInitialError()
                print("non esiste")
            }
            
            
        })
    }
    
    @IBOutlet weak var esciOutlet: UIButton!
    @IBOutlet weak var impostOutlet: UIButton!
    
    
    func logUser(){
        if FIRAuth.auth()?.currentUser != nil {
            //l'utente ha fatto l'accesso
            self.notLoggedView.isHidden = true
            self.loggedView.isHidden = true
            //prende dati da firebaseDatabase
            let dataRef = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            exists(id: userID!) //throw a bool
            print("\n\n\(userID)\n\n")
            dataRef.child("studenti").child(userID!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                if let dizionario = snapshot.value as? [String : AnyObject]{
                    
                    if let nomeUtenteD = (dizionario["nome"] as? String?)!{
                        
                        self.nomeUtente.text! = nomeUtenteD; nomeUser = nomeUtenteD;
                        if let first = nomeUtenteD.components(separatedBy: " ").first {
                            self.nomeUtente.text! = "Ciao \(first.capitalized)"
                        }
                    }else{
                        self.nomeUtente.text! = "Nessun nome"
                        print("err1")
                    }
                    if let classeUtenteD = (dizionario["classe"] as? String?)!{
                        self.classeUtente.text! = classeUtenteD
                        ClasseDellUtente = classeUtenteD
                    }else{
                        self.classeUtente.text! = "N/D"
                        print("err2")
                    }
                    if let mailUtenteD = (dizionario["mail"] as? String?)!{
                        self.mailUtente.text! = mailUtenteD; mailUser = mailUtenteD;
                    }else{
                        self.mailUtente.text! = "Nessuna mail registrata, contatta lo sviluppatore"
                        print("err3")
                    }
                    
                    if ClasseDellUtente != ""{
                        self.loadingTheUser.stopAnimating()
                        self.loggedView.isHidden = false
                        self.chatOut.isHidden = false
                        self.chatBlock.isHidden = true
                        
                        self.impostOutlet.isHidden = false
                        self.esciOutlet.isHidden = false
                        
                        self.bookOut.isHidden = false
                        self.bookBlock.isHidden = true
                        self.mailOut.isHidden = false
                        self.mailBlock.isHidden = true
                    }else{
                        //la registrazione non è stata fatta con successo, logout
                        
                        ClasseDellUtente = ""
                        
                        do{
                            try FIRAuth.auth()?.signOut()
                        } catch let logouterrors{
                            print("logoutErrorsNot")
                        }
                        
                        self.loadingTheUser.stopAnimating()
                        self.notLoggedView.isHidden = false
                        
                    }
                }else {
                    ClasseDellUtente = ""
                    self.loadingTheUser.stopAnimating()
                    self.nomeUtente.text! = "erroreDatabase"
                    self.notLoggedView.isHidden = false
                }
            })
            self.notLoggedView.isHidden = true
            aggior()
        } else {
            ClasseDellUtente = ""
            print("notLogged")
            self.loadingTheUser.stopAnimating()
            self.notLoggedView.isHidden = false
            self.loggedView.isHidden = true
            //Utente non ha fatto l'accesso
            
        }
    }
    
    func setView(view: UIView, color: UIColor, colorD: UIColor){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        
        //i due coloti per gradiante
        let colors = [color, colorD]
        
        view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: view.frame, colors: colors as! [UIColor])
        
    }
    
    //MARK:Google SignIn Delegate
    
    func logOut(){
        GIDSignIn.sharedInstance().signOut()
        do
        {
            try FIRAuth.auth()?.signOut()
            CoreDataController.shared.deleteMail()
            MailxMail = ""
            ClasseDellUtente = ""
            chatOut.isHidden = true
            chatBlock.isHidden = false
            bookOut.isHidden = true
            bookBlock.isHidden = false
            mailOut.isHidden = true
            mailBlock.isHidden = false
            
        }
        catch let error as NSError
        {
            print(error as NSError)
            JSSAlertView().danger(self, title: "Errore",
                                  text: "Non è stato possibile uscire dall'account, riprovare")
        }
    }
    
    @IBAction func esciAction(_ sender: Any) {
        //uscire dall'account
        logOut()
        notLoggedView.isHidden = false
        loggedView.isHidden = true
        ClasseDellUtente = ""
    }
    
    @IBAction func mailTp(_ sender: Any) {
        performSegue(withIdentifier: "tbksss", sender: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
        if isInExit{
            isInExit = false
            logOut()
            notLoggedView.isHidden = false
            loggedView.isHidden = true
            ClasseDellUtente = ""
        }
    }
    
    @IBAction func toMAl(_ sender: Any) {
        MailxMail = mailUtente.text!
        performSegue(withIdentifier: "rewq", sender: nil)
    }
    
    @IBAction func toChatBtn(_ sender: Any) {
        performSegue(withIdentifier: "prChat", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // ScrollView.setContentOffset(CGPoint(x: 0, y: -10), animated: true)//cambia la posizione iniziale della scroll view
        if cnttt == 0{
            cnttt = 33
        if isKeyPresentInUserDefaults(key: "openDiario"){
            let isOpen = UserDefaults.standard.object(forKey: "openDiario") as! String
            if isOpen == "si"{
                performSegue(withIdentifier: "toDiFirst", sender: nil)
            }
        }
        if isKeyPresentInUserDefaults(key: "openRegistro"){
            let isOpen = UserDefaults.standard.object(forKey: "openRegistro") as! String
            
            if isOpen == "si"{
                print("si")
                performSegue(withIdentifier: "toRegIn", sender: nil)
            }
        }
        }
        
    }
    
    

}
