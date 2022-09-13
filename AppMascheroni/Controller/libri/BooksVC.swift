//
//  BooksVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 06/08/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import Firebase
import JGProgressHUD

class tableViCe : UICollectionViewCell{
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}

class tabCellDown : UITableViewCell{
    
    @IBOutlet weak var toBuyToAdopt: UILabel!
    @IBOutlet weak var annoPublisher: UILabel!
    @IBOutlet weak var autore: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var titleLAbel: UITextView!
    
}

class BooksVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableVi: UITableView!
    @IBOutlet weak var cooleVi: UICollectionView!
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var grayAct: UIActivityIndicatorView!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var expButt: UIButton!
    
    var clssi : [String] = []
    var hrefs : [String] = []
    
    var searchActive = false
    
    var materia : [String] = []; var titolo : [String] = []; var BookLink : [String] = [];var autore : [String] = []; var anno : [String] = [];var publisher : [String] = [];var code : [String] = []; var toBuy: [String] = [];var toAdopt : [String] = [];var prezzo : [String] = [];var imgRef : [String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        tableVi.delegate = self
        tableVi.dataSource = self
        
        tableVi.estimatedRowHeight = 100
        tableVi.rowHeight = UITableViewAutomaticDimension
        
        cooleVi.delegate = self
        cooleVi.dataSource = self
        
        cooleVi.isHidden = true;
        
        getHTMLClassi(parsin: "https://www.libraccio.it/scolastica/default.aspx?n=1&reg=Lombardia&prov=BG&citta=Bergamo&tipo=PS&scuola=BGPS05000B")
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clssi.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*var cell = collectionView.cellForItem(at: indexPath) as! tableViCe
        var black = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cell.view.layer.borderColor = black.cgColor
        
        cell.view.layer.borderWidth = 1.0*/
        
        classLabel.text! = clssi[indexPath.row]
        
        tableVi.isHidden = true
        grayAct.isHidden = false
        
        getHTMLLibri(parsin: "https://www.libraccio.it/\(hrefs[indexPath.row])");
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! tableViCe
        cell.label.text! = clssi[indexPath.row]
        
        cell.view.layer.cornerRadius = cell.view.frame.size.width/2
        cell.view.clipsToBounds = true
        
        return cell
    }
    
    func getClasses(){
        
    }
    
    func getHTMLClassi(parsin: String) -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        Alamofire.request(parsin).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                //print(html)
                
                self.parseHTMLforClassi(html: html)
            }
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
                cooleVi.isHidden = false
            };
            for show in doc.xpath("//*[contains(@class, 'tooltip')]/a/@href") {
                // print(show.text!)
                hrefs.append(show.text!)
                cooleVi.isHidden = false
            };
            
            cooleVi.reloadData()
            
        }catch{
            
        }
     
   }
    
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
            
            
            cooleVi.reloadData()
            tableVi.isHidden = false
            grayAct.isHidden = true
            tableVi.reloadData()
            tableVi.setContentOffset(.zero, animated:false)
        }catch{
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titolo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tb") as! tabCellDown
        
        cell.titleLAbel.text! = titolo[indexPath.row]
        if anno.indices.contains(indexPath.row) && publisher.indices.contains(indexPath.row){ cell.annoPublisher.text! = "\(anno[indexPath.row]), \(publisher[indexPath.row])"}else if  anno.indices.contains(indexPath.row){
            cell.annoPublisher.text! = "\(anno[indexPath.row]), N/D"}else{
            cell.annoPublisher.text! = "N/D"
        }
        
        cell.price.text! = prezzo[indexPath.row]
        if autore.indices.contains(indexPath.row){
            cell.autore.text! = autore[indexPath.row]}else{
            cell.autore.text! = "autore non disponibile"
        }
        if toBuy.indices.contains(indexPath.row) && toBuy.indices.contains(indexPath.row){
            cell.toBuyToAdopt.text! = "\(toBuy[indexPath.row]), \(toAdopt[indexPath.row])"}else{
            cell.toBuyToAdopt.text! = "Consigliato"
        }
        
        //loadImg(link: imgRef[indexPath.row], imgView: cell.imgView)
        
        cell.imgView.imageFromServerURL(urlString: "https:\(imgRef[indexPath.row])")
        
        return cell;
    }
   
    var yInit : CGFloat = 0
    var f = false
    var heightD : CGFloat = 0
    
    
    @IBAction func exp(_ sender: Any) {
        
        if f == false{
            yInit = tableVi.frame.origin.y
            print("y init: \(yInit)")
            heightD = tableVi.frame.height
        }
        
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        UIView.animate(withDuration: 0.6, animations: {
            if self.f == false{
            self.f = true
            self.tableVi.frame = CGRect(x: 0,y: 0, width: width, height: height)
                self.expButt.setTitle("riduci", for: .normal)
            }else{
                self.tableVi.frame = CGRect(x: 0,y: self.yInit, width: width, height: self.heightD)
                self.yInit = 0
                self.f = false
                self.expButt.setTitle("espandi", for: .normal)
            }
        })
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search.endEditing(true)
        searchActive = false;
        tableVi.isHidden = true
        grayAct.isHidden = false
        var txtTUse = search.text!.lowercased().replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        txtTUse = txtTUse.replacingOccurrences(of: "'", with: "%20", options: .literal, range: nil)
            
        getHTMLLibri(parsin: "https://www.libraccio.it/src/?xy=\(search.text!.lowercased().replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))");
        classLabel.text! = "\"\(search.text!)\""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //send book link to firebase
        let alert = UIAlertController(title: "Metti in vendita", message: "Vuoi mettere in vendita il libro? Gli altri studenti potranno contattarti per l'acquisto e per concordare il prezzo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
        }));
        alert.addAction(UIAlertAction(title: "Metti in vendita", style: .default, handler: { action in
            //self.newChat(idDestinatario: idDestinatario, indexPath: indexPath)
            self.addBookToDatabase(index: indexPath.row)
        }));
        
        self.present(alert, animated: true, completion: nil)
    }
    
     let hud = JGProgressHUD(style: .dark)
    
    func addBookToDatabase(index: Int){
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
        let uuidA = UUID().uuidString
        
        let data: Dictionary<String, Any> = ["linkLibro": "https://www.libraccio.it\(BookLink[index])", "titolo": titolo[index], "vendutoDaId": userID, "mailVenditore": mailUser,"nomeVenditore": nomeUser, "idLibro": uuidA];
        
        ref.child("libri").child(uuidA).updateChildValues(data)
        
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        
        hud?.textLabel.text = "Libro messo in vendita con successo"
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 1.3, animated: true)
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                self.navigationController?.popViewController(animated: true)
                wasAdded = true
            }
        }
    }
    
}
