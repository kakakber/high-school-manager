//
//  RealChatVCViewController.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 14/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import Firebase




class RealChatVCViewController: JSQMessagesViewController {

    private var messaggi = [JSQMessage]()
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressView)
        progressView.isHidden = true
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
//        let image = #imageLiteral(resourceName: "chat back 1")
//        let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
//        imgBackground.image = image
//        imgBackground.contentMode = UIViewContentMode.scaleAspectFill
//        imgBackground.clipsToBounds = true
//        self.collectionView?.backgroundView = imgBackground
        
        self.navigationItem.titleView = setTitle(title: MessaggioVerso, subtitle: ClasseStudChat)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
       let size = CGSize(width: 30, height: 30)
        collectionView?.collectionViewLayout.incomingAvatarViewSize = size
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
       self.inputToolbar.contentView.leftBarButtonItem = nil
        osservaMessaggio()
        
        let iddd = FIRAuth.auth()?.currentUser?.uid
        self.senderId = iddd
        self.senderDisplayName = iddd
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let dateMes = messaggi[indexPath.row].date
        let currentDate = Date()
        
        if indexPath.row == 0{
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: dateMes)
        }else if indexPath.row > 0{
            print("timeinter since \(dateMes?.timeIntervalSince(messaggi[indexPath.row - 1 ].date))")
        if messaggi[indexPath.row].date.timeIntervalSince(messaggi[indexPath.row - 1 ].date) > 900{
           return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: dateMes)
          
        }else{
            return nil
        }
      }
       return nil
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messaggi[indexPath.item]
        let idMex = message.senderId
        if idMex != FIRAuth.auth()?.currentUser?.uid{
        let cell = JSQMessagesCellTextView()
            
            cell.textInputView.tintColor = UIColor.black
            
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
            
        }else{
            
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        }
        
    }
    
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//        var dateForm = DateFormatter()
//        dateForm.dateFormat = "HH:mm"
//
//        var retDate = dateForm.string(from: messaggi[indexPath.row].date)
//
//        return NSAttributedString(string: retDate)
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
//
//        return 14
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        // messages to show
        let msg = messaggi[indexPath.row]
        
        if !msg.isMediaMessage {
            if msg.senderId! == senderId {
                cell.textView.textColor = UIColor.white
                
            }else{
                cell.textView.textColor = UIColor.black
//                cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0, 45.0, 0.0, 0.0)
                
            }
            cell.textView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: cell.textView.textColor ?? UIColor.white]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let image = #imageLiteral(resourceName: "profile pic")
       
        var avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 20)
        
        return avatarImage
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
            
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false, block: { (timer) in
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0.0, animated: false)
                })
            } else {
                self.progressView.isHidden = true
                self.progressView.setProgress(0.0, animated: false)
                // Fallback on earlier versions
            }
                }
                }
            }
        })
        
        
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let dateMes = messaggi[indexPath.row].date
        let currentDate = Date()
        
        if indexPath.row == 0{
            return 35.0
        }else if indexPath.row > 0{
            print("timeinter since \(dateMes?.timeIntervalSince(messaggi[indexPath.row - 1 ].date))")
            if messaggi[indexPath.row].date.timeIntervalSince(messaggi[indexPath.row - 1 ].date) > 900{
                return 35.0
                
            }else{
                return 3.0
            }
        }
        return 3.0
    }
    
    
    func osservaMessaggio(){
        FIRDatabase.database().reference().child("messaggi").child(MessaggioId).child("messaggi").observe(.childAdded) { (Snapshot) in
            
            
            if let data = Snapshot.value as? NSDictionary{
                
                if let senderId = data["from"] as? String {
                    if let senderName = data["from"] as? String {
                        if let testo = data["testo"] as? String {
                            
                            if let  oraData = data["dataOra"]{
                                print(oraData)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                let date = dateFormatter.date(from: oraData as! String)
                                
                             self.messaggi.append(JSQMessage(senderId: senderId, senderDisplayName: senderName, date: date, text: testo))
                            self.collectionView.reloadData()
                            }
                        }
                    }
                }
                
            }
            
        }
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
    
 
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messaggi[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messaggi.count
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        progressView.isHidden = false
        progressView.setProgress(0.3, animated: true)
        
        print("sent")
        inviaMessaggio(text: text, ora: date)
        
        collectionView.reloadData()
        finishSendingMessage()
        
    }
    
    
}
