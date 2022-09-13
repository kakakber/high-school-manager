//
//  Functions.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 30/09/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import Foundation
import UIKit


func arrayClassi() -> [String]{
    let classi : [String] = ["1A", "1AS", "1B", "1BS", "1C", "1CS", "1D", "1DS", "1E", "1ES", "1F", "1FS", "1G", "1GS", "2A", "2AS", "2B", "2BS", "2C", "2CS", "2D", "2DS", "2E", "3A", "3AS", "3B", "3BS", "3C", "3CS", "3D", "3DS", "3E", "3G", "4A", "4AS", "4B", "4BS", "4C", "4CS", "4D", "4DS", "4E", "4F", "4G", "5A", "5AS", "5B", "5C", "5CS", "5D", "5DS", "5E", "5ES", "5F", "5FS"]
    
  return classi
}


 var clsPT = ["3C","4H","1F","1B","4D","2C","1CS","2G","2BS","5BS","4AS","5DS","2B","2A","5CS","1D","5B","3D","1A","4G","5A","4C","2F","3FS","5I","3ES","4A"]

var clsPP = ["3B","4DS","4CS","5F","2B","2A","5C","1E","4F","1C","5D","5G","3AS","5AS","3A","2E","5E","2DS","4BS","5H","1G","2AS","4E","3E","1DS","2D","2CS","1F","3CS","1AS"]

func isBaseFloor(classe: String)->Bool{
    for s in clsPT{
        if s == classe{
            return true
        }
    }
    return false
}

//array studneti per



func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

//---------------globalVar-------------------

//accesso con google
var GDnome : String = ""
var GDmail: String = ""
var GDUID : String = ""

//La mia classe ClasseVC
//variabile per sapere se un utente ha richiesto la visione della propria classe
var classeInSegue : Bool = false
//var per sapere la classe dell'utente, se "" l'utente non ha fatto l'accesso
var ClasseDellUtente : String = ""
//classeSelezionata dall'utente
var classeSelezionata : String = ""

//per messaggi:
var MessaggioVersoId : String = ""
var MessaggioVerso : String = ""
var MessaggioId : String = ""
var ClasseStudChat : String = ""

//per info utente (pulsante modifica in HomeVC) :
var classeUser : String = ""
var mailUser : String = ""
var nomeUser : String = ""


var MailxMail = ""

//per comunicazioni/ orario --> WebView:
var urlSel : String = ""
var isItOrario = false
//array di string delle classi:




