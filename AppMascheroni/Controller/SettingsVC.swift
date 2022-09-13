//
//  SettingsVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 16/10/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit

var isInExit = false

class SettingsVC: UIViewController {
    @IBAction func indiet(_ sender: Any) {
        isInExit = false
        dismiss(animated: true, completion: nil)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isKeyPresentInUserDefaults(key: "openDiario"){
            let isDiario = UserDefaults.standard.object(forKey: "openDiario") as! String
            if isDiario == "si"{
                switchOut2.isOn = true
            }
        }
        
        if isKeyPresentInUserDefaults(key: "openRegistro"){
            let isDiario = UserDefaults.standard.object(forKey: "openRegistro") as! String
            if isDiario == "si"{
                switchOut.isOn = true
            }
        }
        
        nome.text! = nomeUser
        classeNome.text! = "\(ClasseDellUtente) ~ \(mailUser)"
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var switchOut: UISwitch!
    
    @IBOutlet weak var switchOut2: UISwitch!
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var classeNome: UILabel!
    
    @IBAction func exit(_ sender: Any) {
        isInExit = true
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switch1(_ sender: UISwitch) {
        if sender.isOn == false{
            UserDefaults.standard.set("sas", forKey: "openRegistro")
        }else{
            UserDefaults.standard.set("si", forKey: "openRegistro")
            switchOut2.setOn(false, animated: true)
            UserDefaults.standard.set("sas", forKey: "openDiario")
        }
    }
    
    @IBAction func switch2(_ sender: UISwitch) {
        if sender.isOn == false{
            UserDefaults.standard.set("sas", forKey: "openDiario")
        }else{
            UserDefaults.standard.set("si", forKey: "openDiario")
            switchOut.setOn(false, animated: true)
            UserDefaults.standard.set("sas", forKey: "openRegistro")
        }
    }
    
}
