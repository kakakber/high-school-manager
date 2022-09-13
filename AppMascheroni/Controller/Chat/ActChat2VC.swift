//
//  ActChat2VC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 29/04/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import JSQMessagesViewController
import ALTextInputBar

struct messaggio{
    var inviatoDa: String
    var inviatoDaId: String
    var testo: String
    var data: NSAttributedString
}

class ActChat2VC: UITableViewController{
    
    @IBOutlet weak var progressView: UIProgressView!
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()
    
    var messaggi: [messaggio] = []
    
    override var inputAccessoryView: UIView? {
        get {
            configureInputBar()
            return textInputBar
        }
    }
    
    // Another ingredient in the magic sauce
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    func configureInputBar() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        rightButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        
        rightButton.addTarget(self, action: #selector(donePressed), for: UIControlEvents.touchUpInside)
        
        textInputBar.showTextViewBorder = true
        textInputBar.rightView = rightButton
        
        
        textInputBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                self.slideDown()
            }
            
            print("keyboardShowed")
        }
    }
    
    
    @objc func donePressed(){
        progressView.isHidden = false
        
        inviaMessaggio(text: textInputBar.text!, ora: Date())
        textInputBar.text! = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        progressView.isHidden = true
        
        tableView.estimatedRowHeight = 43
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.titleView = setTitle(title: MessaggioVerso, subtitle: ClasseStudChat)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        osservaMessaggio()
        // Do any additional setup after loading the view.
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return messaggi.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")! as! ActChat2Cell
        
        cell.utente.text! = messaggi[indexPath.row].inviatoDa
        cell.messaggio.text! = messaggi[indexPath.row].testo
        cell.ora.text! = messaggi[indexPath.row].data.string
        if messaggi[indexPath.row].inviatoDa == "Io"{
            
            cell.contentView.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.99, alpha:1.0)}else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
    }

    func osservaMessaggio(){
      var uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).child("messaggi").observe(.childAdded) { (Snapshot) in
            
            
            if let data = Snapshot.value as? NSDictionary{
                
                if let senderId = data["from"] as? String {
                        if let testo = data["testo"] as? String {
                            if let  oraData = data["dataOra"]{
                                print(oraData)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                let date = dateFormatter.date(from: oraData as! String)
                                var nameA = ""
                                if senderId == uid{
                                    nameA = "Io"
                                }else{
                                   nameA = MessaggioVerso
                                }
                                var dats = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: date)
                                
                                var messaggioNew = messaggio(inviatoDa: nameA, inviatoDaId: senderId, testo: testo, data: dats!)
                                
                                self.messaggi.append(messaggioNew)
                                
        
                               
                            }
                        }
                }
                
            }
            
            self.tableView.reloadData()
            if self.messaggi.count > 0{
                let indexPath = NSIndexPath(item: self.messaggi.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)}
        }
    }
    
    func slideDown(){
        if self.messaggi.count > 0{
            let indexPath = NSIndexPath(item: self.messaggi.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)}
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y:18, width:0, height:0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        //        let imageView = UIImageView(frame: CGRect(x: 196, y: -3, width: 36, height: 36))
        //        imageView.contentMode = .scaleAspectFit
        //        let image = #imageLiteral(resourceName: "profile pic")
        //        imageView.image = image
        
        
        let progressViewz = UIProgressView(frame: CGRect(x: 0, y: 12, width: 70, height: 0))
        
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    
    func inviaMessaggio(text: String, ora : Date){
        
        let id = FIRAuth.auth()?.currentUser?.uid
        
        let today = Date()
        
        let drateFormatter = DateFormatter()
        drateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = drateFormatter.string(from: today)
        
        let drateFormatterB = DateFormatter()
        drateFormatterB.dateFormat = "HH:mm"
        let ultOr = drateFormatterB.string(from: today)
        
        
        let nuovoMessaggioInfo : Dictionary<String, Any> = ["testo" : text, "from" : id!, "verso" : MessaggioVersoId, "dataOra" : currentDate];
        
        let UltimaChatRin : Dictionary<String, Any> = ["ultimo_Messaggio" : text];
        let UltimaChatOra : Dictionary<String, Any> = ["ultima_Ora" : ultOr];
        
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).child("messaggi").childByAutoId().updateChildValues(nuovoMessaggioInfo)
        
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).updateChildValues(UltimaChatOra)
        
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).updateChildValues(UltimaChatRin)
        
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).child("messaggi").observe(.childAdded, with: { (Snapshot) in
            print("inChildAdded")
            if let data = Snapshot.value as? NSDictionary{
                print("yes1")
                //controllare se il messaggio è stato effettivamente inviato
                if let textu = data["testo"] as? String {
                    
                    if textu == text {
                        print("yes2")
                        self.progressView.setProgress(1.0, animated: true)
                        if self.messaggi.count > 0{
                            let indexPath = NSIndexPath(item: self.messaggi.count-1, section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)}
                        
                            Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false, block: { (timer) in
                                self.progressView.isHidden = true
                                self.progressView.setProgress(0.0, animated: false)
                            })
                        
                    }
                }
            }
        })
        
        
    }

}
