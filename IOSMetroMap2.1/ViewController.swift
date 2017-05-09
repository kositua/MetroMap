//
//  ViewController.swift
//  IOSMetroMap2.1
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 koss. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var selectFromStation: UIPickerView!
    
    @IBOutlet weak var selectToStation: UIPickerView!
    
    @IBOutlet weak var viewTheRoute: UITextView!
    
    @IBAction func buttonRoute(_ sender: UIButton) {
        viewTheRoute.text = ""
        if st1 == st2{
            viewTheRoute.text = "Select different stations"
        }else{
            for i in getroute(dataController: dataController, stationFrom: st1, stationTo: st2){
                viewTheRoute.text?.append(i.stationname! + "  ->  ")
            }
        }
    }
    
    let dataController = DataController()
    
    var arrayOfStations = [[String](), [String]()]
    
    var st1 = String()
    
    var st2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...1{
            for station in dataController.getStationsOrLines(entityname: "MetroStation") as! [MetroStation]{
                arrayOfStations[i].append(station.stationname!)
            }
        }
        selectFromStation.delegate = self
        selectFromStation.dataSource = self
        
        selectToStation.delegate = self
        selectToStation.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfStations[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfStations[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        st1 = arrayOfStations[0][selectFromStation.selectedRow(inComponent: 0)]
        st2 = arrayOfStations[1][selectToStation.selectedRow(inComponent: 0)]
    }
    
    //getting route from one to another stations
    func getroute(dataController: DataController, stationFrom: String, stationTo: String)->[MetroStation] {
        let allstations = dataController.getStationsOrLines(entityname: "MetroStation")
        var fromStation = MetroStation()
        var toStation = MetroStation()
        var firstLine = MetroLine()
        var secondLine = MetroLine()
        var transferStation = MetroStation()
        var route = [MetroStation]()
        for station in allstations{
            if(station as! MetroStation).stationname == stationFrom{
                fromStation = station as! MetroStation
                firstLine = (station as! MetroStation).tolines!
            }
            if(station as! MetroStation).stationname == stationTo{
                toStation = station as! MetroStation
                secondLine = (station as! MetroStation).tolines!
            }
        }
        if firstLine != secondLine {
            for station in allstations{
                if ((station as! MetroStation).linetoline == secondLine.linename)&&((station as! MetroStation).linename == firstLine.linename){
                    transferStation = station as! MetroStation
                }
            }
            route = arrayRoute(dataController: dataController, metroLine: firstLine, fromStation: fromStation, toStation: transferStation)
            for station in allstations{
                if ((station as! MetroStation).linetoline == firstLine.linename)&&((station as! MetroStation).linename == secondLine.linename){
                    transferStation = station as! MetroStation
                }
            }
            route.append(contentsOf: arrayRoute(dataController: dataController, metroLine: secondLine, fromStation: transferStation, toStation: toStation))
            
        } else{
            route = arrayRoute(dataController: dataController, metroLine: firstLine, fromStation: fromStation, toStation: toStation)
        }
        return route
    }
    
    // making route for one line
    func arrayRoute(dataController: DataController, metroLine: MetroLine, fromStation: MetroStation, toStation: MetroStation)-> [MetroStation]{
        var routes = [MetroStation]()
        let array = dataController.getStationsByLines(metroLine: metroLine)
        if fromStation.id > toStation.id{
            let reversarray = array.reversed()
            var arr = [MetroStation]()
            arr.append(contentsOf: reversarray)
            routes = getCheckedArray(array: arr, fromStation: fromStation, toStation: toStation)
        }else{
            routes = getCheckedArray(array: array, fromStation: fromStation, toStation: toStation)
        }
        return routes
    }
    
    //getting out of line only needed stations
    func getCheckedArray(array: [MetroStation], fromStation: MetroStation, toStation: MetroStation) -> [MetroStation]{
        var checkedArray = [MetroStation]()
        let fromst = array.index(of: fromStation)
        let tost = array.index(of: toStation)
        for i in fromst! ... tost! {
            checkedArray.append(array[i])
        }
        return checkedArray
    }
    
    //setting stations
    func addStations(dataController: DataController, arr: [MetroLine]){
        let lineRed = arr[0]
        let lineBlue = arr[1]
        let lineGreen = arr[2]
        dataController.setStations(stname: "Akademmistechko", line: lineRed, ltl: nil, id: 110)
        dataController.setStations(stname: "Zhytomyrska", line: lineRed, ltl: nil, id: 111)
        dataController.setStations(stname: "Svyiatoshyn", line: lineRed, ltl: nil, id: 112)
        dataController.setStations(stname: "Nyvky", line: lineRed, ltl: nil, id: 113)
        dataController.setStations(stname: "Beresteiska", line: lineRed, ltl: nil, id: 114)
        dataController.setStations(stname: "Shuliavska", line: lineRed, ltl: nil, id: 115)
        dataController.setStations(stname: "Politekhnichnyi instytut", line: lineRed, ltl: nil, id: 116)
        dataController.setStations(stname: "Vokzalna", line: lineRed, ltl: nil, id: 117)
        dataController.setStations(stname: "Universytet", line: lineRed, ltl: nil, id: 118)
        dataController.setStations(stname: "Teatralna", line: lineRed, ltl: "green", id: 119)
        dataController.setStations(stname: "Khreschatyk", line: lineRed, ltl: "blue", id: 120)
        dataController.setStations(stname: "Arsenalna", line: lineRed, ltl: nil, id: 121)
        dataController.setStations(stname: "Dnipro", line: lineRed, ltl: nil, id: 122)
        dataController.setStations(stname: "Hidropark", line: lineRed, ltl: nil, id: 123)
        dataController.setStations(stname: "livoberezhna", line: lineRed, ltl: nil, id: 124)
        dataController.setStations(stname: "Darnitsa", line: lineRed, ltl: nil, id: 125)
        dataController.setStations(stname: "Chernigivska", line: lineRed, ltl: nil, id: 126)
        dataController.setStations(stname: "Lisova", line: lineRed, ltl: nil, id: 127)
        
        dataController.setStations(stname: "Heroiv Dnipra", line: lineBlue, ltl: nil, id: 210)
        dataController.setStations(stname: "Minska", line: lineBlue, ltl: nil, id: 211)
        dataController.setStations(stname: "Obolon", line: lineBlue, ltl: nil, id: 212)
        dataController.setStations(stname: "Petrivka", line: lineBlue, ltl: nil, id: 213)
        dataController.setStations(stname: "Tarasa Shevchenka", line: lineBlue, ltl: nil, id: 214)
        dataController.setStations(stname: "Kontraktova ploshcha", line: lineBlue, ltl: nil, id: 215)
        dataController.setStations(stname: "Poshtova ploshcha", line: lineBlue, ltl: nil, id: 216)
        dataController.setStations(stname: "Maidan Nezalezhnosti", line: lineBlue, ltl: "red", id: 217)
        dataController.setStations(stname: "Ploshcha Lva Tolstogo", line: lineBlue, ltl: "green", id: 218)
        dataController.setStations(stname: "Olimpiiska", line: lineBlue, ltl: nil, id: 219)
        dataController.setStations(stname: "Palats Ukraina", line: lineBlue, ltl: nil, id: 220)
        dataController.setStations(stname: "Lybidska", line: lineBlue, ltl: nil, id: 221)
        dataController.setStations(stname: "Demiivska", line: lineBlue, ltl: nil, id: 222)
        dataController.setStations(stname: "Holosiivska", line: lineBlue, ltl: nil, id: 223)
        dataController.setStations(stname: "Vasylkivska", line: lineBlue, ltl: nil, id: 224)
        dataController.setStations(stname: "Vystavkovyi centr", line: lineBlue, ltl: nil, id: 225)
        dataController.setStations(stname: "Ipodrom", line: lineBlue, ltl: nil, id: 226)
        dataController.setStations(stname: "Teremky", line: lineBlue, ltl: nil, id: 227)
        
        dataController.setStations(stname: "Syrets", line: lineGreen, ltl: nil, id: 310)
        dataController.setStations(stname: "Dorohozhychi", line: lineGreen, ltl: nil, id: 311)
        dataController.setStations(stname: "Lukianivska", line: lineGreen, ltl: nil, id: 312)
        dataController.setStations(stname: "Zoloti vorota", line: lineGreen, ltl: "red", id: 314)
        dataController.setStations(stname: "Palats sportu", line: lineGreen, ltl: "blue", id: 315)
        dataController.setStations(stname: "Klovska", line: lineGreen, ltl: nil, id: 316)
        dataController.setStations(stname: "Pecherska", line: lineGreen, ltl: nil, id: 317)
        dataController.setStations(stname: "Druzhbu narodiv", line: lineGreen, ltl: nil, id: 318)
        dataController.setStations(stname: "Vydubychi", line: lineGreen, ltl: nil, id: 319)
        dataController.setStations(stname: "Slavutych", line: lineGreen, ltl: nil, id: 321)
        dataController.setStations(stname: "Osokorky", line: lineGreen, ltl: nil, id: 322)
        dataController.setStations(stname: "Pozniaky", line: lineGreen, ltl: nil, id: 323)
        dataController.setStations(stname: "Kharkivska", line: lineGreen, ltl: nil, id: 324)
        dataController.setStations(stname: "Vyrlytsia", line: lineGreen, ltl: nil, id: 325)
        dataController.setStations(stname: "Boryspilska", line: lineGreen, ltl: nil, id: 326)
        dataController.setStations(stname: "Chervonyi khutir", line: lineGreen, ltl: nil, id: 327)
    }
    
}

