//
//  NoteVC.swift
//  MySchool
//
//  Created by Enrico Alberti on 23/09/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import SwiftyJSON

class notaCell : UITableViewCell{
    @IBOutlet weak var tipoEvento: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var autore: UILabel!
    @IBOutlet weak var testo: UITextView!
    
}

class NoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if note.count == 0 {
            noData.isHidden = false
        }else{
            noData.isHidden = true
        }
        return note.count
    }
    @IBOutlet weak var caric: UIView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ncel") as! notaCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it")
        let dttu = dateFormatter.string(from: note[indexPath.row].date)
        
        cell.autore.text! = note[indexPath.row].author.capitalized
        cell.data.text! = dttu
        cell.testo.text! = note[indexPath.row].text
        cell.tipoEvento.text! = note[indexPath.row].tipo
        
        return cell
    }
    
    
    @IBOutlet weak var noData: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 97
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setUpAgenda()
        // Do any additional setup after loading the view.
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func setUpAgenda(){
        if isKeyPresentInUserDefaults(key: "id") && isKeyPresentInUserDefaults(key: "password") && isKeyPresentInUserDefaults(key: "token"){
            //utente ha gia fatto l'accesso, controllo il token
            print("\nutente ha fatto accesso, controllo token")
            tokenz = UserDefaults.standard.object(forKey: "token") as! String
            statoToken(resource: "agenda", id: UserDefaults.standard.object(forKey: "id") as! String, psw: UserDefaults.standard.object(forKey: "password") as! String)
        }else{
            //altrimenti gli faccio fare l'accesso
            print("nessun dato, faccio fare accesso")
            
            //salvo in USERDefaults
            
        }
    }
    var tokenz = ""
    func statoToken(resource: String, id : String, psw: String){//ritorna i secondi prima che il token scada
        //resource es: voti, avvisi
        //https://web.spaggiari.eu/rest/v1/auth/status
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/auth/status")!
        
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
                        self.log(id: idZh, password: psw)
                    }else{
                        print("\n\nvalid token mancano \(rs/60) minuti")
                        //token valido procedo
                        
                        self.getAgenda(id: idZh, token: self.tokenz)
                        
                    }
                    
                }
                catch let error as NSError{
                    print(error)
                    self.setUpAgenda()
                }
                
                
            } else {
                print(error)
                self.setUpAgenda()
            }
            
        }
        
        task2.resume()
        
    }
    
    func log(id : String, password: String){
        print("nuovo log per token")
        
        let url = URL(string: "https://web.spaggiari.eu/rest/v1/auth/login")!
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
                        self.getAgenda(id: id, token: self.tokenz)
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
    
    func getAgenda(id: String, token: String){
        
        var idinurl = id
        
        idinurl.removeFirst()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "yyyyMMdd"
        
        let today = Date()
        let risultato = formatter.string(from: Date())
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let dscAA = Date()
        let sec = dscAA.monthAfter
        let frt = formatter.string(from: sec)
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/students/\(idinurl)/notes/all/")!
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        request2.addValue("+zorro+", forHTTPHeaderField: "Z-Dev-ApiKey")
        request2.addValue("zorro/1.0", forHTTPHeaderField: "User-Agent")
        request2.addValue(token, forHTTPHeaderField: "Z-Auth-Token")
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(response)
            print(String(data: data!, encoding: .utf8))
            if let response = response, let data = data {
                
                do {
                    
                    let json = try JSON(data: data)
                    
                    let NTTEevtId = json["NTTE"].arrayValue.map({$0["evtId"].doubleValue})
                    let NTTEevtText = json["NTTE"].arrayValue.map({$0["evtText"].stringValue})
                    let NTTEevtDate = json["NTTE"].arrayValue.map({$0["evtDate"].stringValue})
                    let NTTEauthorName = json["NTTE"].arrayValue.map({$0["authorName"].stringValue})
                    let NTTEreadStatus = json["NTTE"].arrayValue.map({$0["readStatus"].boolValue})
                    //evtValue mai usato
                    let NTCLevtId = json["NTCL"].arrayValue.map({$0["evtId"].doubleValue})
                    let NTCLevtText = json["NTCL"].arrayValue.map({$0["evtText"].stringValue})
                    let NTCLevtDate = json["NTCL"].arrayValue.map({$0["evtDate"].stringValue})
                    let NTCLauthorName = json["NTCL"].arrayValue.map({$0["authorName"].stringValue})
                    let NTCLreadStatus = json["NTCL"].arrayValue.map({$0["readStatus"].boolValue})
                    //-----------------
                    let NTWNevtId = json["NTWN"].arrayValue.map({$0["evtId"].doubleValue})
                    let NTWNevtText = json["NTWN"].arrayValue.map({$0["evtText"].stringValue})
                    let NTWNevtDate = json["NTWN"].arrayValue.map({$0["evtDate"].stringValue})
                    let NTWNauthorName = json["NTWN"].arrayValue.map({$0["authorName"].stringValue})
                    let NTWNreadStatus = json["NTWN"].arrayValue.map({$0["readStatus"].boolValue})
                    //---------
                    let NTSTevtId = json["NTST"].arrayValue.map({$0["evtId"].doubleValue})
                    let NTSTevtText = json["NTST"].arrayValue.map({$0["evtText"].stringValue})
                    let NTSTevtDate = json["NTST"].arrayValue.map({$0["evtBegin"].stringValue})
                    let NTSTauthorName = json["NTST"].arrayValue.map({$0["authorName"].stringValue})
                    let NTSTreadStatus = json["NTST"].arrayValue.map({$0["readStatus"].boolValue})
                    
                    var f = 0
                    
                    for _ in NTTEevtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:NTTEevtDate[f])!
                        
                        let nota = notaz(id: NTTEevtId[f], text: NTTEevtText[f], date: date, author: NTTEauthorName[f], isRead: NTTEreadStatus[f], tipo: "Nota dell'insegnante")
                        
                        self.note.append(nota)
                        
                        //aggiungi dati
                        f += 1
                    }
                    f = 0
                    
                    for _ in NTCLevtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:NTCLevtDate[f])!
                        
                        let nota = notaz(id: NTCLevtId[f], text: NTCLevtText[f], date: date, author: NTCLauthorName[f], isRead: NTCLreadStatus[f], tipo: "Nota sul registro")
                        
                        self.note.append(nota)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    
                    f = 0
                    for _ in NTWNevtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:NTWNevtDate[f])!
                        
                        let nota = notaz(id: NTWNevtId[f], text: NTWNevtText[f], date: date, author: NTWNauthorName[f], isRead: NTWNreadStatus[f], tipo: "Richiamo")
                        
                        self.note.append(nota)
                        
                        //aggiungi dati
                        f += 1
                    }
                    f = 0
                    for _ in NTSTevtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:NTSTevtDate[f])!
                        
                        let nota = notaz(id: NTSTevtId[f], text: NTSTevtText[f], date: date, author: NTSTauthorName[f], isRead: NTSTreadStatus[f], tipo: "Sanzione disciplinare")
                        
                        self.note.append(nota)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    self.note = self.note.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                    print(self.note)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.caric.isHidden = true
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
    
    var note : [notaz] = []
    
    struct notaz{
        var id : Double
        var text : String
        var date : Date
        var author : String
        var isRead : Bool
        var tipo : String
    }
    
}
