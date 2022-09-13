//
//  NuovoMessaggioViewController.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 13/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

struct utente{
    var nome : String
    var classe : String
    var mail : String
    var id : String
    var search : String
}

class NuovoMessaggioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var noUsersView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive = false
    
    var NomiArray = [String]()
    var InfoUserArray = [String]()
    var IdUserArray = [String]()
    
    var dizionario : [String : String] = [:]
    var dizionarioId : [String : String] = [:]
    
    var utenti :  [utente] = []
    var filtered : [utente] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.isHidden = true
        noUsersView.isHidden = true
        
        getAllTheUsers()
        
        addToolBar(textField: searchBar)
        
        searchBar.delegate = self
        
        tableView.isHidden = true
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //controlla quanti utenti siano registrati all'app
       /* var Rows = [String]()
        
        for (nomeUtente, _) in dizionario{
            Rows.append(nomeUtente)
        }
        var ret = Rows.count
        
        return ret*/
        
        if searchActive && filtered.count > 0{
            return filtered.count
        }else{
            return utenti.count
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    
    
    func getAllTheUsers(){
        
        //Nel database fetch data per prenderre le informazioni di tutti gli utenti legalmente registrati
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        var ArrayOut = [String]()
        ArrayOut.removeAll()
        ref.child("studenti").child(uid!).child("messaggi").child("ConUtenti").observeSingleEvent(of: .value) { (Snapshot) in
            if ( Snapshot.value is NSNull ) {
                print("not found")
            } else {
                for child in (Snapshot.children){
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as! [String: AnyObject] // the value is a dict
                    
                    let idA = dict["id"] as! String
                    
                    ArrayOut.append(idA)
                    //creo un array degli utenti con cui è gia in corso una chat
                    
                }
            };print("utenti gia in chat\(ArrayOut)")
        }
        
        var isAddable = true
        ref.child("studenti").observeSingleEvent(of: .value, with: { (snapshot) in
            //iterazione all'interno del database per
            var nomeStudente : String = ""
            
            var underLabel : String = ""
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                print("found2")
                for child in (snapshot.children){
                    
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as! [String: AnyObject] // the value is a dict
                    
                    let nome = dict["nome"] as! String
                    
                    let mail = dict["mail"] as! String
                    
                    let classe = dict["classe"] as! String
                    
                    let id = dict["uid"] as! String
                    
                    isAddable = true
                    if ArrayOut.count != 0{
                    for i in ArrayOut{//itero per sapere se l'utente è già in conversazione con l'utente
                        if i == id{
                            isAddable = false
                        }
                    }
                
                    }
                    
                    if classe != "" && id != uid && isAddable == true{
                        underLabel = "\(classe) ~ \(mail)"
                        nomeStudente = nome
                        
                        
                        let userTem = utente(nome: nome, classe: classe, mail: mail, id: id, search: "\(nome)\(classe)")
                        
                        self.utenti.append(userTem)
                        
                        //fai struct utente
                        self.dizionario[nomeStudente] = underLabel
                        
                        self.dizionarioId[nomeStudente] = id
                        
                        self.tableView.isHidden = false
                        
                    }
                }
            }
            
            for (_, id) in self.dizionarioId{
                self.IdUserArray.append(id)
            }
            if self.IdUserArray.isEmpty == true{
                self.noUsersView.isHidden = false
            }
            
            for (nomeUtente, Info) in self.dizionario {
                //itera nel dizionario per assegnare valori agli array usati per la tableViewCell
                
                self.NomiArray.append(nomeUtente)
                self.InfoUserArray.append(Info)
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    
    let uuid = UUID().uuidString
    var numeroChat : Int = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //row selezionato, si aggiunge una chat al Database
        
        if searchActive && filtered.count > 0{
            print("\(filtered[indexPath.row].nome) - \(filtered[indexPath.row].id)")
        }else{
            print("\(utenti[indexPath.row].nome) - \(utenti[indexPath.row].id)")
        }
        var idDestinatario = ""
        
        
        var nam = ""
        
        if searchActive && filtered.count > 0{
            idDestinatario = filtered[indexPath.row].id
            nam = filtered[indexPath.row].nome
        }else{
            idDestinatario = utenti[indexPath.row].id
            nam = utenti[indexPath.row].nome
        }
        
        let alert = UIAlertController(title: "Nuova chat", message: "Vuoi iniziare una conversazione con \(nam)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
            }));
        alert.addAction(UIAlertAction(title: "Inizia conversazione", style: .default, handler: { action in
            self.newChat(idDestinatario: idDestinatario, indexPath: indexPath)
        }));
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func newChat(idDestinatario: String, indexPath: IndexPath){
        updateNumeroChat()
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        print("idUser array : \(IdUserArray)")
        //update value per messaggi:
        
        let utentiInChat: Dictionary<String, Any> = ["id" : uuid,"utente1" : uid!, "utente2" : idDestinatario, "ultimo_Messaggio" : "Nessun messaggio", "messaggi" : "", "ultima_Ora" : "--:--"];
        //aggiorno valori database
        let tuttiUtInChat: Dictionary<String, Any> = ["id" : idDestinatario];
        
        let tuttiUtInChat2: Dictionary<String, Any> = ["id" : uid!];
        
        ref.child("messaggi").child(uuid).updateChildValues(utentiInChat)
        //------
        
        var updateVss : Int = 0
        //update chats per utente b
        
        ref.child("studenti").child(uid!).child("messaggi").child("ConUtenti").child(idDestinatario).updateChildValues(tuttiUtInChat)
        //aggiungo l'utente con cui inizio la chat alla lista degli utenti con cui ho chat in corso nel Database
        ref.child("studenti").child(idDestinatario).child("messaggi").child("ConUtenti").child(uid!).updateChildValues(tuttiUtInChat2)
        ref.child("studenti").child(idDestinatario).child("messaggi").observeSingleEvent(of: .value) { (snapshot) in
            //prende i dati dell'utente con cui vuoi messaggiare
            if let dizionario = snapshot.value as? [String : AnyObject]{
                
                self.numeroChat = dizionario["numeroDiChat"] as! Int
                updateVss = self.numeroChat + 1
            }
            //aggiunge 1 al numero di chat dell'utente:
            let numeroCh: Dictionary<String, Any> = ["numeroDiChat" : updateVss];
            
            ref.child("studenti").child(idDestinatario).child("messaggi").updateChildValues(numeroCh)
        }
        
        
        //aggiunge un idMessage all'utente:
        let ups: Dictionary<String, Any> = ["id": uuid]
        
        ref.child("studenti").child(uid!).child("messaggi").child("ChatId").child(uuid).updateChildValues(ups)
        ref.child("studenti").child(idDestinatario).child("messaggi").child("ChatId").child(uuid).updateChildValues(ups)
        
        
        //chat aggiunta
        tableView.deselectRow(at: indexPath, animated: true)
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        var nomeKK = ""
        if searchActive && filtered.count > 0{
            nomeKK = filtered[indexPath.row].nome
        }else{
            nomeKK = utenti[indexPath.row].nome
        }
        hud?.textLabel.text = "Hai iniziato una nuova conversazione con \(nomeKK)"
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 1.8, animated: true)
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
            // Fallback on earlier versions
        }
        
    }
    
    func updateNumeroChat(){
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        //se non c'è già una conversazione:
        var updateV : Int = 0
        
        ref.child("studenti").child(uid!).child("messaggi").observeSingleEvent(of: .value) { (snapshot) in
            if let dizionario = snapshot.value as? [String : AnyObject]{
                
                self.numeroChat = dizionario["numeroDiChat"] as! Int
                updateV = self.numeroChat + 1
                
           }
            
            let numeroChats: Dictionary<String, Any> = ["numeroDiChat" : updateV];
            ref.child("studenti").child(uid!).child("messaggi").updateChildValues(numeroChats)
            

        }
     
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive && filtered.count > 0{
            let cell = Bundle.main.loadNibNamed("NewMessage-TableViewCell", owner: self, options: nil)?.first as! NewMessage_TableViewCell
            
            cell.nomeUtente.text! = filtered[indexPath.row].nome
            cell.infoUtente.text! = "\(filtered[indexPath.row].classe) ~ \(filtered[indexPath.row].mail)"
            return cell
        }else{
        let cell = Bundle.main.loadNibNamed("NewMessage-TableViewCell", owner: self, options: nil)?.first as! NewMessage_TableViewCell
        
        cell.nomeUtente.text! = utenti[indexPath.row].nome
        cell.infoUtente.text! = "\(utenti[indexPath.row].classe) ~ \(utenti[indexPath.row].mail)"
        
            return cell}
    }
    
    //---for search view
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchActive = true;
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        filtered = utenti.filter({ (text) -> Bool in
            let tmp: String = text.search
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range != nil
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func addToolBar(textField: UISearchBar){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Annulla ricerca", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        self.searchBar.endEditing(true)
        searchActive = false
        tableView.reloadData()
    }
    
}
