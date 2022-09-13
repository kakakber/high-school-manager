//
//  SelectedMateriaVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 23/08/2018.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit
import Charts
import UICircularProgressRing
import DropDown


var materiaTrans : String = ""
var tranzIndex = 0

class SelectedMateriaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mediaItem: UILabel!
    
    @IBOutlet weak var votiLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var segmented: HBSegmentedControl!
    
    var tuttiIDatiInit : [materiaMajor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = materiaTrans
        segmented.items = ["Complessivo","1º periodo", "2º periodo"]
        segmented.selectedLabelColor = .white
        segmented.unselectedLabelColor = .black
        segmented.backgroundColor = .white
        segmented.thumbColor = .black
        if UltraMaterie[tranzIndex].votiSP.count != 0{
            votiLabel.text! = "Voti secondo periodo"
            segmented.selectedIndex = 2
            populateData(fotInd: 2)
            setMedie(indx: 2)
        }else{
            votiLabel.text! = "Voti primo periodo"
            segmented.items = ["Complessivo","1º periodo"]
            segmented.selectedIndex = 1
            populateData(fotInd: 1)
            setMedie(indx: 2)
        }
        segmented.font = UIFont(name: "Avenir-Black", size: 12)
        segmented.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmented.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        //setChartValues()
        //randomize()
        
        lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        
        
        print("mesi: \(mesi), oth: \(votiRP)")
        
        setLineChart()
        //setChartValues()
        
        dropDown.anchorView = moreView
        //The list of items to display. Can be changed dynamically
        tuttiIDatiInit = UltraMaterie
        
        getTipiVot(per: 2)
        
        dropDown.dataSource = tipiVotMore
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UltraMaterie = tuttiIDatiInit
    }
    
    func getTipiVot(per: Int){
        tipiVotMore.removeAll()
        if per == 2{
        for t in UltraMaterie[tranzIndex].votiSP{
            var trt = false
            for c in tipiVotMore{
                if c == t.tipoVoto{
                    trt = true
                }
            }
            if !trt{
                tipiVotMore.append(t.tipoVoto)
            }
        }
            tipiVotMore.append("Tutti")
            print(tipiVotMore)
            
            for j in UltraMaterie[tranzIndex].votiSP{
                //
            }
      }
        if per == 1{
            for t in UltraMaterie[tranzIndex].votiPP{
                var trt = false
                for c in tipiVotMore{
                    if c == t.tipoVoto{
                        trt = true
                    }
                }
                if !trt{
                    tipiVotMore.append(t.tipoVoto)
                }
            }
            tipiVotMore.append("Tutti")
            print(tipiVotMore)
            
            
        }
        
        if per == 0{
            let ttVTTT = UltraMaterie[tranzIndex].votiSP + UltraMaterie[tranzIndex].votiPP
            for t in ttVTTT{
                var trt = false
                for c in tipiVotMore{
                    if c == t.tipoVoto{
                        trt = true
                    }
                }
                if !trt{
                    tipiVotMore.append(t.tipoVoto)
                }
            }
            tipiVotMore.append("Tutti")
            print(tipiVotMore)
        }
    }
    
    var tipiVotMore : [String] = []
    
    let dropDown = DropDown()
    
    @IBOutlet weak var moreView: UIView!
    
    @IBAction func moreButton(_ sender: Any) {
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.classeLablel.text! = "\(item)"
            
        }
    }
    
    @IBAction func selSlider(_ sender: UISlider) {
        let currentValue = (round(sender.value/0.25)*0.25)
        
        
        sePrendessiLabel.text! = "\(currentValue)"
        
        sePrendessiPR.setProgress(value: CGFloat(currentValue), animationDuration: 0.0)
        
        if currentValue < 5{
            sePrendessiPR.innerRingColor = UIColor.flatRedColorDark()
            sePrendessiPR.outerRingColor = UIColor.flatRedColorDark()
        }else if currentValue > 5.99{
            sePrendessiPR.innerRingColor = UIColor.flatGreenColorDark()
            sePrendessiPR.outerRingColor = UIColor.flatGreenColorDark()
        }else{
            sePrendessiPR.innerRingColor = UIColor.flatYellowColorDark()
            sePrendessiPR.outerRingColor = UIColor.flatYellowColorDark()
        }
        var av = 0.0
        if segmented.selectedIndex == 0 {
            av = (votiTSum+Double(currentValue))/Double(votiTnum+1)
        }else if segmented.selectedIndex == 1{
            av = (votiPPSum+Double(currentValue))/Double(votiPPnum+1)
        }else{
            av = (votiSPSum+Double(currentValue))/Double(votiSPnum+1)
        }
        
        av = (round(100*av)/100)
        avreiLabel.text! = "\(av)"
        avreiPR.setProgress(value: CGFloat(av), animationDuration: 0.0)
        
        if av < 5{
            avreiPR.innerRingColor = UIColor.flatRedColorDark()
            avreiPR.outerRingColor = UIColor.flatRedColorDark()
        }else if av > 5.99{
            avreiPR.innerRingColor = UIColor.flatGreenColorDark()
            avreiPR.outerRingColor = UIColor.flatGreenColorDark()
        }else{
            avreiPR.innerRingColor = UIColor.flatYellowColorDark()
            avreiPR.outerRingColor = UIColor.flatYellowColorDark()
        }
        
    }
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        tableView.reloadData()
        slider.setValue(6.0, animated: true)
        if segmented.selectedIndex == 0 {
            votiLabel.text! = "Tutti i voti"
            lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
            populateData(fotInd: 0)
            setMedie(indx: 0)
            setLineChart()
        }else if segmented.selectedIndex == 1{
            votiLabel.text! = "Voti primo periodo"
            lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
            populateData(fotInd: 1)
            setMedie(indx: 1)
            setLineChart()
        }else{
            votiLabel.text! = "Voti secondo periodo"
            lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInOutQuart)
            populateData(fotInd: 2)
            setMedie(indx: 2)
            setLineChart()
        }
    }
    
    var votiTSum : Double = 0
    var votiTnum : Int = 0
    
    var votiPPSum : Double = 0
    var votiPPnum : Int = 0
    
    var votiSPSum : Double = 0
    var votiSPnum : Int = 0
    
    func getVotiEnum(){
        votiSPSum = 0
        votiSPnum = 0
        
        votiPPSum = 0
        votiPPnum = 0
        
        votiTSum = 0
        votiTnum = 0
        
        for u in UltraMaterie[tranzIndex].votiPP{
            votiPPSum += u.voto
            votiPPnum += 1
        }
        for u in UltraMaterie[tranzIndex].votiSP{
            votiSPSum += u.voto
            votiSPnum += 1
        }
        
        let ytu = UltraMaterie[tranzIndex].votiSP+UltraMaterie[tranzIndex].votiPP
        
        for u in ytu{
            votiTSum += u.voto
            votiTnum += 1
        }
    }
    
    func setMedie(indx: Int){
        getVotiEnum()
        mediaComp.minValue = 0
        mediaComp.maxValue = 10
        mediaComp.value = 0
        
        sePrendessiPR.outerRingColor = UIColor.flatGreenColorDark()
        sePrendessiPR.innerRingColor = UIColor.flatGreenColorDark()
        sePrendessiPR.minValue = 0
        sePrendessiPR.maxValue = 10
        sePrendessiPR.value = 0
        
        avreiPR.minValue = 0
        avreiPR.maxValue = 10
        avreiPR.value = 0
        
        if segmented.selectedIndex == 0{
            var md = (UltraMaterie[tranzIndex].mediaPP+UltraMaterie[tranzIndex].mediaSP)/2
            if UltraMaterie[tranzIndex].votiSP.count == 0{
                md = UltraMaterie[tranzIndex].mediaPP
            }
            mediaCompLabel.text! = "\(round(100*md)/100)"
            mediaComp.setProgress(value: CGFloat(md), animationDuration: 0.8)
            if md < 5{
                mediaComp.innerRingColor = UIColor.flatRedColorDark()
                mediaComp.outerRingColor = UIColor.flatRedColorDark()
            }else if md > 5.99{
                mediaComp.innerRingColor = UIColor.flatGreenColorDark()
                mediaComp.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                mediaComp.innerRingColor = UIColor.flatYellowColorDark()
                mediaComp.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            let dd = (votiTSum+6)/Double(votiTnum+1)
            sePrendessiLabel.text! = "6"
            sePrendessiPR.innerRingColor = UIColor.flatGreenColorDark()
            sePrendessiPR.setProgress(value: 6.0, animationDuration: 0.8)
            avreiLabel.text! = "\(round(100*dd)/100)"
            avreiPR.setProgress(value: CGFloat(dd), animationDuration: 0.8)
            if dd < 5{
                avreiPR.innerRingColor = UIColor.flatRedColorDark()
                avreiPR.outerRingColor = UIColor.flatRedColorDark()
            }else if dd > 5.99{
                avreiPR.innerRingColor = UIColor.flatGreenColorDark()
                avreiPR.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                avreiPR.innerRingColor = UIColor.flatYellowColorDark()
                avreiPR.outerRingColor = UIColor.flatYellowColorDark()
            }
            
        }else if segmented.selectedIndex == 1{
            let md = UltraMaterie[tranzIndex].mediaPP
            mediaCompLabel.text! = "\(round(100*md)/100)"
            mediaComp.setProgress(value: CGFloat(md), animationDuration: 0.8)
            if md < 5{
                mediaComp.innerRingColor = UIColor.flatRedColorDark()
                mediaComp.outerRingColor = UIColor.flatRedColorDark()
            }else if md > 5.99{
                mediaComp.innerRingColor = UIColor.flatGreenColorDark()
                mediaComp.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                mediaComp.innerRingColor = UIColor.flatYellowColorDark()
                mediaComp.outerRingColor = UIColor.flatYellowColorDark()
            }
            let dd = (votiPPSum+6)/Double(votiPPnum+1)
            sePrendessiLabel.text! = "6"
            sePrendessiPR.innerRingColor = UIColor.flatGreenColorDark()
            sePrendessiPR.outerRingColor = UIColor.flatGreenColorDark()
            
            sePrendessiPR.setProgress(value: 6.0, animationDuration: 0.8)
            avreiLabel.text! = "\(round(100*dd)/100)"
            avreiPR.setProgress(value: CGFloat(dd), animationDuration: 0.8)
            if dd < 5{
                avreiPR.innerRingColor = UIColor.flatRedColorDark()
                avreiPR.outerRingColor = UIColor.flatRedColorDark()
            }else if dd > 5.99{
                avreiPR.innerRingColor = UIColor.flatGreenColorDark()
                avreiPR.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                avreiPR.innerRingColor = UIColor.flatYellowColorDark()
                avreiPR.outerRingColor = UIColor.flatYellowColorDark()
            }
        }else{
            let md = UltraMaterie[tranzIndex].mediaSP
            mediaCompLabel.text! = "\(round(100*md)/100)"
            mediaComp.setProgress(value: CGFloat(md), animationDuration: 0.8)
            if md < 5{
                mediaComp.innerRingColor = UIColor.flatRedColorDark()
                mediaComp.outerRingColor = UIColor.flatRedColorDark()
            }else if md > 5.75{
                mediaComp.innerRingColor = UIColor.flatGreenColorDark()
                mediaComp.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                mediaComp.innerRingColor = UIColor.flatYellowColorDark()
                mediaComp.outerRingColor = UIColor.flatYellowColorDark()
            }
            let dd = (votiSPSum+6)/Double(votiSPnum+1)
            sePrendessiLabel.text! = "6"
            sePrendessiPR.setProgress(value: 6.0, animationDuration: 0.8)
            avreiLabel.text! = "\(round(100*dd)/100)"
            avreiPR.setProgress(value: CGFloat(dd), animationDuration: 0.8)
            if dd < 5{
                avreiPR.innerRingColor = UIColor.flatRedColorDark()
                avreiPR.outerRingColor = UIColor.flatRedColorDark()
            }else if dd > 5.99{
                avreiPR.innerRingColor = UIColor.flatGreenColorDark()
                avreiPR.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                avreiPR.innerRingColor = UIColor.flatYellowColorDark()
                avreiPR.outerRingColor = UIColor.flatYellowColorDark()
            }
        }
    }
    
    @IBOutlet weak var mediaComp: UICircularProgressRingView!
    
    @IBOutlet weak var sePrendessiPR: UICircularProgressRingView!
    @IBOutlet weak var mediaCompLabel: UILabel!
    
    @IBOutlet weak var avreiLabel: UILabel!
    
    @IBOutlet weak var avreiPR: UICircularProgressRingView!
    
    @IBOutlet weak var sePrendessiLabel: UILabel!
    
    var mesi = [Double]()
    var votiRP : [Double] = []
    
    func populateData(fotInd : Int){
        mesi.removeAll()
        lineDataEntry.removeAll()
        votiRP.removeAll()
        var vt : [voto] = []
        if fotInd == 0{
            vt = UltraMaterie[tranzIndex].votiPP+UltraMaterie[tranzIndex].votiSP
        }else if fotInd == 1{
            vt = UltraMaterie[tranzIndex].votiPP
        }else{
            vt = UltraMaterie[tranzIndex].votiSP
        
        }
        
        print(vt.count)
        
        var t = 0;
        for d in vt{
            
            votiRP.append(d.voto)
            t += 1
            mesi.append(Double(t))
        }
    }
    
    
    var lineDataEntry : [ChartDataEntry] = []
    
    func setLineChart(){
        lineChartView.noDataTextColor = .white
        lineChartView.noDataText = "nessun dato"
        lineChartView.backgroundColor = UIColor.clear
        
        for i in 0..<mesi.count{
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(votiRP[i]))
            lineDataEntry.append(dataPoint)
        }
        
        let charDataSet = LineChartDataSet(values: lineDataEntry, label: nil)
        let chartData = LineChartData()
        chartData.addDataSet(charDataSet)
        chartData.setDrawValues(true)
        charDataSet.colors = [UIColor.flatPinkColorDark()]
        charDataSet.setCircleColor(UIColor.flatPinkColorDark())
        charDataSet.circleHoleColor = UIColor.blue
        charDataSet.mode = .cubicBezier
        charDataSet.circleRadius = 4
        
        let gradientColors = [UIColor.flatPinkColorDark().cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        charDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        charDataSet.drawFilledEnabled = true // Draw the Gradient
        
        //let formatter: chartFormatter = chartFormatter()
        //formatter.setValues(values: mesi)
        
        //xaxis.valueFormatter = formatter
        
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        
        lineChartView.data = chartData
        
        
        //let formatter : ChartFor
    }
    
    public class chartFormatter : NSObject, IAxisValueFormatter{
        var dur = [String]()
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return dur[Int(value)]
        }
        
        public func setValues(values: [String]){
            self.dur = values
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmented.selectedIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pier", for: indexPath) as! tvCell
            var voti = UltraMaterie[tranzIndex].votiPP+UltraMaterie[tranzIndex].votiSP
            voti = voti.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
            if voti[indexPath.row].voto < 5{
                cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                cell.prRing.outerRingColor = UIColor.flatRedColorDark()
            }else if voti[indexPath.row].voto > 5.99{
                cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            cell.prRing.setProgress(value: CGFloat(voti[indexPath.row].voto), animationDuration: 0.5)
            cell.materia.text! = voti[indexPath.row].tipoVoto
            cell.voto.text! = voti[indexPath.row].votoMostrabile
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "dd MMMM yyyy"
            
            let now = dateformatter.string(from: voti[indexPath.row].data)
            var periodo = ""
            if voti[indexPath.row].periodPos == 1.0{
                periodo = "1º periodo"
            }else{
                periodo = "2º periodo"
            }
            
            cell.tipoEData.text! = "\(now) ~ \(periodo)"
            cell.descriz.text! = voti[indexPath.row].notesForFamily
            cell.selectionStyle = .none
            
            return cell
            
        }else if segmented.selectedIndex == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pier", for: indexPath) as! tvCell
            var voti = UltraMaterie[tranzIndex].votiPP
            voti = voti.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
            if voti[indexPath.row].voto < 5{
                cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                cell.prRing.outerRingColor = UIColor.flatRedColorDark()
            }else if voti[indexPath.row].voto > 5.99{
                cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            cell.prRing.setProgress(value: CGFloat(voti[indexPath.row].voto), animationDuration: 0.5)
            cell.materia.text! = voti[indexPath.row].tipoVoto
            cell.voto.text! = voti[indexPath.row].votoMostrabile
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "dd MMMM yyyy"
            
            let now = dateformatter.string(from: voti[indexPath.row].data)
            
            cell.tipoEData.text! = now
            cell.descriz.text! = voti[indexPath.row].notesForFamily
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pier", for: indexPath) as! tvCell
            var voti = UltraMaterie[tranzIndex].votiSP
            voti = voti.sorted(by: { $0.data.compare($1.data) == .orderedDescending })
            if voti[indexPath.row].voto < 5{
                cell.prRing.innerRingColor = UIColor.flatRedColorDark()
                cell.prRing.outerRingColor = UIColor.flatRedColorDark()
            }else if voti[indexPath.row].voto > 5.99{
                cell.prRing.innerRingColor = UIColor.flatGreenColorDark()
                cell.prRing.outerRingColor = UIColor.flatGreenColorDark()
            }else{
                cell.prRing.innerRingColor = UIColor.flatYellowColorDark()
                cell.prRing.outerRingColor = UIColor.flatYellowColorDark()
            }
            
            cell.prRing.setProgress(value: CGFloat(voti[indexPath.row].voto), animationDuration: 0.5)
            cell.materia.text! = voti[indexPath.row].tipoVoto
            cell.voto.text! = voti[indexPath.row].votoMostrabile
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "dd MMMM yyyy"
            
            let now = dateformatter.string(from: voti[indexPath.row].data)
            
            cell.tipoEData.text! = now
            cell.descriz.text! = voti[indexPath.row].notesForFamily
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmented.selectedIndex == 0{
            return UltraMaterie[tranzIndex].votiSP.count+UltraMaterie[tranzIndex].votiPP.count
            
        }else if segmented.selectedIndex == 1{
            return UltraMaterie[tranzIndex].votiPP.count
        }else{
            return UltraMaterie[tranzIndex].votiSP.count
        }
    }
    
    
}
