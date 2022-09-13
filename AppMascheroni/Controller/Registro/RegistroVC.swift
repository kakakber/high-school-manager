//
//  RegistroVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 11/06/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Foundation
import JavaScriptCore
import SwiftyJSON
import UICircularProgressRing
import ChameleonFramework
import JGProgressHUD


//----------------------------------------------

class selectionCell : UICollectionViewCell{
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var desc: UILabel!
    
}

let beginnAPI = "https://web.spaggiari.eu/rest/v1"

class tvCell : UITableViewCell{
    
    @IBOutlet weak var prRing: UICircularProgressRingView!
    @IBOutlet weak var descriz: UITextView!
    
    @IBOutlet weak var voto: UILabel!
    @IBOutlet weak var tipoEData: UILabel!
    @IBOutlet weak var materia: UILabel!
    override func awakeFromNib() {
        prRing.minValue = 0
        prRing.maxValue = 10
        prRing.value = 0
    }
}

class cellForTTmat: UITableViewCell{
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var prRing: UICircularProgressRingView!
    
    @IBOutlet weak var mainNumeroVoti: UILabel!
    @IBOutlet weak var mainPeriodo: UILabel!
    
    @IBOutlet weak var prRingComplessivo: UICircularProgressRingView!
    @IBOutlet weak var votoMain: UILabel!
    
    @IBOutlet weak var materia: UITextView!
    
    @IBOutlet weak var votoComp: UILabel!
    
    @IBOutlet weak var votiComlessivo: UILabel!
    
    override func awakeFromNib() {
        prRing.minValue = 0
        prRing.maxValue = 10
        prRing.value = 0
        prRingComplessivo.minValue = 0
        prRingComplessivo.maxValue = 10
        prRingComplessivo.value = 0
    }
}

//struct necessarie
struct materiaStruct{
    var voti : [voto]
}

struct tutteMaterie{
    var materia : [voto]
    var periodo : Double
    var media : Double
}

var materieComplessive : [tutteMaterie] = [] //variabile per tutte le materie divise in periodi

var UltraMaterie : [materiaMajor] = []

struct voto{
    var materia : String//subjectDesc
    var idMateria : String //subjectId
    var voto: Double //decimalVal
    var votoMostrabile : String //displayValue
    var data: Date //evtDate
    var diminutivo: String //subjCode
    var displayPos : Double //displaPos indica se è tipo il terzo voto di una materia
    var notesForFamily : String //notesForFamily
    var colore : String //color
    var periodPos : Double
    var tipoVoto : String //componentDesc es:Orale
}

struct materiaMajor{
    var mediaPP : Double
    var votiPP : [voto]
    var mediaSP : Double
    var votiSP : [voto]
}

var materieForR : [materiaStruct] = []

class RegistroVC: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //@IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var segmented: HBSegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    @IBOutlet weak var titol: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.set("bfbf", forKey: "id")
        
        collView.delegate = self
        collView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 87
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.addSubview(self.refreshControl)
        
        //log(id : "String", password: "Stringcdjcjsk")
        
        /* mainLog.layer.cornerRadius = 14.0
         mainLog.layer.shadowColor = UIColor.gray.cgColor
         mainLog.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
         mainLog.layer.shadowRadius = 15.0
         mainLog.layer.shadowOpacity = 0.7*/
        
        setUp()
        
        //getDataAsRecenti()
        
        segmented.items = ["Recenti", "Materie"]
        segmented.selectedLabelColor = .white
        segmented.unselectedLabelColor = .black
        segmented.backgroundColor = .white
        segmented.thumbColor = .black
        segmented.selectedIndex = 0
        segmented.font = UIFont(name: "Avenir-Black", size: 12)
        segmented.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmented.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        tableView.separatorStyle = .none
    }
    var isMaterie = false
    
    override func viewWillAppear(_ animated: Bool) {
        whenAgg()
    }
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        
        if segmented.selectedIndex == 0 {
            isMaterie = false
            titol.text! = "Voti recenti"
            tableView.estimatedRowHeight = 87
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.reloadData()
        }else if segmented.selectedIndex == 1{
            isMaterie = true
            //tableView.rowHeight = 225
            tableView.estimatedRowHeight = 225
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
            titol.text! = "Materie"
            tableView.reloadData()
        }
    }
    //--------generale utente
    var tokens : String = ""
    var ident : String = ""
    var nomeUt : String = ""
    var cognomeUt : String = ""
    var idUt : String = ""
    
    //-------voti utente
    
    
    
    
    func getMaterieAndData(){
        UltraMaterie.removeAll()
        materieComplessive.removeAll()
        materieForR.removeAll()
        
        var t = 0
        var addV : String = ""
        var addP : Double = 0.0
        var arrVot : [voto] = []
        print("\nvoti:\n\n")
        for z in voti{
            print(z.materia)
        }
        var voti2 = voti
        voti2.append(voto(materia: "fdvsvddvasc", idMateria: "vfsd", voto: 0.0, votoMostrabile: "sdada", data: Date(), diminutivo: "dsa", displayPos: 2.0, notesForFamily: "dadsd", colore: "dvfvfv", periodPos: 2.0, tipoVoto: "dfagbv"))
        for a in voti2{
            if t > 0{
                if addV == a.materia{
                    arrVot.append(a)
                }else{
                    let newel = materiaStruct(voti: arrVot)
                    materieForR.append(newel)
                    
                    addV = a.materia
                    arrVot.removeAll()
                    arrVot.append(a)
                    //addV
                }
            }else{
                addV = a.materia
                arrVot.append(a)
            }
            t += 1
        }
        print("\nmaterie for R:\n\n")
        for hgf in materieForR{
            for hgk in hgf.voti{
                print(hgk.votoMostrabile)
            }
        }
        print("materie filtrate: \(materieForR.count)")
        print("\ndivido in periodi e faccio medie")
        
        for e in materieForR{
            
            //funzione che riempie il materiaMajor e quindi ultra materie
            
            //-primo periodo
            var mediaPP : Double =  0.0;
            var ttPP : Double = 0.0
            var votiPP : [voto] = []
            
            var mediaSP : Double = 0.0
            var ttSP : Double = 0.0
            var votiSP : [voto] = []
            
            for ao in e.voti{
                if ao.periodPos == 1.0 && ao.voto != 0.0{
                    mediaPP += ao.voto
                    votiPP.append(ao)
                    ttPP += 1
                }else{
                    if ao.voto != 0.0{
                        mediaSP += ao.voto
                        votiSP.append(ao)
                        ttSP += 1
                    }
                }
            }
            
            if ttPP > 0{
                mediaPP = mediaPP/ttPP
                let newMt = tutteMaterie(materia: votiPP, periodo: 1.0, media: mediaPP)
                materieComplessive.append(newMt)}else{
                let newMt = tutteMaterie(materia: votiPP, periodo: 1.0, media: 0.0)
                materieComplessive.append(newMt)
            }
            
            if ttSP > 0{
                mediaSP = mediaSP/ttSP
                let newSp = tutteMaterie(materia: votiSP, periodo: 3.0, media: mediaSP)
                materieComplessive.append(newSp)
            }else{
                let newSp = tutteMaterie(materia: votiSP, periodo: 3.0, media: 0.0)
                materieComplessive.append(newSp)
            }
            votiPP = votiPP.sorted(by: { $0.data.compare($1.data) == .orderedAscending })
            if ttSP != 0{
                votiSP = votiSP.sorted(by: { $0.data.compare($1.data) == .orderedAscending })
            }
            
            let newMajor = materiaMajor(mediaPP: mediaPP, votiPP: votiPP, mediaSP: mediaSP, votiSP: votiSP)
            
            UltraMaterie.append(newMajor)
            
        }
        var tQwSS = 0
        
        for b in UltraMaterie{
            if b.votiPP.count == 0 && b.votiSP.count == 0{
                UltraMaterie.remove(at: tQwSS)
                tQwSS -= 1
            }
            tQwSS += 1;
        }
        
    }
    
    var votiInDatabase : [voto] = []
    var voti : [voto] = []
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func setUpInitDatabese(){//setup per initial database
        
        votiInDatabase = CoreDataController.shared.caricaTuttiLeValutazioniVoto()
        voti = votiInDatabase
        var hgf = 0;
        
        for jh in self.voti{
            print(jh.materia)
        }
        print("\nfine voti\n\n ")
        for t in self.voti{
            if t.voto == 0.0{
                //print(t.voto)
                var rep = self.translate(da: t.votoMostrabile)
                //print("voto \(t.materia): \(t.votoMostrabile), originariamente : \(t.voto) -> \(rep)")
                self.voti[hgf].voto = rep
            }
            hgf += 1;
        }//se è o meno un voto senza decimal
        
        self.getMaterieAndData()
        
        self.voti = self.voti.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
        //print(self.voti)
        self.aggiornato = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var aggiornatoLabel: UILabel!
    
    func miniSet(){//setUp per view did Appear
        if isKeyPresentInUserDefaults(key: "id") && isKeyPresentInUserDefaults(key: "password") && isKeyPresentInUserDefaults(key: "token"){
            //utente ha gia fatto l'accesso, controllo il token
            print("\nutente ha fatto accesso, controllo token")
            tokens = UserDefaults.standard.object(forKey: "token") as! String
            statoToken(resource: "voti", id: UserDefaults.standard.object(forKey: "id") as! String, psw: UserDefaults.standard.object(forKey: "password") as! String)
        }else{
            //altrimenti gli faccio fare l'accesso
            print("nessun dato, faccio fare accesso")
            blurBackground.isHidden = false
            //log(id: newUID, password: newPSW)
            //salvo in USERDefaults
            
        }
    }
    
    func whenAgg(){
        if isKeyPresentInUserDefaults(key: "aggiornamento"){
            let dfgt = UserDefaults.standard.object(forKey: "aggiornamento") as! Date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            dateFormatter.locale = Locale(identifier: "it")
            let dttu = dateFormatter.string(from: dfgt)
            
            if Calendar.current.isDateInToday(dfgt){
                aggiornatoLabel.text! = "AGGIORNATO: OGGI ALLE \(dttu)"
            }else if Calendar.current.isDateInYesterday(dfgt){
                aggiornatoLabel.text! = "AGGIORNATO: IERI ALLE \(dttu)"
            }else{
                dateFormatter.dateFormat = "EEEE dd HH:mm"
                let dttau = dateFormatter.string(from: dfgt)
                aggiornatoLabel.text! = "AGGIORNATO: \(dttau)"
            }
            
        }
    }
    
    func setUp(){
        //ma se il database è empty?
        print("\nfaccio setup")
        print("carico valutazioni dal database prima di ricaricare")
        
        whenAgg()
        setUpInitDatabese()
        //ora aggiorno
        
        //print(votiInDatabase)
        DispatchQueue.main.async {
            self.actInd.isHidden = false
        }
        //tableView.reloadData()
        
        miniSet()
    }
    
    //login
    
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var caricoDue: UIActivityIndicatorView!
    @IBOutlet weak var accediButtonOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainLog: UIView!
    
    @IBAction func accediBut(_ sender: Any) {
        log(id: idTextField.text!, password: passwordTextField.text!)
        accediButtonOutlet.titleLabel?.text! = ""
        caricoDue.isHidden = false
        passwordTextField.resignFirstResponder()
        idTextField.resignFirstResponder()
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(RegistroVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        //refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        voti.removeAll()
        votiInDatabase.removeAll()
        UltraMaterie.removeAll()
        
        tableView.reloadData()
        setUp()
        //viewDidLoad()
        
    }
    
    
    func statoToken(resource: String, id : String, psw: String){//ritorna i secondi prima che il token scada
        //resource es: voti, avvisi
        //https://web.spaggiari.eu/rest/v1/auth/status
        
        let url2 = URL(string: "\(beginnAPI)/auth/status")!
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(tokens, forHTTPHeaderField: "Z-Auth-Token")
        var rs : Double = 6
        var idZh = ""
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            //print(String(data: data!, encoding: .utf8))
            if let response = response, let data = data {
                do {
                    let json = try JSON(data: data)
                    
                    rs =  json["status"]["remains"].doubleValue
                    idZh = json["status"]["ident"].stringValue
                    
                    print(rs)
                    if rs == 0{
                        print("\n\ninvalid token")
                        //get new token
                        self.log(id: id, password: psw)
                    }else{
                        print("\n\nvalid token mancano \(rs/60) minuti")
                        //token valido procedo
                        switch resource{
                        case "voti" :
                            self.getVotiData(token: self.tokens, id: idZh)
                        case "agenda" :
                            self.getAgenda(id: idZh, token: self.tokens)
                        default :
                            print("none")
                            
                        }
                        
                    }
                    
                }
                catch let error as NSError{
                    print(error)
                    
                    //self.setUp()
                    print("problemi")
                }
                
                
            } else {
                print(error)
                print("problemi")
                //self.setUp()
                DispatchQueue.main.async {
                    self.hud?.indicatorView = JGProgressHUDErrorIndicatorView.init()
                    self.hud?.textLabel.text = "È avvenuto un'errore nel caricamento dei dati, assicurati di essere connesso ad internet e ricarica la pagina"
                    self.hud?.show(in: self.view)
                    self.hud?.dismiss(afterDelay: 2.5, animated: true)
                    self.actInd.isHidden = true
                    self.refreshControl.endRefreshing()
                }
            }
            
        }
        
        task2.resume()
        
    }
    
    func getDataAsRecenti() -> [voto]{
        
        var convertedArray: [voto] = []
        
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"// yyyy-MM-dd"
        
        
        
        var ready = convertedArray.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
        
        return ready
    }
    let hud = JGProgressHUD(style: .dark)
    
    func log(id : String, password: String){
        print("nuovo log per token")
        
        let url = URL(string: "\(beginnAPI)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let json: [String: Any] = ["uid":id, "pass": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response, let data = data {
                print(response)
                print(String(data: data, encoding: .utf8))
                do {
                    let parsedData = try JSON(data: data)
                    
                    self.tokens =  parsedData["token"].stringValue
                    self.ident = parsedData["ident"].stringValue
                    self.nomeUt = parsedData["firstName"].stringValue
                    self.cognomeUt = parsedData["lastName"].stringValue
                    self.idUt = parsedData["lastName"].stringValue
                    
                    let info = parsedData["info"].stringValue
                    
                    print(info)
                    if info != ""{
                        print("\n\nerrore nel logIn")
                        DispatchQueue.main.async {
                            self.tableView.separatorStyle = .none
                            self.blurBackground.isHidden = false
                            self.hud?.indicatorView = JGProgressHUDErrorIndicatorView.init()
                            self.hud?.textLabel.text = "È avvenuto un errore nell'accesso: \"\(info)\""
                            self.hud?.show(in: self.view)
                            self.accediButtonOutlet.titleLabel?.text! = "Accedi"
                            self.caricoDue.isHidden = true
                            self.hud?.dismiss(afterDelay: 1.3, animated: true)
                            self.voti.removeAll()
                            self.tableView.reloadData()
                        }
                    }else{
                        print("\n\ntutto ok prendo voti e aggiungo UserDefaults")
                        DispatchQueue.main.async {
                            self.blurBackground.isHidden = true
                            self.caricoDue.isHidden = true
                            self.accediButtonOutlet.titleLabel?.text! = "Accedi"
                        }
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(self.tokens, forKey: "token")
                        self.getVotiData(token: self.tokens, id: self.ident)
                    }
                    //self.getVotiData()
                    
                } catch let error as NSError {
                    print(error)
                }
            } else {
                print(error)
            }
        }
        
        task.resume()
        print("\n\n\n")
        
        
    }
    
    //https://web.spaggiari.eu/rest/v1/students/<id-studente>/periods
    
    func getPeriodi(token : String, id: String){
        var idinurl = id
        
        idinurl.removeFirst()
        
        let url2 = URL(string: "\(beginnAPI)/students/\(idinurl)/subjects")!
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(token, forHTTPHeaderField: "Z-Auth-Token")
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(response)
            //print(String(data: data!, encoding: .utf8))
            if let response = response, let data = data {
                
                do {
                    
                    let json = try JSON(data: data)
                    
                    //let materie =  json["grades"].arrayValue.map({$0["subjectDesc"].stringValue})
                    
                }
                    
                catch let error as NSError{
                    print(error)
                }
                
            } else {
                print(error)
            }
        }
        
        task2.resume()
        
        //-------------------
        
    }
    
    func getAgenda(id: String, token: String){
        print(ident)
        
        var idinurl = id
        
        idinurl.removeFirst()
        
        
        let url2 = URL(string: "\(beginnAPI)/students/\(idinurl)/agenda/all/20171111/20180611")!
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(token, forHTTPHeaderField: "Z-Auth-Token")
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(response)
            print(String(data: data!, encoding: .utf8))
            if let response = response, let data = data {
                CoreDataController.shared.cancellaValutaz()
                do {
                    
                    let json = try JSON(data: data)
                    
                    //let materie =  json["grades"].arrayValue.map({$0["subjectDesc"].stringValue})
                    
                }
                catch let error as NSError{
                    print(error)
                }
                
            } else {
                print(error)
            }
        }
        
        task2.resume()
        
        //-------------------
        
    }
    
    func getVotiData(token : String, id: String){
        
        print(ident)
        
        var idinurl = id
        
        idinurl.removeFirst()
        
        let url2 = URL(string: "\(beginnAPI)/students/\(idinurl)/grades")!
        
        getPeriodi(token: token, id: id)
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(token, forHTTPHeaderField: "Z-Auth-Token")
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(response)
            //print(String(data: data!, encoding: .utf8))
            if let response = response, let data = data {
                CoreDataController.shared.cancellaValutaz()
                do {
                    
                    let json = try JSON(data: data)
                    
                    let materie =  json["grades"].arrayValue.map({$0["subjectDesc"].stringValue})
                    let codici = json["grades"].arrayValue.map({$0["subjectCode"].stringValue})
                    let idMateria = json["grades"].arrayValue.map({$0["subjectId"].stringValue})
                    let data = json["grades"].arrayValue.map({$0["evtDate"].stringValue})
                    let decimale = json["grades"].arrayValue.map({$0["decimalValue"].doubleValue})
                    let displayVoto = json["grades"].arrayValue.map({$0["displayValue"].stringValue})
                    let posizione = json["grades"].arrayValue.map({$0["displaPos"].doubleValue})
                    let notePerFam = json["grades"].arrayValue.map({$0["notesForFamily"].stringValue})
                    let colore = json["grades"].arrayValue.map({$0["color"].stringValue})
                    let periodoPos = json["grades"].arrayValue.map({$0["periodPos"].doubleValue})
                    let tipoVot = json["grades"].arrayValue.map({$0["componentDesc"].stringValue})
                    
                    var d = 0
                    self.voti.removeAll()
                    for a in materie{
                        var dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"// yyyy-MM-dd"
                        
                        let date = dateFormatter.date(from: data[d])
                        
                        let newVot = voto(materia: materie[d], idMateria: idMateria[d], voto: decimale[d], votoMostrabile: displayVoto[d], data: date!, diminutivo: codici[d], displayPos: posizione[d], notesForFamily: notePerFam[d], colore: colore[d], periodPos: periodoPos[d], tipoVoto: tipoVot[d])
                        
                        self.voti.append(newVot)
                        
                        //aggiorno database
                        CoreDataController.shared.newValutazione(materia: materie[d], codice: codici[d], idMateria: idMateria[d], data: data[d], votoDecimale: (Int32(decimale[d]*100)), votoDisplay: displayVoto[d], posizione: Int16(posizione[d]), notePerFam: notePerFam[d], tipoVoto: tipoVot[d], periodoPos: Int16(periodoPos[d]))
                        
                        
                        d += 1;
                    }
                    var hgf = 0;
                    
                    for jh in self.voti{
                        print(jh.materia)
                    }
                    print("\nfine voti\n\n ")
                    for t in self.voti{
                        if t.voto == 0.0{
                            //print(t.voto)
                            var rep = self.translate(da: t.votoMostrabile)
                            print("voto \(t.materia): \(t.votoMostrabile), originariamente : \(t.voto) -> \(rep)")
                            self.voti[hgf].voto = rep
                        }
                        hgf += 1;
                    }//se è o meno un voto senza decimal
                    
                    self.getMaterieAndData()
                    
                    //print(self.voti)
                    //self.votiInDatabase.removeAll()
                    //self.votiInDatabase = CoreDataController.shared.caricaTuttiLeValutazioni()
                    //print("voti in data doppo agg: \(self.votiInDatabase.count)")
                    
                    self.voti = self.voti.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
                    //print(self.voti)
                    self.aggiornato = true
                    
                    //data per aggiornamento
                    
                    
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(Date(), forKey: "aggiornamento")
                        self.aggiornatoLabel.text! = "AGGIORNATO: ADESSO"
                        self.actInd.isHidden = true
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                        
                        Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (timer) in
                            let dfgt = UserDefaults.standard.object(forKey: "aggiornamento") as! Date
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            
                            dateFormatter.locale = Locale(identifier: "it")
                            let dtturr = dateFormatter.string(from: dfgt)
                            
                            if Calendar.current.isDateInToday(dfgt){
                                self.aggiornatoLabel.text! = "AGGIORNATO: OGGI ALLE \(dtturr)"
                            }
                        })
                    }
                    
                    
                }
                catch let error as NSError{
                    print(error)
                }
                
            } else {
                print(error)
            }
        }
        
        task2.resume()
        
        //-------------------
        
    }
    
    
    
    //per collView
    var titoli = ["Voti", "Agenda", "Assenze", "Note", "Lezioni", "Esci"]
    var descr = ["CONTROLLA I TUOI VOTI", "ESERCITAZIONI, COMPITI", "ASSENZE, RITARDI, USCITE", "NOTE DISCIPLINARI", "ARGOMENTI DELLE LEZIONI", ""]
    var colori1 : [UIColor] = [UIColor.flatPink(), UIColor.flatBlue(), UIColor.flatMint(), UIColor.flatWatermelon(), UIColor.flatTeal(), UIColor.flatLime()]
    var colori2 : [UIColor] = [UIColor.flatPinkColorDark(), UIColor.flatBlueColorDark(), UIColor.flatMintColorDark(), UIColor.flatWatermelonColorDark(), UIColor.flatTealColorDark(), UIColor.flatLimeColorDark()]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titoli.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clee", for: indexPath) as! selectionCell
        
        cell.view.layer.cornerRadius = 14.0
        cell.view.layer.shadowColor = UIColor.gray.cgColor
        cell.view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.view.layer.shadowRadius = 7.0
        cell.view.layer.shadowOpacity = 0.4
        
        if indexPath.row == 0{
            //cell.view.layer.borderWidth = 3.5
            //cell.view.layer.borderColor = FlatYellow().cgColor
        }
        
        cell.titolo.text! = titoli[indexPath.row]
        cell.desc.text! = descr[indexPath.row]
        
        cell.view.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: cell.view.frame, colors: [colori1[indexPath.row], colori2[indexPath.row]])
        
        //cell.back.layer.cornerRadius = 14
        //cell.back.clipsToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 5{
            print("sixxxx")
            UserDefaults.standard.set("bfbfgruSKIIIIUTYYYYTTY", forKey: "token")
            UserDefaults.standard.set("bfbfgruSKIIIIUTYYYYTTY", forKey: "id")
            voti.removeAll()
            votiInDatabase.removeAll()
            UltraMaterie.removeAll()
            setUp()
        }
        if indexPath.row == 1{
            //navigationController?.setNavigationBarHidden(true, animated: false)
            trAg = true
            performSegue(withIdentifier: "hgfd", sender: nil)
        }
        
        if indexPath.row == 2{
            performSegue(withIdentifier: "toAssenze", sender: nil)
        }
        
        if indexPath.row == 3{
            performSegue(withIdentifier: "toNote", sender: nil)
        }
        
        if indexPath.row == 0{
            voti.removeAll()
            votiInDatabase.removeAll()
            UltraMaterie.removeAll()
            
            tableView.reloadData()
            setUp()
        }
        
        if indexPath.row == 4{
            performSegue(withIdentifier: "toLezioni", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMaterie && UltraMaterie.count == 0{
            return 0
        }
        if isMaterie && UltraMaterie.count != 0{
            print("numMat = \(UltraMaterie.count)")
            return UltraMaterie.count+1
            
        }
        if aggiornato{
            return voti.count
        }else{
            return 0
        }
    }
    
    var aggiornato = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isMaterie == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mat", for: indexPath) as! cellForTTmat
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            cell.view1.layer.cornerRadius = 14.0
            cell.view1.layer.shadowColor = UIColor.gray.cgColor
            cell.view1.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.view1.layer.shadowRadius = 5.0
            cell.view1.layer.shadowOpacity = 0.2
            
            if indexPath.row == 0{
                //cella media complessiva
                
                cell.materia.text! = "MEDIA GENERALE"
                var ttVSP = 0;
                for t in UltraMaterie{
                    ttVSP += t.votiSP.count
                }
                if ttVSP == 0{
                    //siamo nel primo periodo
                    var trlP : Double = 0
                    var cntP = 0
                    var totVotiPP = 0;
                    
                    for t in UltraMaterie{
                        trlP += t.mediaPP
                        cntP += 1
                        totVotiPP += t.votiPP.count
                    }
                    let mediaPP = round(100*(trlP/Double(cntP)))/100
                    
                    cell.mainPeriodo.text! = "Primo periodo"
                    if totVotiPP == 1 && cntP == 1{
                        cell.mainNumeroVoti.text! = "1 materia, 1 voto"
                    }else if totVotiPP != 1 && cntP == 1{
                        cell.mainNumeroVoti.text! = "1 materia, \(totVotiPP) voti"
                    }else if totVotiPP != 1 && cntP != 1{
                        cell.mainNumeroVoti.text! = "\(cntP) materie, \(totVotiPP) voti"
                    }
                    
                    if mediaPP < 5{
                        cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                        cell.prRing.outerRingColor = UIColor.flatRedColorDark()
                    }else if mediaPP > 5.75{
                        cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                        cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
                    }else{
                        cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                        cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
                    }
                    cell.votoMain.text! = "\((round(100*mediaPP)/100))"
                    cell.prRing.setProgress(value: CGFloat(mediaPP), animationDuration: 2.5)
                    
                }else{//sec periodo
                    var trlSP : Double = 0
                    var cntSP = 0
                    var totVotiSP = 0;
                    
                    for t in UltraMaterie{
                        trlSP += t.mediaSP
                        cntSP += 1
                        totVotiSP += t.votiSP.count
                    }
                    let mediaSP = round(100*(trlSP/Double(cntSP)))/100
                    
                    cell.mainPeriodo.text! = "Secondo periodo"
                    if totVotiSP == 1 && cntSP == 1{
                        cell.mainNumeroVoti.text! = "1 materia, 1 voto"
                    }else if totVotiSP != 1 && cntSP == 1{
                        cell.mainNumeroVoti.text! = "1 materia, \(totVotiSP) voti"
                    }else if totVotiSP != 1 && cntSP != 1{
                        cell.mainNumeroVoti.text! = "\(cntSP) materie, \(totVotiSP) voti"
                    }
                    //siamo nel secondo periodo
                    if mediaSP < 5{
                        cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                        cell.prRing.outerRingColor = UIColor.flatRedColorDark()
                    }else if mediaSP > 5.99{
                        cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                        cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
                    }else{
                        cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                        cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
                    }
                    cell.votoMain.text! = "\((round(100*mediaSP)/100))"
                    cell.prRing.setProgress(value: CGFloat(mediaSP), animationDuration: 2.5)
                    
                }
                var trl : Double = 0
                var cnt = 0
                var totVoti = 0;
                print("ultramattt : \(UltraMaterie.count)")
                for t in UltraMaterie{
                    totVoti += t.votiPP.count+t.votiSP.count
                    trl += t.mediaPP+t.mediaSP
                    if t.mediaSP != 0.0{
                        cnt += 2}else{
                        cnt += 1
                    }
                }
                
                
                let mediaTot = round(100*(trl/Double(cnt)))/100
                
                if totVoti == 1 && cnt == 1{
                    cell.votiComlessivo.text! = "1 materia, 1 voto"
                }else if totVoti != 1 && cnt == 1{
                    cell.votiComlessivo.text! = "1 materia, \(totVoti) voti"
                }else if totVoti != 1 && cnt != 1{
                    cell.votiComlessivo.text! = "\(cnt) materie, \(totVoti) voti"
                }
                
                let mediaComp = mediaTot
                
                if mediaComp < 5{
                    cell.prRingComplessivo.innerRingColor = UIColor.flatRedColorDark()
                    cell.prRingComplessivo.outerRingColor = UIColor.flatRedColorDark()
                }else if mediaComp > 5.99{
                    cell.prRingComplessivo.innerRingColor = UIColor.flatGreenColorDark()
                    cell.prRingComplessivo.outerRingColor = UIColor.flatGreenColorDark()
                }else{
                    cell.prRingComplessivo.innerRingColor = UIColor.flatYellowColorDark()
                    cell.prRingComplessivo.outerRingColor = UIColor.flatYellowColorDark()
                }
                
                cell.votoComp.text! = "\((round(10*mediaComp)/10))"
                
                cell.prRingComplessivo.setProgress(value: CGFloat(mediaComp), animationDuration: 0.8)
                cell.selectionStyle = .none
                return cell
            }
            
            cell.materia.text! = UltraMaterie[indexPath.row-1].votiPP[0].materia
            if UltraMaterie[indexPath.row-1].votiSP.count == 0{
                //siamo nel primo periodo
                cell.mainPeriodo.text! = "Primo periodo"
                if UltraMaterie[indexPath.row-1].votiPP.count == 1{
                    cell.mainNumeroVoti.text! = "1 voto"
                }else{
                    cell.mainNumeroVoti.text! = "\(UltraMaterie[indexPath.row-1].votiPP.count) voti"
                }
                
                if UltraMaterie[indexPath.row-1].mediaPP < 5{
                    cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                    cell.prRing.outerRingColor = UIColor.flatRedColorDark()
                }else if UltraMaterie[indexPath.row-1].mediaPP > 5.75{
                    cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                    cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
                }else{
                    cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                    cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
                }
                cell.votoMain.text! = "\((round(100*UltraMaterie[indexPath.row-1].mediaPP)/100))"
                cell.prRing.setProgress(value: CGFloat(UltraMaterie[indexPath.row-1].mediaPP), animationDuration: 2.5)
                
            }else{
                
                //siamo nel secondo periodo
                cell.mainPeriodo.text! = "Secondo periodo"
                if UltraMaterie[indexPath.row-1].votiSP.count == 1{
                    cell.mainNumeroVoti.text! = "1 voto"
                }else{
                    cell.mainNumeroVoti.text! = "\(UltraMaterie[indexPath.row-1].votiSP.count) voti"
                }
                if UltraMaterie[indexPath.row-1].mediaSP < 5{
                    cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                    cell.prRing.outerRingColor = UIColor.flatRedColorDark()
                }else if UltraMaterie[indexPath.row-1].mediaSP > 5.99{
                    cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                    cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
                }else{
                    cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                    cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
                }
                
                cell.votoMain.text! = "\((round(100*UltraMaterie[indexPath.row-1].mediaSP)/100))"
                
                cell.prRing.setProgress(value: CGFloat(UltraMaterie[indexPath.row-1].mediaSP), animationDuration: 0.8)
                
                
            }
            
            if UltraMaterie[indexPath.row-1].votiSP.count+UltraMaterie[indexPath.row-1].votiPP.count == 1{
                cell.votiComlessivo.text! = "1 voto"
            }else{
                cell.votiComlessivo.text! = "\(UltraMaterie[indexPath.row-1].votiSP.count+UltraMaterie[indexPath.row-1].votiPP.count) voti"
            }
            
            var mediaComp = (UltraMaterie[indexPath.row-1].mediaSP+UltraMaterie[indexPath.row-1].mediaPP)/2
            if UltraMaterie[indexPath.row-1].mediaSP == 0.0{
                mediaComp = UltraMaterie[indexPath.row-1].mediaPP
            }
            
            if mediaComp == 0.0{
                cell.prRingComplessivo.innerRingColor = UIColor.flatSkyBlue()
                cell.prRingComplessivo.outerRingColor = UIColor.flatSkyBlue()
            }
            
            if mediaComp < 5{
                cell.prRingComplessivo.innerRingColor = UIColor.flatRedColorDark()
                cell.prRingComplessivo.outerRingColor = UIColor.flatRedColorDark()
            }else if mediaComp > 5.99{
                cell.prRingComplessivo.innerRingColor = UIColor.flatGreenColorDark()
                cell.prRingComplessivo.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                cell.prRingComplessivo.innerRingColor = UIColor.flatYellowColorDark()
                cell.prRingComplessivo.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            cell.votoComp.text! = "\((round(10*mediaComp)/10))"
            
            cell.prRingComplessivo.setProgress(value: CGFloat(mediaComp), animationDuration: 0.8)
            cell.selectionStyle = .none
            return cell
            
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pier", for: indexPath) as! tvCell
        
        if aggiornato{
            //print("\nagg")
            print(voti[indexPath.row].voto)
            
            if voti[indexPath.row].voto < 5{
                cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                cell.prRing.outerRingColor = UIColor.flatRedColorDark()
            }else if voti[indexPath.row].voto > 5.99{
                cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            if voti[indexPath.row].voto == 0.0{
                cell.prRing.innerRingColor = UIColor.flatSkyBlue()
                cell.prRing.outerRingColor = UIColor.flatSkyBlue()
            }
            
            cell.prRing.setProgress(value: CGFloat(voti[indexPath.row].voto), animationDuration: 0.5)
            cell.materia.text! = (voti[indexPath.row].materia.lowercased().capitalized)
            cell.voto.text! = voti[indexPath.row].votoMostrabile
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "dd MMMM yyyy"
            
            let now = dateformatter.string(from: voti[indexPath.row].data)
            var periodo = ""
            if voti[indexPath.row].periodPos == 1.0{
                periodo = "1º periodo"
            }else{
                periodo = "2º periodo"
            }
            
            cell.tipoEData.text! = "\(voti[indexPath.row].tipoVoto) ~ \(now) ~ \(periodo)"
            cell.descriz.text! = voti[indexPath.row].notesForFamily
            cell.selectionStyle = .none
            
            return cell
        }else{
            //print("\nnon agg")
            /*
             if votiInDatabase[indexPath.row].votoDecimale < 500{
             cell.prRing.innerRingColor = UIColor.flatRedColorDark()
             cell.prRing.outerRingColor = UIColor.flatRedColorDark()
             }else if votiInDatabase[indexPath.row].votoDecimale > 599{
             cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
             cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
             }else{
             cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
             cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
             }
             
             cell.prRing.setProgress(value: CGFloat(votiInDatabase[indexPath.row].votoDecimale/100), animationDuration: 0.5)
             cell.materia.text! = (votiInDatabase[indexPath.row].materia?.lowercased().capitalizingFirstLetter())!
             cell.voto.text! = votiInDatabase[indexPath.row].votoDisplay!
             cell.tipoEData.text! = "\(votiInDatabase[indexPath.row].tipoVoto!) ~ \(votiInDatabase[indexPath.row].data!)"
             cell.descriz.text! = votiInDatabase[indexPath.row].notePerFamiglia!
             cell.selectionStyle = .none*/
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmented.selectedIndex == 1 && indexPath.row != 0{
            materiaTrans = UltraMaterie[indexPath.row-1].votiPP[0].materia.lowercased().capitalized
            tranzIndex = indexPath.row-1
            performSegue(withIdentifier: "tranzReg", sender: nil)
        }
    }
    @IBAction func esciBt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //logIn
    
    func translate(da: String)->Double{
       
        return 0.0
    }
    
}

