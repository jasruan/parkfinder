//
//  StatePark.swift
//  ParkFinder
//
//  Created by Jasmine Ruan (RIT Student) on 3/30/17.
//  Copyright © 2017 Jasmine Ruan (RIT Student). All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class StatePark:NSObject, MKAnnotation, NSCoding{
    //MARK: - private ivars-
    private var name:String
    private var latitude:Float
    private var longitude:Float
    private var desc:String = " "
    private var url:String = " "
    init(name:String, latitude:Float, longitude:Float, desc:String, url:String){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.desc =  desc
        self.url = url
    }
    //MARK: -public ivars -
    public var title:String?{
        return name
    }
    public var subtitle: String?{
        return "I \u{1F496} NY"
    }
    public override var description: String{
        return desc
    }
    public var urlAdd: String{
        return url
    }
    public var coordinate:CLLocationCoordinate2D{
        return CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    }
    //MARK: -encoders & decoders - getting them to abide by nscoding rules
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latitude, forKey:"latitude")
        aCoder.encode(longitude, forKey:"longitude")
        print("encode with coder called on \(name)")
    }
    
    required init(coder aDecoder:NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        latitude = aDecoder.decodeFloat(forKey: "latitude")
        longitude = aDecoder.decodeFloat(forKey: "latitude")
        print("init with coder called on \(name)")
    }
    
}
