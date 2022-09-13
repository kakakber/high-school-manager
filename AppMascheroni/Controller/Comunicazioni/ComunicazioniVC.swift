//
//  ComunicazioniVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 28/01/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import SafariServices



class comunicazione{//classe per definire una comunicazione
    var titolo: String = ""
    var data: String = "Data"
    var link: String = ""
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}

class ComunicazioniVC: UIViewController, UITableViewDataSource, UITableViewDelegate, visualizzaProtocol, SFSafariViewControllerDelegate{
    
    var comunicazioni: [comunicazione] = []//array di comunicazioni
    
    var titoli: [String] = []
    var date: [String] = []
    var links: [String] = []
    
    @IBOutlet weak var caricamView: UIView!
    
    @IBOutlet var metalShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalShowTableView.delegate = self
        metalShowTableView.dataSource = self
        caricamView.isHidden = false
        self.getHTML()
        metalShowTableView.estimatedRowHeight = 105
    }
    
    
    
    @IBOutlet weak var esci: UIBarButtonItem!
    
    @IBAction func esci(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getHTML() -> Void {//funzione che inserisce il codice html della pagina web in una variabile che verrà poi filtrato
        Alamofire.request("https://www.liceomascheroni.gov.it/category/news/").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    @IBAction func fine(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func parseHTML(html: String) -> Void {//filtrare codice html
        do {let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //ricerca di determinati tag
            
            for show in doc.xpath("//div[@class='post-box-archive']/h4/a") {
                //prendo i titoli delle com.
                titoli.append(show.text!)
            }
            for show in doc.xpath("//div[@class='post-box-archive']/span[@class='hdate']") {
                //prendo le date delle com.
                date.append(show.text!)
            }
            
            for show in doc.xpath("//div[@class='post-box-archive']/a/@href") {
                //prendo i link delle com.
                links.append(show.text!)
            }
        }catch{
            print("error in parsing")
        }
        
        var it = 0
        caricamView.isHidden = true
        for x in titoli{
            let comunicaziones : comunicazione = comunicazione()
            comunicaziones.titolo = x
            comunicaziones.data = date[it]
            comunicaziones.link = links[it]
            
            comunicazioni.append(comunicaziones)
            it += 1
            
        }
        
        print(comunicazioni)
        
        metalShowTableView.reloadData()
    }
    
    func checkSize(descrizione: UITextView){//text view transform
        if descrizione.contentSize.height > descrizione.frame.size.height {
            
            let fixedWidth = descrizione.frame.size.width
            descrizione.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            var newFrame = descrizione.frame
            let newSize = descrizione.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            
            descrizione.frame = newFrame;
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = comunicazioni[indexPath.row].titolo.height(withConstrainedWidth: self.view.frame.width-96, font: UIFont.systemFont(ofSize: 27, weight: .heavy))
        
        //return CGFloat(height+66)
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comunicazioni.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func visualizza(at index: IndexPath) {
        isItOrario = false
        //performSegue(withIdentifier: "toWeb", sender: nil)
        urlSel = comunicazioni[index.row].link
        let urlString = comunicazioni[index.row].link
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ComunicazioneTableVCell", owner: self, options: nil)?.first as! ComunicazioneTableVCell
        
        cell.titolo.text! = comunicazioni[indexPath.row].titolo.uppercased()
        cell.data.text! = comunicazioni[indexPath.row].data
        //checkSize(descrizione: cell.descrizione)
        
       
        cell.titolo.numberOfLines = 0
        cell.titolo.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.titolo.sizeToFit()
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    
}


