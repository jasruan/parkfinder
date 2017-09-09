//
//  ParkData.swift
//  ParkFinder
//
//  Created by Jasmine Ruan (RIT Student) on 4/3/17.
//  Copyright © 2017 Jasmine Ruan (RIT Student). All rights reserved.
//

import Foundation

class ParkData{
    static let shareData = ParkData()
    var parks = [StatePark]()
    var favParks = [StatePark]()
    private init(){
        
    }
}
