//
//  MappaVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 27/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Canvas
import DropDown

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

class MappaVC: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoMapLab: UILabel!
    @IBOutlet weak var infoView: CSAnimationView!
    @IBOutlet weak var imgPhoto: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectDown: UIView!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var selectView: UIView!
    
    var searchActive = false
    
    @IBOutlet weak var tableView: UITableView!
    
    let dropDown = DropDown()//dropDown menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
         AppUtility.lockOrientation(.portrait)
        //cambia la posizione iniziale della scroll view
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        infoView.isHidden = true
        searchBar.delegate = self
        dropDown.anchorView = selectDown
        //The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Piano terra", "Primo piano"]
        searchBar.delegate = self
        addToolBar(textField: searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    func DownToMap(selected: Bool){
        var sel : CGFloat = 0.0
        if selected{sel=self.view.frame.height}
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.selectView.frame = CGRect(x: 0, y: sel, width: self.selectView.frame.width, height: self.selectView.frame.height)
            
        },completion: { finish in
            
            
        })
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func selectDropDown(item: String){
        if item == "Primo piano"{
            infoMapLab.text! = "Primo piano"
            map.image = #imageLiteral(resourceName: "primo piano")
        }else{
            infoMapLab.text! = "Piano terra"
            map.image = #imageLiteral(resourceName: "piano terra")
        }
    }
    @IBAction func backToSelect(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectDropDown(item: item)
        }
    }
    
    
    @IBAction func backActt(_ sender: Any) {
        DownToMap(selected: false)
    }
    @IBAction func ANPP(_ sender: Any) {
        DownToMap(selected: true)
        
        infoMapLab.text! = "Piano terra"
        map.image = #imageLiteral(resourceName: "piano terra")
        
    }
    
    @IBAction func ANSP(_ sender: Any) {
        DownToMap(selected: true)
        
        infoMapLab.text! = "Primo piano"
        map.image = #imageLiteral(resourceName: "primo piano")
    }
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgPhoto
    }
    
    
    //------------search-----------------
    
    var allClasses = arrayClassi()
    var filtered : [String] = []
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        filtered = allClasses.filter({ (text) -> Bool in
            let tmp: String = text
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range != nil
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        searchActive = true
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchActive = true
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if searchActive{
            return filtered.count
    }else{
        return allClasses.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        if searchActive{
            if isBaseFloor(classe: filtered[indexPath.row]){
                //apri piano terra
                tableView.isHidden = true
                DownToMap(selected: true)
                
                infoMapLab.text! = "Piano terra"
                map.image = #imageLiteral(resourceName: "piano terra")
            }else{
                DownToMap(selected: true)
                
                infoMapLab.text! = "Primo piano"
                map.image = #imageLiteral(resourceName: "primo piano")
            }
        }else{
            if isBaseFloor(classe: allClasses[indexPath.row]){
                //apri piano terra
                tableView.isHidden = true
                DownToMap(selected: true)
                
                infoMapLab.text! = "Piano terra"
                map.image = #imageLiteral(resourceName: "piano terra")
            }else{
                DownToMap(selected: true)
                
                infoMapLab.text! = "Primo piano"
                map.image = #imageLiteral(resourceName: "primo piano")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        var wt = ""
        if searchActive{
           
        wt = filtered[indexPath.row]
        }else{
           
          wt = allClasses[indexPath.row]
        }
        if isBaseFloor(classe: wt){
            cell.textLabel?.text = "\(wt) ~ Piano terra"
        }else{
            cell.textLabel?.text = "\(wt) ~ Primo piano"}
        
        return cell
    }
    
    func addToolBar(textField: UISearchBar){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Annulla ricerca", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        self.searchBar.endEditing(true)
        searchBar.text! = ""
        searchActive = false
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    //PINS HANDLING PRIMO PIANO
    
    @IBOutlet weak var QD: UIImageView!
    
    
}
