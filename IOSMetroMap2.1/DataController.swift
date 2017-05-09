//
//  DataController.swift
//  IOSMetroMap2.1
//
//  Created by admin on 05.05.17.
//  Copyright © 2017 koss. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //getting arrays stations or lines
    func getStationsOrLines(entityname: String) ->[NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        do {
            let results = try context.fetch(fetchRequest)
            return results as! [NSManagedObject]
        } catch {
            print(error)
        }
        return []
    }
    
    //getting stations by line
    func getStationsByLines(metroLine: MetroLine) -> [MetroStation]{
        let array = metroLine.tostations
        let arr = array?.sorted(by: {($0 as! MetroStation).id < ($1 as! MetroStation).id})
        return arr as! [MetroStation]
    }
    
    //set stations
    func setStations(stname: String, line: MetroLine, ltl: String?, id: Int16) {
        let saveStation = MetroStation(context: context)
        saveStation.stationname = stname
        saveStation.linename = line.linename
        saveStation.linetoline = ltl
        saveStation.tolines = line
        saveStation.id = id
        saveContext()
    }
    
    // set lines
    func setLines(lnname: String) {
        let saveSample = MetroLine(context: context)
        saveSample.linename = lnname
        saveContext()
    }
    
    //for saving context and hadle errors
    func saveContext(){
        do {
            try context.save()
        } catch {
            print("Error with save: \(error)")
        }
    }
    
    // clear the attribute
    func resetSample() {
        let clearSample: NSFetchRequest = MetroStation.fetchRequest()
        let deleteResults = NSBatchDeleteRequest(fetchRequest: clearSample as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteResults)
            try context.save()
        } catch {
            print("Error with save: \(error)")
        }
    }
}
