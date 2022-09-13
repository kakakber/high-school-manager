//
//  ChatContactsVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 12/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ChatContact{
    var nome : String!
    var classe : String!
    var ultimoMessaggio : String!
    var ultimaOra : String!
    var immagineProfilo : UIImage!
    var idChat : String!
    var idDestin : String
    
    init(nome : String, classe : String, ultimoMessaggio : String, ultimaOra : String, immagineProfilo : UIImage, idChat : String, idDestin : String) {
        self.nome = nome
        self.classe = classe
        self.ultimoMessaggio = ultimoMessaggio
        self.ultimaOra = ultimaOra
        self.immagineProfilo = immagineProfilo
        self.idChat = idChat
        self.idDestin = idDestin
    }
}

 let messaggioArrivato = "masche.alberti.nuovaNotifica"

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

//per muovere cella programmaticamente:

//let fromIndexPath = NSIndexPath(forRow: 0, inSection: 0)
//let toIndexPath = NSIndexPath(forRow: 0, inSection: 1)
//
//// swap the data between the 2 (internal) arrays
//let dataPiece = data[fromIndexPath.section][fromIndexPath.row]
//data[toIndexPath.section].insert(dataPiece, atIndex: toIndexPath.row)
//data[fromIndexPath.section].removeAtIndex(fromIndexPath.row)
//
//// Do the move between the table view rows
//self.tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)

class ChatContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var numeroDiChat : Int = 0
    
    let hudB = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var tableView: UITableView!
    
    let hud = JGProgressHUD(style: .light)
    
    var tutteLeChat = [ChatContact]()
    
    override func viewDidLoad() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
         tableView.addSubview(refreshControl)
        
        tableView.isHidden = true
         
        tableView.delegate = self
        
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        hud?.textLabel.text = ""
        hud?.show(in: self.view)
        
       
        
        
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        // Codice per refreshare la table view
        hud?.show(in: self.view)
        self.tableView.isHidden = true
        getNumeroDiChat()
        refreshControl.endRefreshing()
    }
    
    func watchChanges(){
        //osserva quando c'è un cambiamento
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
    }
    
    func setUpNavBar(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    var leMieChat = [String]()
    
    func getAllUserInfo(){
        //rimuove gli elementi dalla table view per riempire gli array da 0
        tutteLeChat.removeAll()
        leMieChat.removeAll()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
        var chatNuova : ChatContact = ChatContact(nome: "", classe: "", ultimoMessaggio: "", ultimaOra: "", immagineProfilo: #imageLiteral(resourceName: "profile pic"), idChat: "", idDestin: "")
        ref.child("studenti").child(uid!).child("messaggi").child("ChatId").observeSingleEvent(of: .value, with: { (snapshot) in
            //iterazione all'interno del database per
            chatNuova = ChatContact(nome: "", classe: "", ultimoMessaggio: "", ultimaOra: "", immagineProfilo: #imageLiteral(resourceName: "profile pic"), idChat: "", idDestin: "")
            
            if ( snapshot.value is NSNull ) {
                print("not found")
                
                self.numeroDiChat = 0
                //self.noChatView.isHidden = false
                
            } else {
                
                for child in (snapshot.children){
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as! [String: AnyObject] // the value is a dict
                    
                    let id = dict["id"] as! String
                    chatNuova.idChat = id
                    self.leMieChat.append(id)
                }
                
        }
       
    })
        
        ref.child("messaggi").observeSingleEvent(of: .value, with: { (snapshot) in
            //iterazione all'interno del database per
            var Iterr : Int = 0
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children){
                    
                    chatNuova = ChatContact(nome: "", classe: "", ultimoMessaggio: "", ultimaOra: "", immagineProfilo: #imageLiteral(resourceName: "profile pic"), idChat: "", idDestin: "")
                    
                    
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as! [String: AnyObject] // the value is a dict
                    
                    let User1 = dict["utente1"] as! String
                    
                    let User2 = dict["utente2"] as! String
                    
                    let UltimoMex = dict["ultimo_Messaggio"] as! String
                    
                    let ids = dict["id"] as! String
                    
                    let ultimaOra = dict["ultima_Ora"] as! String
                   
                    chatNuova.ultimaOra = ultimaOra
                    
                    
                    var ext : String = ""
                    
                    for it in self.leMieChat{
                        if it == ids{
                            if User1 == uid{
                                ext = User2
                            }else if User2 == uid{
                                ext = User1
                            }
                            print("ext: \(ext)")
                            //utente con cui messaggio trovato, prendo i suoi dati
                            ref.child("studenti").child(ext).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                chatNuova = ChatContact(nome: "", classe: "", ultimoMessaggio: "", ultimaOra: "", immagineProfilo: #imageLiteral(resourceName: "profile pic"), idChat: "", idDestin: "")
                                
                                //iterazione all'interno del database per
                                //each child is a snapshot
                                Iterr += 1
                                if let dizionario = snapshot.value as? [String : AnyObject]{
                                    
                                    let nomeU = (dizionario["nome"] as? String!)!
                                    let classeU = (dizionario["classe"] as? String!)!
                                    let mailU = (dizionario["mail"] as? String!)!
                                    let id = (dizionario["uid"] as? String!)!
                                    
                                    chatNuova.ultimoMessaggio = UltimoMex
                                    chatNuova.nome = nomeU
                                    chatNuova.classe = classeU
                                    chatNuova.idDestin = id!
                                    
                                    self.tutteLeChat.append(chatNuova)
                                    print("nomi Classe \(chatNuova.nome)")
                                    
                                    
                                    
                                }
                                
                                if Iterr == self.numeroDiChat{
                                    
                                    self.hud?.dismiss()
                                    
                                    self.tableView.isHidden = false
                                    self.tableView.reloadData()
                                }
                                
                            })
                            //print(self.leMieChat)
                        }
                    }
                   
            }
                
        }
            
    })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FIRDatabase.database().reference().child("chatInfo").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let dizionario = snapshot.value as? [String : AnyObject]{
                
                if (dizionario["valid"] as? String?)! == "true"{
                    self.getNumeroDiChat()
                }else{
                    self.hudB?.indicatorView = JGProgressHUDErrorIndicatorView.init()
                    self.hudB?.textLabel.text = "La chat non è al momento disponibile"
                    self.hudB?.show(in: self.view)
                    self.hudB?.dismiss(afterDelay: 1.8, animated: true)
                    Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hud?.show(in: self.view)
        self.tableView.isHidden = true
    }
    
    func getNumeroDiChat(){
        //fetchAllTheData
        
        let dataRef = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        dataRef.child("studenti").child(userID!).child("messaggi").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let dizionario = snapshot.value as? [String : AnyObject]{
                
                self.numeroDiChat = ((dizionario["numeroDiChat"] as? Int)!)
                if self.numeroDiChat == 0{
                    self.hud?.dismiss()
                    self.tableView.isHidden = false
                }else{
                    self.getAllUserInfo()
                }
            }else {
                print("error")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ChangeElement = tutteLeChat[sourceIndexPath.row]
        let idArrayChange = leMieChat[sourceIndexPath.row]
        
        leMieChat.remove(at: sourceIndexPath.row)
        leMieChat.insert(idArrayChange, at: destinationIndexPath.row)
            
        tutteLeChat.remove(at: sourceIndexPath.row)
        tutteLeChat.insert(ChangeElement, at: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Chat"
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tutteLeChat[indexPath.row].nome != nil {
        MessaggioVerso = tutteLeChat[indexPath.row].nome
        MessaggioVersoId = tutteLeChat[indexPath.row].idDestin
        MessaggioId = leMieChat[indexPath.row]
        ClasseStudChat = tutteLeChat[indexPath.row].classe
        
        performSegue(withIdentifier: "toActChat222", sender: nil)
        }else{
            
        }
    }
    var noMexa = true
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("nemro di chat: \(numeroDiChat)")
        var ret = numeroDiChat
        
        if numeroDiChat == 0{
        noMexa = true
            ret = 1
        }else{
         noMexa = false
        }
        return ret
         // varia
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func esci(_ sender: Any) {
//        tableView.isEditing = !tableView.isEditing
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellOut = UITableViewCell()
        if noMexa == false{
        let cell = Bundle.main.loadNibNamed("ConsversazioniChatTableViewCell", owner: self, options: nil)?.first as! ConsversazioniChatTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.nomeUtente.text! = self.tutteLeChat[indexPath.row].nome
        cell.classeUtente.text! = self.tutteLeChat[indexPath.row].classe
        cell.ultimaConv.text! = self.tutteLeChat[indexPath.row].ultimoMessaggio
        cell.orarioUltimaChat.text = self.tutteLeChat[indexPath.row].ultimaOra
            //print("\n\(self.tutteLeChat[indexPath.row].ultimaOra)\n");
        cellOut = cell
        return cell 
        }else{
          let cells = Bundle.main.loadNibNamed("noDATATableViewCell", owner: self, options: nil)?.first as! noDATATableViewCell
            cellOut = cells
    }
 return cellOut
}

    //Notifiche
    
}
