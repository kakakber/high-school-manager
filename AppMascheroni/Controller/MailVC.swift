//
//  MailVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 11/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Postal

class MailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let postal = Postal(configuration: .gmail(login: "enrico.alberti@studenti.liceomascheroni.it", password: .plain("Enrico2001")))
        var messages: [FetchResult] = []
        postal.connect(timeout: Postal.defaultTimeout, completion: { [weak self] result in
            switch result {
            case .success: // Fetch 50 last mails of the INBOX
                
                postal.fetchLast("INBOX", last: 50, flags: [ .body ], onMessage: { message in
                    messages.insert(message, at: 0)
                    
                }, onComplete: { error in
                    if let error = error {
                        print("Fetch error, message: \((error as NSError).localizedDescription)")
                    } else {
                        for c in messages{
                            print((c.header?.subject)!)
                        }
                        //self?.tableView.reloadData()
                    }
                })
                
            case .failure(let error):
                print("Connection error: \((error as NSError).localizedDescription)")
            }
        })
        
        
        
    }
}
