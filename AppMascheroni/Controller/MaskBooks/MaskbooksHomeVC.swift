//
//  MaskbooksHomeVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 16/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase

var wasAdded : Bool = false 

class MaskbooksHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var caricamento: UIView!
    
    @IBOutlet weak var noBooks: UIView!
    
    var idBook: String = ""
    
    struct libro{
        var nomeLibro : String;
        var materia : String;
        var autore : String;
        var condizioni : String;
        var prezzo : String;
        var id : String;
        var classe : String;
        var allTogether : String;
        var isMe : Bool;
    }
    
    var libri : [libro] = []
    var filtered : [libro] = []
    
    var searchActive: Bool = false
    
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var modify: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wasAdded = true
        searchView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        AppUtility.lockOrientation(.all)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "MaskBooks"
        searchActive = false
    }

    func bcgrImg(){
        let myImageMod = UIImageView(frame: modify.bounds)
        myImageMod.image = #imageLiteral(resourceName: "plus-quality")
        myImageMod.contentMode = .scaleAspectFill
        
        myImageMod.clipsToBounds = true
        
        modify.clipsToBounds = false
        modify.layer.shadowColor = UIColor.lightGray.cgColor
        modify.layer.shadowOpacity = 1
        modify.layer.shadowOffset = CGSize.zero
        modify.layer.shadowRadius = 3
        modify.layer.shadowPath = UIBezierPath(roundedRect: modify.bounds, cornerRadius: myImageMod.frame.width/2).cgPath
        
        modify.addSubview(myImageMod)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        //-------
        self.searchView.endEditing(true)
        searchActive = false
        tableView.reloadData()
        //--------
        addToolBar(textField: searchView)
        self.searchView.endEditing(true)
        searchActive = false
        AppUtility.lockOrientation(.all)
        bcgrImg()
        if wasAdded{
           caricamento.isHidden = false
            newBook()
        }
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive){
            return filtered.count
        }else{
            if libri.count == 0{noBooks.isHidden = false}else{noBooks.isHidden = true}
            return libri.count}
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func newBook(){
        filtered.removeAll()
        libri.removeAll()
        let ref = FIRDatabase.database().reference()
        let id = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("books").observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
                self.caricamento.isHidden = true
            } else{
                for child in (snapshot.children){
                    
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dizionario = snap.value as! [String: AnyObject] // the value is a dict
            let NomeLibro = dizionario["nomeLibro"] as! String
            let Autore = dizionario["autore"] as! String
            let Prezzo = dizionario["prezzo"] as! String
            let Materia = dizionario["materia"] as! String
            let Condizioni = dizionario["condizioni"] as! String
            self.idBook = dizionario["idLibro"] as! String
            let todos = "\(NomeLibro)\(Materia)\(Autore)"
                    var isME = false
                    if dizionario["idVenditore"] as! String == id!{
                        isME = true
                    }
                    
            let Classe = dizionario["classe"] as! String
                    var libros = libro(nomeLibro : NomeLibro, materia: Materia, autore: Autore, condizioni: Condizioni, prezzo: Prezzo, id: self.idBook, classe: Classe, allTogether: todos, isMe: isME)
                
                print(libros)
                self.libri.append(libros)
                }
                self.caricamento.isHidden = true
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchActive == false){
            idOfBookSel = libri[indexPath.row].id}else{
            idOfBookSel = filtered[indexPath.row].id
        }
        self.searchView.endEditing(true)
        performSegue(withIdentifier: "selectBook", sender: nil)
    }
    
    @IBAction func esci(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("NIBMaskBooksHomeTableViewCell", owner: self, options: nil)?.first as! NIBMaskBooksHomeTableViewCell
        var clas : String = ""
        if searchActive == false{
        cell.nomeLibro.text! = libri[indexPath.row].nomeLibro
        cell.materia.text! = libri[indexPath.row].materia
        cell.autore.text! = libri[indexPath.row].autore
        cell.prezzo.text! = libri[indexPath.row].prezzo
        cell.condizioni.text! = libri[indexPath.row].condizioni
        clas = libri[indexPath.row].classe
            if libri[indexPath.row].isMe{cell.isMineImage.isHidden = false}else{cell.isMineImage.isHidden = true}
        }else{
            cell.nomeLibro.text! = filtered[indexPath.row].nomeLibro
            cell.materia.text! = filtered[indexPath.row].materia
            cell.autore.text! = filtered[indexPath.row].autore
            cell.prezzo.text! = filtered[indexPath.row].prezzo
            cell.condizioni.text! = filtered[indexPath.row].condizioni
            if filtered[indexPath.row].isMe{cell.isMineImage.isHidden = false}else{cell.isMineImage.isHidden = true}
            clas = filtered[indexPath.row].classe
        }
        
        switch clas{
        case "Prima":
            cell.immagine.image = #imageLiteral(resourceName: "primaBook")
        case "Seconda":
            cell.immagine.image = #imageLiteral(resourceName: "secondaBook")
        case "Terza":
            cell.immagine.image = #imageLiteral(resourceName: "terzaBook")
        case "Quarta":
            cell.immagine.image = #imageLiteral(resourceName: "quartaBook")
        case "Quinta":
            cell.immagine.image = #imageLiteral(resourceName: "quintaBook")
        default:
            cell.immagine.image = #imageLiteral(resourceName: "defBook")
        }
       
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchView.endEditing(true)
        searchActive = false;
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        filtered = libri.filter({ (text) -> Bool in
            let tmp: String = text.allTogether
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
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Annulla ricerca", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        self.searchView.endEditing(true)
        searchActive = false
        tableView.reloadData()
    }
}
