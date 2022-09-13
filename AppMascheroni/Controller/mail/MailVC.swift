//
//  MailVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 11/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Postal
import MessageUI

var hasSaved = false

extension Date {
    
    func formatRelativeString() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.doesRelativeDateFormatting = true
        
        if calendar.isDateInToday(self) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else if calendar.isDateInYesterday(self){
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        } else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return dateFormatter.weekdaySymbols[weekday-1]
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }
        
        return dateFormatter.string(from: self)
    }
}

class MailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UITextFieldDelegate{
    
    //---access declare
    
    @IBOutlet weak var mailSeloop: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var pswTextF: UITextField!
    
    @IBAction func access(_ sender: Any) {
        pswTextF.resignFirstResponder()
        mailText.resignFirstResponder()
         postalConnect(load: 0, mail: mailText.text!, psw: pswTextF.text!)
        
    }
    //------------
    @IBOutlet weak var modifyImageView: UIView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var loadViewZ: UIView!
    @IBOutlet weak var tableView: UITableView!
    var messages: [FetchResult] = []
    var allMail = ""
    var allPsw = ""
     func logSetUp(){
        if MailxMail != ""{
            print(MailxMail)
            mailText.text! = MailxMail
        }
    }
    
    func checkDatabase(){
        let ret = CoreDataController.shared.checkPsw(mail: MailxMail)
        if ret == "noPsw"{
            hasSaved = false
            logSetUp()
            accessView.isHidden = false
        }else{
            accessView.isHidden = true
            hasSaved = true
            postalConnect(load: 0, mail: MailxMail, psw: ret)
        }
    }
    
    @IBOutlet weak var acces: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        acces.setTitle("Accedi", for: .normal)
        accessView.isHidden = true
        checkDatabase()
        mailText.delegate = self
        pswTextF.delegate = self
        addToolBar(textField: mailText)
        addToolBar(textField: pswTextF)
        
        loadViewZ.isHidden = false
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        bcgrImg()
        
    }
    
    func bcgrImg(){
        let myImageMod = UIImageView(frame: modifyImageView.bounds)
        myImageMod.image = #imageLiteral(resourceName: "pencil")
        myImageMod.contentMode = .scaleAspectFill
        
        myImageMod.clipsToBounds = true
        
        modifyImageView.clipsToBounds = false
        modifyImageView.layer.shadowColor = UIColor.lightGray.cgColor
        modifyImageView.layer.shadowOpacity = 1
        modifyImageView.layer.shadowOffset = CGSize.zero
        modifyImageView.layer.shadowRadius = 3
        modifyImageView.layer.shadowPath = UIBezierPath(roundedRect: modifyImageView.bounds, cornerRadius: myImageMod.frame.width/2).cgPath
        
        modifyImageView.addSubview(myImageMod)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch when pull for refreshData
        postalConnect(load: 0, mail: allMail, psw: allPsw)
    }
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postalConnect(load: Int, mail: String, psw: String){
        activityIndicator.isHidden = false
        acces.setTitle("", for: .normal)
        mailSeloop.text! = mail
        let postal = Postal(configuration: .gmail(login: mail, password: .plain(psw)))
        let loadr = load + 32
        postal.connect(timeout: Postal.defaultTimeout, completion: { [weak self] result in
            switch result {
            case .success: // Fetch 32 last mails of the INBOX
                self?.pswTextF.resignFirstResponder()
                self?.mailText.resignFirstResponder()
                self?.accessView.isHidden = true
                postal.fetchLast("INBOX", last: UInt(loadr), flags: [ .body ], onMessage: { message in
                    self?.messages.insert(message, at: 0)
                    
                }, onComplete: { error in
                    if let error = error {
                        self?.activityIndicator.isHidden = true
                        self?.acces.setTitle("Accedi", for: .normal)
                        self?.errorAlert(message: "È avvenuto un errore ner ricavare i dati, controlla di avere una buona connessione")
                        print("Fetch error, message: \((error as NSError).localizedDescription)")
                        
                        CoreDataController.shared.deleteMail()
                        self?.accessView.isHidden = false
                    } else {
                        self?.allMail = mail;
                        self?.allPsw = psw
                        if hasSaved == false{
                            //salvo nel database se non già stato fatto
                            CoreDataController.shared.deleteMail()
                              self?.activityIndicator.isHidden = true
                            self?.acces.setTitle("Accedi", for: .normal); CoreDataController.shared.newPassword(psw: (self?.pswTextF.text!)!, email: (self?.mailText.text!)!)
                        }
                            self?.tableView.reloadData();self?.loadViewZ.isHidden = true
                        
                        self?.refreshControl.endRefreshing()
                        //self?.postalConnect(load: loadr)
                    }
                })
                
            case .failure(let error):
                print("Connection error: \((error as NSError).localizedDescription)")
                CoreDataController.shared.deleteMail()
                var l = ((error as NSError).localizedDescription);
                if l == "Impossibile completare l'operazione. (Postal.PostalError errore 0)."{
                    self?.activityIndicator.isHidden = true
                    self?.acces.setTitle("Accedi", for: .normal)
                    self?.errorAlert(message: "Dopo esserti assicurato di aver inserito la corretta password controlla nelle mail che l'accesso non sia stato bloccato, in caso affermativo consenti l'accesso.")
                    self?.accessView.isHidden = false
                }else{
                    self?.activityIndicator.isHidden = true
                    self?.acces.setTitle("Accedi", for: .normal)
                    self?.errorAlert(message: "È avvenuto un errore durante l'accesso, controlla di aver inserito i giusti dati")
                    self?.accessView.isHidden = false
                }
            }
        })
    }
    
    func errorAlert(message: String){
        let alert = UIAlertController(title: "Errore", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        
        
        /*let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }*/
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("mailCell", owner: self, options: nil)?.first as! mailCell
        cell.oggetto.text! = (messages[indexPath.row].header?.subject)!
        let titleTxt = String(describing: (messages[indexPath.row].header?.from.flatMap({ (Address) -> String? in
            Address.displayName
        }))!)
        let repTxt = titleTxt.replacingOccurrences(of: "[", with: "")
        let repAg = repTxt.replacingOccurrences(of: "]", with: "")
        let repDQ = repAg.replacingOccurrences(of: "\"", with: "")
        cell.title.text! = repDQ
        
        cell.date.text! = (messages[indexPath.row].header?.receivedDate?.formatRelativeString())!
        
        return cell
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([""])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func writeMail(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }
    
    //-----text----------
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Fine", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        mailText.resignFirstResponder()
        pswTextF.resignFirstResponder()
    }
}
