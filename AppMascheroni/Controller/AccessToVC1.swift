//
//  AccessToVC1.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 07/10/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import JSSAlertView


class AccessToVC1: UIViewController, GIDSignInUIDelegate{
    
    //LogIn con google
    
    @IBOutlet weak var viewGoogleSign: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        self.activityIndicator.stopAnimating()
          
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleSignInClicked(sender: UIButton) {
        self.activityIndicator.startAnimating()
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func dismissButton(_ sender: Any) {
       
            dismiss(animated: true, completion: nil)
        
    }
    func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().signIn()
    }

}
