//
//  LezioniVC.swift
//  MySchool
//
//  Created by Enrico Alberti on 25/09/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import SwiftyJSON

class LessCell : UITableViewCell{
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var autore: UILabel!
    @IBOutlet weak var materia: UILabel!
    @IBOutlet weak var tipoLezione: UILabel!
    @IBOutlet weak var descrizione: UITextView!
}

class LezioniVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.allowsSelection = false
        if lezioni.count == 0{
            noData.isHidden = false
            tableView.separatorStyle = .none
        }else{
            noData.isHidden = true
            tableView.separatorStyle = .singleLineEtched
        }
        if isMaterie{
            tableView.allowsSelection = true
            isMatView.isHidden = false
            isMatText.text! = "Seleziona una materia"
            noData.isHidden = true
            return materie.count
        }
        isMatView.isHidden = true
        if isSelMat{//selezionata materia specifica
            isMatView.isHidden = false
        }
        
        return lezioni.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isMatText.text! = materie[indexPath.row].materia.capitalized
        mouttt.setTitle("materie", for: .normal)
        selMateria = materie[indexPath.row].id
        setUpLezioni(tipo: "sdadsarr")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isMaterie{
            return 75
        }else{
            tableView.estimatedRowHeight = 124
            return UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var isMatView: UIView!
    
    @IBOutlet weak var isMatText: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        
        if isMaterie{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mjhgfj") as! materiaCellL
            
            cell.materia.text! = materie[indexPath.row].materia.capitalized
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clll") as! LessCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it")
        let dttu = dateFormatter.string(from: lezioni[indexPath.row].date)
        
        cell.autore.text! = lezioni[indexPath.row].autore.capitalized
        cell.tipoLezione.text! = lezioni[indexPath.row].tipoLezione
        
        cell.data.text! = "\(Int(lezioni[indexPath.row].position))º ora, \(Int(lezioni[indexPath.row].duration)) ore"
        
        if Int(lezioni[indexPath.row].duration) == 1{
            cell.data.text! = "\(Int(lezioni[indexPath.row].position))º ora, \(Int(lezioni[indexPath.row].duration)) ora"
        }
        
        cell.materia.text! = lezioni[indexPath.row].materia.capitalized
        cell.descrizione.text! = lezioni[indexPath.row].descrizione
        if isSelMat{
            cell.data.text! = dttu
        }
        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLezioni(tipo: "agenda")
        
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    var isMaterie = false
    
    
    @IBAction func mtSCC(_ sender: Any) {
        if !isMaterie{
            mouttt.setTitle("", for: .normal)
        }else{
            mouttt.setTitle("materie", for: .normal)
        }
        isMatView.isHidden = false
        isSelMat = false
        isMaterie = true
        setUpLezioni(tipo: "mat")
    }
    
    @IBOutlet weak var matOut: UIBarButtonItem!
    
    @IBAction func materieSelected(_ sender: Any) {
        if isMaterie || isSelMat{
            matOut.title! = "materie"
            currentDate = Date()
            isMaterie = false
            isSelMat = false
            Data.text! = "Oggi"
            lezioni.removeAll()
            isMatView.isHidden = true
            setUpLezioni(tipo: "agenda")
        }else{
            matOut.title! = "per giorno"
            isMatView.isHidden = false
            isMaterie = true
            setUpLezioni(tipo: "mat")
        }
    }
    
    
    @IBOutlet weak var Data: UILabel!
    @IBAction func backDay(_ sender: Any) {
        currentDate = currentDate.dayBefore
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM"
        dateFormatter.locale = Locale(identifier: "it")
        let dttu = dateFormatter.string(from:currentDate)
        Data.text! = dttu
        if Calendar.current.isDateInToday(currentDate){
            Data.text! = "Oggi"
        }else if Calendar.current.isDateInYesterday(currentDate){
            Data.text! = "Ieri"
        }
        lezioni.removeAll()
        setUpLezioni(tipo: "agenda")
    }
    @IBOutlet weak var caricamento: UIView!
    
    @IBAction func frontDay(_ sender: Any) {
        currentDate = currentDate.dayAfter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM"
        dateFormatter.locale = Locale(identifier: "it")
        let dttu = dateFormatter.string(from:currentDate)
        
        Data.text! = dttu
        if currentDate == Date(){
            Data.text! = "Oggi"
        }
        if Calendar.current.isDateInToday(currentDate){
            Data.text! = "Oggi"
        }else if Calendar.current.isDateInYesterday(currentDate){
            Data.text! = "Ieri"
        }
        lezioni.removeAll()
        setUpLezioni(tipo: "agenda")
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func setUpLezioni(tipo : String){
        caricamento.isHidden = false
        if isKeyPresentInUserDefaults(key: "id") && isKeyPresentInUserDefaults(key: "password") && isKeyPresentInUserDefaults(key: "token"){
            //utente ha gia fatto l'accesso, controllo il token
            print("\nutente ha fatto accesso, controllo token")
            tokenz = UserDefaults.standard.object(forKey: "token") as! String
            if tipo == "agenda"{
                statoToken(resource: "agenda", id: UserDefaults.standard.object(forKey: "id") as! String, psw: UserDefaults.standard.object(forKey: "password") as! String)
            }else if tipo == "mat"{
                statoToken(resource: "mat", id: UserDefaults.standard.object(forKey: "id") as! String, psw: UserDefaults.standard.object(forKey: "password") as! String)
            }else{
                statoToken(resource: "selec", id: UserDefaults.standard.object(forKey: "id") as! String, psw: UserDefaults.standard.object(forKey: "password") as! String)
            }
        }else{
            //altrimenti gli faccio fare l'accesso
            print("nessun dato, faccio fare accesso")
            
            //salvo in USERDefaults
            
        }
    }
    var tokenz = ""
    
    @IBOutlet weak var mouttt: UIButton!
    
    func statoToken(resource: String, id : String, psw: String){//ritorna i secondi prima che il token scada
        //resource es: voti, avvisi
        //https://web.spaggiari.eu/rest/v1/auth/status
        
        let url2 = URL(string: "https://web17.spaggiari.eu/rest/v1/auth/status")!
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(tokenz, forHTTPHeaderField: "Z-Auth-Token")
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
                        if resource == "agenda"{
                            self.log(id: idZh, password: psw, res: "agenda")
                        }else if resource == "mat"{
                            self.log(id: idZh, password: psw, res: "mat")
                        }else{
                            self.getMateriaSpec(id: idZh, token: self.tokenz)
                        }
                        
                    }else{
                        print("\n\nvalid token mancano \(rs/60) minuti")
                        //token valido procedo
                        if resource == "agenda"{
                            self.getAgenda(id: idZh, token: self.tokenz)
                        }else if resource == "mat"{
                            self.getMaterie(id: idZh, token: self.tokenz)
                        }else{
                            self.getMateriaSpec(id: idZh, token: self.tokenz)
                        }
                    }
                    
                }
                catch let error as NSError{
                    print(error)
                    self.setUpLezioni(tipo: resource)
                }
                
                
            } else {
                print(error)
                self.setUpLezioni(tipo: resource)
            }
            
        }
        
        task2.resume()
        
    }
    
    
    @IBOutlet weak var noData: UIView!
    
    func log(id : String, password: String, res : String){
        print("nuovo log per token")
        
        let url = URL(string: "https://web17.spaggiari.eu/rest/v1/auth/login")!
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
                    
                    self.tokenz =  parsedData["token"].stringValue
                    
                    let info = parsedData["info"].stringValue
                    
                    print(info)
                    if info != ""{
                        print("\n\nerrore nel logIn")
                        DispatchQueue.main.async {
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            //self.voti.removeAll()
                            //self.tableView.reloadData()
                        }
                    }else{
                        print("\n\ntutto ok prendo agenda e aggiungo UserDefaults")
                        DispatchQueue.main.async {
                        }
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(self.tokenz, forKey: "token")
                        if res == "agenda"{
                            self.getAgenda(id: id, token: self.tokenz)
                        }else if res == "mat"{
                            self.getMaterie(id: id, token: self.tokenz)
                        }else{
                            self.getMateriaSpec(id: id, token: self.tokenz)
                        }
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
    
    var selMateria = ""
    var isSelMat = false
    
    var currentDate = Date()
    
    func getMateriaSpec(id: String, token: String){
        var idinurl = id
        isSelMat = true
        print("\n getting materie")
        
        idinurl.removeFirst()
        
        lezioni.removeAll()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "yyyyMMdd"
        
        let risultato = formatter.string(from: currentDate)
        
        
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/students/\(idinurl)/lessons/20180901/\(risultato)/\(selMateria)")!
        
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
                    
                    let evtDate = json["lessons"].arrayValue.map({$0["evtDate"].stringValue})
                    let evtPos = json["lessons"].arrayValue.map({$0["evtHPos"].doubleValue})
                    let evtId = json["lessons"].arrayValue.map({$0["evtId"].doubleValue})
                    let duration = json["lessons"].arrayValue.map({$0["evtDuration"].doubleValue})
                    let authorName = json["lessons"].arrayValue.map({$0["authorName"].stringValue})
                    let subjectId = json["lessons"].arrayValue.map({$0["subjectId"].stringValue})
                    let materia = json["lessons"].arrayValue.map({$0["subjectDesc"].stringValue})
                    let tipoLezione = json["lessons"].arrayValue.map({$0["lessonType"].stringValue})
                    let descrizione = json["lessons"].arrayValue.map({$0["lessonArg"].stringValue})
                    
                    
                    var f = 0
                    
                    for _ in evtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:evtDate[f])!
                        
                        let newLez = lezione(id: evtId[f], date: date, position: evtPos[f], duration: duration[f], autore: authorName[f], materia: materia[f], tipoLezione: tipoLezione[f], descrizione: descrizione[f])
                        
                        self.lezioni.append(newLez)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    self.lezioni = self.lezioni.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                    /*self.lezioni = self.lezioni.sorted(by: {$0.position < $1.position})*/
                    //print(self.assenze)
                    self.isMaterie = false
                    DispatchQueue.main.async {
                        if !self.isMaterie && self.isSelMat{
                            self.tableView.reloadData()
                            self.caricamento.isHidden = true
                            // self.caric.isHidden = true
                        }
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
    }
    
    func getMaterie(id: String, token: String){
        var idinurl = id
        materie.removeAll()
        print("\n getting materie")
        
        idinurl.removeFirst()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "yyyyMMdd"
        
        let risultato = formatter.string(from: currentDate)
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let dscAA = Date()
        let sec = dscAA.monthAfter
        let frt = formatter.string(from: sec)
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/students/\(idinurl)/subjects")!
        
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
                    
                    let evtId = json["subjects"].arrayValue.map({$0["id"].stringValue})
                    let description = json["subjects"].arrayValue.map({$0["description"].stringValue})
                    
                    var f = 0
                    
                    for _ in evtId{
                        
                        let newLz = materia(materia: description[f], id: evtId[f])
                        self.materie.append(newLz)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    DispatchQueue.main.async {
                        if self.isMaterie && !self.isSelMat{
                            self.tableView.reloadData()
                            self.caricamento.isHidden = true
                            // self.caric.isHidden = true
                        }
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
    }
    
    func getAgenda(id: String, token: String){
        
        var idinurl = id
        
        idinurl.removeFirst()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "yyyyMMdd"
        
        let risultato = formatter.string(from: currentDate)
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let dscAA = Date()
        let sec = dscAA.monthAfter
        let frt = formatter.string(from: sec)
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/students/\(idinurl)/lessons/\(risultato)")!
        
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
                    
                    let evtDate = json["lessons"].arrayValue.map({$0["evtDate"].stringValue})
                    let evtPos = json["lessons"].arrayValue.map({$0["evtHPos"].doubleValue})
                    let evtId = json["lessons"].arrayValue.map({$0["evtId"].doubleValue})
                    let duration = json["lessons"].arrayValue.map({$0["evtDuration"].doubleValue})
                    let authorName = json["lessons"].arrayValue.map({$0["authorName"].stringValue})
                    let subjectId = json["lessons"].arrayValue.map({$0["subjectId"].stringValue})
                    let materia = json["lessons"].arrayValue.map({$0["subjectDesc"].stringValue})
                    let tipoLezione = json["lessons"].arrayValue.map({$0["lessonType"].stringValue})
                    let descrizione = json["lessons"].arrayValue.map({$0["lessonArg"].stringValue})
                    
                    
                    var f = 0
                    
                    for _ in evtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:evtDate[f])!
                        
                        let newLez = lezione(id: evtId[f], date: date, position: evtPos[f], duration: duration[f], autore: authorName[f], materia: materia[f], tipoLezione: tipoLezione[f], descrizione: descrizione[f])
                        
                        self.lezioni.append(newLez)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    //self.lezioni = self.lezioni.sorted(by: { $0.position.compare($1.position) == .orderedDescending })
                    self.lezioni = self.lezioni.sorted(by: {$0.position < $1.position})
                    //print(self.assenze)
                    
                    DispatchQueue.main.async {
                        if !self.isMaterie && !self.isSelMat{
                            self.tableView.reloadData()
                            self.caricamento.isHidden = true
                        }
                        // self.caric.isHidden = true
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
        
    }
    
    struct materia {
        var materia : String
        var id : String
    }
    
    var materie : [materia] = []
    
    struct lezione {
        var id : Double
        var date : Date
        var position : Double
        var duration : Double
        var autore : String
        var materia : String
        var tipoLezione : String
        var descrizione : String
    }
    
    var lezioni : [lezione] = []
    
}
