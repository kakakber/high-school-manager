//
//  AssenzeVC.swift
//  MySchool
//
//  Created by Enrico Alberti on 21/09/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import SwiftyJSON

class assenzeCell : UITableViewCell{
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var descrizione: UILabel!
    @IBOutlet weak var giustIMG: UIImageView!
}

class materiaCellL : UITableViewCell{
    @IBOutlet weak var materia: UILabel!
}

class AssenzeVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAgenda()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBOutlet weak var caric: UIView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        num1.text! = "\(assenzeassenze.count)"
        num2.text! = "\(ritardi.count)"
        num3.text! = "\(uscite.count)"
        if assNonGiust == 0{
            com1.text! = "Tutte giustificate"
            img1.image = UIImage(named: "verified")//multiply
        }else{
            com1.text! = "\(assNonGiust) da giustificare"
            img1.image = UIImage(named: "multiply")
        }
        if uscNonGiust == 0{
            com3.text! = "Tutte giustificate"
            img3.image = UIImage(named: "verified")//multiply
        }else{
            com3.text! = "\(uscNonGiust) da giustificare"
            img3.image = UIImage(named: "multiply")
        }
        if ritNonGiust == 0{
            com2.text! = "Tutti giustificati"
            img2.image = UIImage(named: "verified")//multiply
        }else{
            com2.text! = "\(ritNonGiust) da giustificare"
            img2.image = UIImage(named: "multiply")
        }
        if assenze.count == 0 {
            noData.isHidden = false
        }else{
            noData.isHidden = true
        }
        
        if assenzeassenze.count != 0{
            nod1.isHidden = true
        }
        if ritardi.count != 0{
            nod2.isHidden = true
        }
        if uscite.count != 0{
            nod3.isHidden = true
        }
        
        return assenze.count
    }
    
    @IBOutlet weak var com1: UILabel!
    @IBOutlet weak var com2: UILabel!
    @IBOutlet weak var com3: UILabel!
    
    @IBOutlet weak var num1: UILabel!
    @IBOutlet weak var num2: UILabel!
    @IBOutlet weak var num3: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var nod1: UIView!
    @IBOutlet weak var nod2: UIView!
    @IBOutlet weak var nod3: UIView!
    
    
    @IBOutlet weak var noData: UIView!
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assc") as! assenzeCell
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "it")
        let dttu = dateFormatter.string(from: assenze[indexPath.row].date) // Jan 2, 2001
        
        cell.data.text! = dttu
        if assenze[indexPath.row].ora != ""{
            cell.data.text! = "\(dttu) ~ \(assenze[indexPath.row].ora)º ora"
        }
        
        var codc = "ASSENZA"
        switch assenze[indexPath.row].code{
        case "ABA0":
            codc = "ASSENZA"
        case "ABR0":
            codc = "RITARDO"
        case "ABR1":
            codc = "RITARDO BREVE"
        case "ABU0":
            codc = "USCITA"
        default:
            codc = "EVENTO SCONOSCIUTO"
        }
        
        cell.descrizione.text! = "\(codc): \(assenze[indexPath.row].descrizione)"
        
        if assenze[indexPath.row].isJustified{
            cell.giustIMG.image = UIImage(named: "verified")
        }else{
            cell.giustIMG.image = UIImage(named: "multiply")
        }
        
        return cell
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
                    //self.setUpAgenda()
                }
                
                
            } else {
                //self.setUpAgenda()
                print(error)
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
        
        let url2 = URL(string: "https://web.spaggiari.eu/rest/v1/students/\(idinurl)/absences/details/")!
        
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
                    
                    let evtId = json["events"].arrayValue.map({$0["evtId"].doubleValue})
                    let evtCode = json["events"].arrayValue.map({$0["evtCode"].stringValue})
                    let evtDate = json["events"].arrayValue.map({$0["evtDate"].stringValue})
                    let ora = json["events"].arrayValue.map({$0["evtHPos"].stringValue})
                    let isJustified = json["events"].arrayValue.map({$0["isJustified"].boolValue})
                    //evtValue mai usato
                    let reasonCode = json["events"].arrayValue.map({$0["justifReasonCode"].stringValue})
                    let reasonDesc = json["events"].arrayValue.map({$0["justifReasonDesc"].stringValue})
                    
                    var f = 0
                    
                    self.assNonGiust = 0
                    self.ritNonGiust = 0
                    self.uscNonGiust = 0
                    
                    for _ in evtId{
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let date = dateFormatter.date(from:evtDate[f])!
                        
                        let newAS = assenza(id: evtId[f], code: evtCode[f], date: date, ora: ora[f], isJustified: isJustified[f], codiceGius: reasonCode[f], descrizione: reasonDesc[f])
                        
                        if evtCode[f] == "ABA0"{
                            self.assenzeassenze.append(newAS)
                            if isJustified[f] == false{
                                self.assNonGiust += 1
                            }
                        }
                        if evtCode[f] == "ABR0" || evtCode[f] == "ABR1"{
                            self.ritardi.append(newAS)
                            if isJustified[f] == false{
                                self.ritNonGiust += 1
                            }
                        }
                        if evtCode[f] == "ABU0"{
                            self.uscite.append(newAS)
                            if isJustified[f] == false{
                                self.uscNonGiust += 1
                            }
                        }
                        
                        self.assenze.append(newAS)
                        
                        //aggiungi dati
                        f += 1
                    }
                    
                    self.assenze = self.assenze.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                    //print(self.assenze)
                    
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
    
    struct assenza{
        var id : Double
        var code : String
        var date : Date
        var ora : String
        var isJustified : Bool
        var codiceGius : String
        var descrizione : String
    }
    
    var assenze : [assenza] = []
    var assenzeassenze : [assenza] = []
    var ritardi : [assenza] = []
    var uscite : [assenza] = []
    
    var assNonGiust = 0
    var ritNonGiust = 0
    var uscNonGiust = 0
}

