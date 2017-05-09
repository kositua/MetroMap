//
//  Station.swift
//  IOSMetroMap2.1
//
//  Created by admin on 06.05.17.
//  Copyright © 2017 koss. All rights reserved.
//

import Foundation

public class Station {
    
    var stationname: String
    
    var linename: String
    
    var linetoline: String?
    
    init(stationname: String, linename: String) {
        self.stationname = stationname
        self.linename = linename
    }
    
    init(stationname: String, linename: String, linetoline: String) {
        self.stationname = stationname
        self.linename = linename
        self.linetoline = linetoline
    }
    
}
