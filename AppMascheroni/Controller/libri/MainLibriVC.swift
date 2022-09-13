//
//  MainLibriVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 15/08/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import Kanna
import Alamofire
import SkeletonView

class cellForBook: UITableViewCell{
    @IBOutlet weak var nomeVenditore: UILabel!
    @IBOutlet weak var mailVenditore: UILabel!
    @IBOutlet weak var prezzo: UILabel!
    @IBOutlet weak var imgBc: UIImageView!
    @IBOutlet weak var casaEditrice: UILabel!
    @IBOutlet weak var Autore: UILabel!
    @IBOutlet weak var titolo: UITextView!
    @IBOutlet weak var txt3: UITextView!
    
    @IBOutlet weak var m1: UITextView!
    
    @IBOutlet weak var manyMore: UILabel!
    
    @IBOutlet weak var noUsersView: UIView!
    
    @IBOutlet weak var carViw: UIView!
    
    @IBOutlet weak var m4: UIImageView!
    
    @IBOutlet weak var m3: UIImageView!
    
    override func awakeFromNib() {
        m1.showAnimatedSkeleton()
        txt3.showAnimatedSkeleton()
        m3.showAnimatedSkeleton()
        m4.showAnimatedSkeleton()
    }
}



class MainLibriVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableViewM: UITableView!
    
    @IBOutlet weak var modify: UIView!
    
    var searchActive = false
    
    @IBOutlet weak var classeee: UILabel!
    
    struct libro{
        var titoloLibro: String;
        var idLibro: String
        var linkLibro: String
        var nomeVenditore: String
        var idVenditore: String
        var mailVenditore: String
        var isMe : Bool
    }
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var libri : [libro] = []
    
    var filtered : [libro] = []
    
    var clssi : [String] = []
    var hrefs : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBooks()
        bcgrImg()
        
        searchBar.delegate = self
        
        tableViewM.estimatedRowHeight = 207
        tableViewM.rowHeight = UITableViewAutomaticDimension
 
        collView.delegate = self
        collView.dataSource = self
        
        collView.isHidden = true
        
        tableViewM.delegate = self
        tableViewM.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true{
            return actBooks.count
        }
        if titolo.count == 0{
            return 5
        }else{
            
            return titolo.count
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bcl", for: indexPath) as! cellForBook
        if searchActive == false{
        if titolo.count == 0{
            cell.carViw.isHidden = false
            cell.titolo.text! = ""
        }else{
        cell.carViw.isHidden = true
        cell.titolo.text! = titolo[indexPath.row]
        if anno.indices.contains(indexPath.row) && publisher.indices.contains(indexPath.row){ cell.casaEditrice.text! = "\(anno[indexPath.row]), \(publisher[indexPath.row])"}else if  anno.indices.contains(indexPath.row){
            cell.casaEditrice.text! = "\(anno[indexPath.row]), N/D"}else{
            cell.casaEditrice.text! = "N/D"
        }
        
        cell.prezzo.text! = prezzo[indexPath.row]
        
        if autore.indices.contains(indexPath.row){
            cell.Autore.text! = autore[indexPath.row]}else{
            cell.Autore.text! = "autore non disponibile"
        }
        if toBuy.indices.contains(indexPath.row) && toBuy.indices.contains(indexPath.row){
            cell.Autore.text! = "\(toBuy[indexPath.row]), \(toAdopt[indexPath.row])"}else{
            cell.Autore.text! = "Consigliato"
        }
        cell.imgBc.imageFromServerURL(urlString: "https:\(imgRef[indexPath.row])")
        cell.noUsersView.isHidden = false
        //cell.nomeVenditore.text! = libri[indexPath.row].nomeVenditore
        //cell.mailVenditore.text! = libri[indexPath.row].mailVenditore
        var iuy = false
        
        var m = 0;
        
        while(m == 0){
            if self.libri.count != 0{
                var howMany = 0
                m = 3
            for a in self.libri{
                if a.titoloLibro == self.titolo[indexPath.row]{
                    iuy = true
                    howMany += 1
                    cell.nomeVenditore.text! = a.nomeVenditore
                    cell.mailVenditore.text! = a.mailVenditore
                    cell.noUsersView.isHidden = true
                }
              }
                if howMany == 2{
                    cell.manyMore.text! = "+ 1 altro venditore"}else if howMany > 2{
                     cell.manyMore.text! = "+ altri \(howMany) venditori"
                }else{
                    cell.manyMore.text! = ""
                }
                if howMany == 0{
                    cell.nomeVenditore.text! = ""
                    cell.mailVenditore.text! = ""
                }
            }
            
        }
            
        /*if iuy == false{
            cell.nomeVenditore.text! = "Nessun venditore"
        }*/
            
        }
        }else{
            //sta cercando qualcosa
            print(indexPath.row)
            cell.carViw.isHidden = true
            cell.titolo.text! = filtered[indexPath.row].titoloLibro
            cell.Autore.text! =  actBooks[indexPath.row].Autori.description.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "")
            if actBooks[indexPath.row].Autori.count == 0{
                cell.Autore.text! = "Autore non disponibile"
            }
            cell.casaEditrice.text! = actBooks[indexPath.row].Editore
            cell.prezzo.text! = actBooks[indexPath.row].Prezzo
            cell.noUsersView.isHidden = true
            cell.nomeVenditore.text! = filtered[indexPath.row].nomeVenditore
            cell.mailVenditore.text! = filtered[indexPath.row].mailVenditore
            cell.imgBc.imageFromServerURL(urlString: "https:\(actBooks[indexPath.row].imgHtml)")
            //print("https:\(actBooks[indexPath.row].imgHtml)")
        }
        
        return cell
    }
    
    func getBooks(){
        
        libri.removeAll()
        
        let ref = FIRDatabase.database().reference()
        let id = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("libri").observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
                //self.caricamento.isHidden = true
            } else{
                for child in (snapshot.children){
                    
                    let snap = child as! FIRDataSnapshot //each child is a snapshot
                    
                    let dizionario = snap.value as! [String: AnyObject] // the value is a dict
                    let idLibro = dizionario["idLibro"] as! String
                    let linkLibro = dizionario["linkLibro"] as! String
                    let mailVend = dizionario["mailVenditore"] as! String
                    let nomeVend = dizionario["nomeVenditore"] as! String
                    let idVend = dizionario["vendutoDaId"] as! String
                    let titolo = dizionario["titolo"] as! String
                    
                    //let todos = "\(NomeLibro)\(Materia)\(Autore)"
                    var isME = false
                    if idVend == id!{
                        isME = true
                    }
                    
                    var libros = libro(titoloLibro: titolo, idLibro: idLibro, linkLibro: linkLibro, nomeVenditore: nomeVend, idVenditore: idVend, mailVenditore: mailVend, isMe: isME)
                    
                    
                    self.libri.append(libros)
                }
                //self.caricamento.isHidden = true
                self.getHTMLClassi(parsin: "https://www.libraccio.it/scolastica/default.aspx?n=1&reg=Lombardia&prov=BG&citta=Bergamo&tipo=PS&scuola=BGPS05000B")
            }
        }
        
        //print("\n\n\n\(libri)\n\n\n")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clssi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! tableViCe
        
        cell.label.text! = clssi[indexPath.row]
        
        cell.view.layer.cornerRadius = cell.view.frame.size.width/2
        cell.view.clipsToBounds = true
        
        return cell
    }
    
    
    //----------html Handling
    
    
    func getHTMLClassi(parsin: String) -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        Alamofire.request(parsin).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //print(html)
                
                self.parseHTMLforClassi(html: html)
            }
        }
    }
    var currentClasse = ""
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //tableViewM.isHidden = true
        //grayAct.isHidden = false
        //libri.removeAll()
        //tableViewM.reloadData()
        searchActive = false
        getHTMLLibri(parsin: "https://www.libraccio.it/\(hrefs[indexPath.row])");
        currentClasse = clssi[indexPath.row]
        
        classeee.text! = "carico..."
    }
    
    func parseHTMLforClassi(html: String) -> Void {//filtrare codice html
        
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            var a = 0;
            var conf = ""
            var uy = false
            for show in doc.xpath("//*[contains(@class, 'tooltip')]/a") {
                //print(show.text!)
                if a == 0{
                    a += 1
                    conf = show.text!
                    clssi.append("\(show.text!)")
                }else{
                    if show.text! == conf{
                        uy = true
                    }
                    if uy == true{
                        clssi.append("\(show.text!)S")
                    }else{
                        clssi.append("\(show.text!)")
                    }
                }
                collView.isHidden = false
            };
            
            for show in doc.xpath("//*[contains(@class, 'tooltip')]/a/@href") {
                // print(show.text!)
                hrefs.append(show.text!)
                collView.isHidden = false
            };
            
            collView.reloadData()
            
        }catch{
            
        }
        
    }
    
    func getHTMLLibri(parsin: String) -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        Alamofire.request(parsin).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //print(html)
                self.parseHTMLforLibri(html: html)
            }
        }
    }
    
    var materia : [String] = []; var titolo : [String] = []; var BookLink : [String] = [];var autore : [String] = []; var anno : [String] = [];var publisher : [String] = [];var code : [String] = []; var toBuy: [String] = [];var toAdopt : [String] = [];var prezzo : [String] = [];var imgRef : [String] = [];
    
    
    func parseHTMLforLibri(html: String) -> Void {//filtrare codice html
        
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            
            materia.removeAll()
            titolo.removeAll()
            BookLink.removeAll()
            autore.removeAll()
            anno.removeAll()
            publisher.removeAll()
            code.removeAll()
            toBuy.removeAll()
            toAdopt.removeAll()
            imgRef.removeAll()
            prezzo.removeAll()
            
            for show in doc.xpath("//*[contains(@class, 'breakon')]") {//new
                //print(show.text!)
                materia.append(show.text!)
                
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'title')]/a") {
                //print(show.text!)
                titolo.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'title')]/a/@href") {//new
                //print(show.text!)
                BookLink.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr author')]//*[contains(@class, 'data')]//*[contains(@class, 'dx d0')]") {
                //print(show.text!)
                autore.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr year')]//*[contains(@class, 'dx d0')]") {
                //print(show.text!)
                anno.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr publisher')]//*[contains(@class, 'dx d0')]") {
                //print(show.text!)
                publisher.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr code')]/a") {
                //print(show.text!)
                code.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr schooltobuy')]//*[contains(@class, 'dx d0')]") {
                //print(show.text!)
                toBuy.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'attr schooladopt')]//*[contains(@class, 'dx d0')]") {
                //print(show.text!)
                toAdopt.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'image')]/a/img/@src") {//new
                //print(show.text!)
                imgRef.append(show.text!)
            };//
            
            for show in doc.xpath("//*[contains(@class, 'detail')]//*[contains(@class, 'sellpr')]") {
                //print(show.text!)
                prezzo.append(show.text!)
            };//
            
            
            collView.reloadData()
            tableViewM.isHidden = false
            //grayAct.isHidden = true
            classeee.text! = currentClasse
            tableViewM.reloadData()
            tableViewM.setContentOffset(.zero, animated:false)
        }catch{
            
        }
        
    }
    
    @IBAction func esc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: 0, section: 0)
            //self.tableViewM.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        filtered = libri.filter({ (text) -> Bool in
            let tmp: String = text.titoloLibro
            let range = tmp.range(of: searchBar.text!, options: NSString.CompareOptions.caseInsensitive)
            return range != nil
        })
        classeee.text! = "carico..."
        if(filtered.count == 0){
            searchActive = false;
            classeee.text! = "\"\(searchBar.text!)\" non ha prodotto risultati"
        } else {
            searchActive = true;
        }
        getFullActBooks()
        //self.tableViewM.reloadData()
        
    }
    
/*riassunto:
 la ricerca filtra i libri, prendo tutti i link dal filtered e filtro il loro html riempiendo l'array di ActBooks, dopo di che reload data con confronto titolo-venditori*/
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true
        //tableViewM.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // searchActive = true
    }
    
    func getHTMLForAct(parsin: String) -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        Alamofire.request(parsin).responseString { response in
            print("\n\n\(response.result.isSuccess)")
            if let html = response.result.value {
                //print(html)
                
                self.parseHTMLforMainAct(html: html)
            }
        }
    }
    
    struct actBook{
        var Title = ""
        var Autori : [String] = []
        var Editore = ""
        var Prezzo = ""
        var imgHtml = ""
    }
    
    var actBooks : [actBook] = []
    
    func getFullActBooks(){
        actBooks.removeAll()
        for a in filtered{
            getHTMLForAct(parsin: a.linkLibro)
        }
        print("\n\nthe count: \(actBooks.count)\n")
        //tableViewM.reloadData()
    }
    
    func parseHTMLforMainAct(html: String) -> Void {//filtrare codice html
        
        var actTitle = ""
        var actAutori : [String] = []
        var actEditore = ""
        var actPrezzo = ""
        var actImgHtml = ""
        
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            
            for show in doc.xpath("//*[contains(@class, 'detail')]/h1") {
                print(show.text!)
                actTitle = (show.text!)
            };
            
            for show in doc.xpath("//*[contains(@class, 'data')]/span/a") {
                print("\n\(show.text!)\n")
               actAutori.append(show.text!)
            };
            
            for show in doc.xpath("//*[contains(@class, 'currentprice')]") {
                print("\n\(show.text!)\n")
                actPrezzo = show.text!
            };
            
            for show in doc.xpath("//*[contains(@class, 'attr publisher')]//*[contains(@class, 'data')]") {
                print("\n\(show.text!)\n")
                actEditore = show.text!
            };
            
            for show in doc.xpath("//*[contains(@id, 'ctl00_ctl00_C_C_ProductDetail_zoom1')]/@href") {
                print("\n\(show.text!)\n")
                
                actImgHtml = show.text!
            };
            
            //collView.reloadData()
            let actBk = actBook(Title: actTitle, Autori: actAutori, Editore: actEditore, Prezzo: actPrezzo, imgHtml: actImgHtml)
            
            actBooks.append(actBk)
            if actBooks.count == filtered.count{
                tableViewM.reloadData()
                print("\n\n\n fin")
                classeee.text! = "Risultati relativi a: \"\(searchBar.text!)\""
            }
        }catch{
            
        }
        
    }
    
}
