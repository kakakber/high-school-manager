//
//  TodayViewController.swift
//  Mascheroni diario Widget
//
//  Created by Enrico Alberti on 24/03/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var FirstDescr: UILabel!
    
    @IBOutlet weak var PrimoMat: UILabel!
    
    @IBOutlet weak var primoDatas: UILabel!
    
    @IBOutlet weak var SecDesc: UILabel!
    
    @IBOutlet weak var secMat: UILabel!
    
    @IBOutlet weak var secDatas: UILabel!
    
    @IBOutlet weak var primoView: UIView!
    
    @IBOutlet weak var secondoView: UIView!
    
    @IBOutlet weak var noThing: UILabel!
    
    private func makeColor(r: Double, g: Double, b: Double)->UIColor{
        //funzione per creare velocemente colori con rgb
        let retCol = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0)
        return retCol
    }
    @IBOutlet weak var bar: UIView!
    
    var colori : [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colori = [makeColor(r: 56, g: 72, b: 92), makeColor(r: 81, g: 150, b: 213), makeColor(r: 214, g: 87, b: 69), makeColor(r: 247, g: 207, b: 70), makeColor(r: 216, g: 131, b: 59), makeColor(r: 112, g: 95, b: 191), makeColor(r: 88, g: 54, b: 92), makeColor(r: 229, g: 130, b: 192), makeColor(r: 152, g: 165, b: 166),makeColor(r: 101, g: 201, b: 122), makeColor(r: 62, g: 94, b: 68), makeColor(r: 88, g: 185, b: 157), makeColor(r: 158, g: 135, b: 116), makeColor(r: 237, g: 223, b: 185)]
        
        noThing.isHidden = true
        if let PM = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "PrimoMateria") {
            PrimoMat.text = PM as? String
            if PM as? String == "nonValidNoMatNoMatFirst"{
                primoView.isHidden = true
                secondoView.isHidden = true
                primoDatas.isHidden = true
                secDatas.isHidden = true
                noThing.isHidden = false
                bar.isHidden = true
            }
        }else{
            primoView.isHidden = true
            secondoView.isHidden = true
            primoDatas.isHidden = true
            secDatas.isHidden = true
            noThing.isHidden = false
        }
        if let PC = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "PrimoColore") {
            primoView.backgroundColor! = colori[Int((PC as? String)!)!]
        }
        if let PDE = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "PrimoDescrizione") {
            FirstDescr.text = PDE as? String
        }
        if let PDA = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "PrimoData") {
            primoDatas.text = PDA as? String
            primoDatas.text!.removeLast(); primoDatas.text!.removeLast(); primoDatas.text!.removeLast();primoDatas.text!.removeLast()
        }
        if let SM = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "SecondoMateria") {
            secMat.text = SM as? String
            if SM as? String == "nonValidNoMatNoMatSecond"{
                secondoView.isHidden = true
                secDatas.isHidden = true
                bar.isHidden = true
            }
        }else{
            secondoView.isHidden = true
            secDatas.isHidden = true
            bar.isHidden = true
        }
        if let SC = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "SecondoColore") {
            secondoView.backgroundColor! = colori[Int((SC as? String)!)!]
        }
        if let SDE = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "SecondoDescrizione") {
            SecDesc.text = SDE as? String
        }
        if let SDA = UserDefaults.init(suiteName: "group.com.liceomascheroni.alberti.mascheroni")?.value(forKey: "SecondoData") {
            secDatas.text = SDA as? String
            secDatas.text!.removeLast(); secDatas.text!.removeLast(); secDatas.text!.removeLast(); secDatas.text!.removeLast()
        }
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
