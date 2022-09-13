//
//  OrarioVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 06/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import Firebase
import SafariServices

struct Orario{
    var link: String
    var nome: String
}

fileprivate let linkGen = "https://www.liceomascheroni.it/wp-content/uploads/2019/09/Orario_2019-20_quarta%20settimana/"

class OrarioVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SFSafariViewControllerDelegate{
    @IBOutlet weak var toolBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    var webReferences : [String] = []
    var allTheLinks : [String] = []
    var orariNames : [String] = []
    
    var CompletoOrari: [Orario] = []
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

     var searchActive : Bool = false
     var filtered:[Orario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.isHidden = true
           searchView.frame = CGRect(x: self.view.frame.width, y: 101, width: searchView.frame.width, height: 56)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getHTML(forProf: false)
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        if FIRAuth.auth()?.currentUser == nil{
            toolBarButton.title! = ""
        }else{
        toolBarButton.title! = "Mi connetto..."
        let timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { (Timer) in
            if ClasseDellUtente != ""{
                //se l'utente ha fatto l'accesso
                self.toolBarButton.title! = "La mia classe (\(ClasseDellUtente))"
                Timer.invalidate()
            }
        }
        
       timer.fire()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.endEditing(true)
        self.searchBar.text! = ""
        searchActive = false
        searchAnim(inEntrata: false)
        tableView.reloadData()
    }
    
    func getHTML(forProf: Bool) -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        //https://www.liceomascheroni.gov.it/wp-content/uploads/2017/10/Orario%202017_2018_definitivo_ricevimento/index.html
        
        Alamofire.request(linkGen).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //print(html)
                if forProf{
                    self.parseHTMLforProfessors(html: html)
                }else{
                    self.parseHTML(html: html)
                    
                }
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func parseHTML(html: String) -> Void {//filtrare codice html
        filtered.removeAll()
        CompletoOrari.removeAll()
        webReferences.removeAll()
        allTheLinks.removeAll()
        orariNames.removeAll()
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            for show in doc.xpath("//td[@align='center']/a/@href") {
                //prendo i titoli delle com.
                webReferences.append(show.text!)
            };
            
            for x in webReferences{
                //aggiungo tutti i finali di link alla base invariabile
                allTheLinks.append(newLink(ending: x))
            }
            
            for show in doc.xpath("//td[@align='center']/a"){
                orariNames.append(show.text!)
            }
            
        }catch{
            
     }
        var cnt = 0;
        for c in allTheLinks{
            //inserisco elementi in array di struct orario
            let newOr : Orario = Orario(link: c, nome: orariNames[cnt])
            CompletoOrari.append(newOr)
            cnt += 1
        }
        tableView.reloadData()
  }
    
    
    func parseHTMLforProfessors(html: String) -> Void {//filtrare codice html
        filtered.removeAll()
        CompletoOrari.removeAll()
        webReferences.removeAll()
        allTheLinks.removeAll()
        orariNames.removeAll()
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            for sh in doc.xpath("//td[@class='style1']/a/@href") {
                //prendo i titoli delle com.
                webReferences.append(sh.text!)
            }
            for show in doc.xpath("//td[@width='25%']/a/@href") {
                //prendo i titoli delle com.
                webReferences.append(show.text!)
            };
            
            for x in webReferences{
                //aggiungo tutti i finali di link alla base invariabile
                allTheLinks.append(newLink(ending: x))
            }
            
            for sh in doc.xpath("//td[@class='style1']/a"){
                orariNames.append(sh.text!)
            }
            
            for show in doc.xpath("//td[@width='25%']/a"){
                orariNames.append(show.text!)
            }
            
        }catch{
            
        }
        var cnt = 0;
        for c in allTheLinks{
            //inserisco elementi in array di struct orario
            let newOr : Orario = Orario(link: c, nome: orariNames[cnt])
            CompletoOrari.append(newOr)
            cnt += 1
        }
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return allTheLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellz = Bundle.main.loadNibNamed("Classi-TableViewCell", owner: self, options: nil)?.first as! Classi_TableViewCell;
        if(searchActive){
            cellz.mainLabel.text! = filtered[indexPath.row].nome
            print("classe \(filtered[indexPath.row].nome), link = \(filtered[indexPath.row].link)")
        }else{
            cellz.mainLabel.text! = orariNames[indexPath.row]
        }
        cellz.infosLabel.text! = "Premi per visualizzare l'orario"
        cellz.selectionStyle = .none
        
        return cellz
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            urlSel = filtered[indexPath.row].link
        }else{
            urlSel = CompletoOrari[indexPath.row].link
        }
        self.searchBar.endEditing(true)
        isItOrario = true
        //performSegue(withIdentifier: "toWebFromOrari", sender: nil)
        let urlString = urlSel
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //dismiss(animated: true)
    }
    
    func newLink(ending: String) -> String{
        let firstPart = linkGen
        let newLink = firstPart+ending
        
        return newLink
    }
    //dismiss Keyboard -----------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    //---------------------------
    
    @IBAction func myClassAct(_ sender: Any) {
        var rowMyClass = 0
        if ClasseDellUtente != ""{
            var sl = 0
            for x in orariNames{
                if x == ClasseDellUtente{
                    rowMyClass = sl
                }
                sl += 1
            }
            urlSel = allTheLinks[rowMyClass]
            isItOrario = true
            //performSegue(withIdentifier: "toWebFromOrari", sender: nil)
            let urlString = urlSel
            
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                vc.delegate = self
                
                present(vc, animated: true)
            }
        }
    }
    
    @IBOutlet weak var professButtOut: UIBarButtonItem!
    @IBAction func getProfessori(_ sender: Any) {
        if professButtOut.title! == "Professori"{
            getHTML(forProf: true)
            toolBarButton.title! = ""
            professButtOut.title! = "Classi"
        }else{
            getHTML(forProf: false)
            professButtOut.title! = "Professori"
            if FIRAuth.auth()?.currentUser == nil{
                toolBarButton.title! = ""
            }else{
                toolBarButton.title! = "La mia classe (\(ClasseDellUtente))"}
        }
    }  
    
    /*------------code per searchView-----------------*/
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    @IBAction func annullaActionSearch(_ sender: Any) {
        self.searchBar.endEditing(true)
        self.searchBar.text! = ""
        searchActive = false
        searchAnim(inEntrata: false)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         self.searchBar.endEditing(true)
        searchActive = false;
    }
    
    func searchAnim(inEntrata: Bool){
        if inEntrata{
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.searchView.frame = CGRect(x: 0, y: 101, width: self.searchView.frame.width, height: self.searchView.frame.height)
        },completion: { finish in
        })}else{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                //Frame Option 1:
                self.searchView.frame = CGRect(x: self.view.frame.width, y: 101, width: self.searchView.frame.width, height: self.searchView.frame.height)
            },completion: { finish in
            })
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        filtered = CompletoOrari.filter({ (text) -> Bool in
            let tmp: String = text.nome
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
    @IBAction func searchButtAction(_ sender: Any) {
        
        searchView.isHidden = false
        searchAnim(inEntrata: true)
        searchActive = false
    }
    
}
