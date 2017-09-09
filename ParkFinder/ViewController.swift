//
//  ViewController.swift
//  ParkFinder
//
//  Created by Jasmine Ruan (RIT Student) on 3/30/17.
//  Copyright © 2017 Jasmine Ruan (RIT Student). All rights reserved.
//

import UIKit
import MapKit
//MARK: -ivars-
let showParkNotification = NSNotification.Name("showParkNotification")

class ViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(showMap), name: showParkNotification, object: nil)
        loadData()
        mapView.showsUserLocation = true
        
    }
    //MARK: -HELPER- Parsing JSON function
    func loadData(){
        
        
        guard let path = Bundle.main.url(forResource: "parks", withExtension: "js")else{
            print("Error: could not find parks.js!")
            return
        }
        do{
            let data = try Data(contentsOf:path, options:[])
            let json = JSON(data:data)
            if json != JSON.null{
                parse(json: json)
            }
            else{
                print("json is null!")
            }
            
            print("json=\(json)")
        }
        catch{
            print("Error: could not initialize the Data() object!")
        }
    }
  //Parses json file
    func parse(json:JSON){
        let array = json["parks"].arrayValue
        var parks = [StatePark]()
        
        for d in array{
            var name = d["name"].stringValue
            if name.isEmpty{
                name = "No title found"
            }
            var desc = d["desc"].stringValue
            if desc.isEmpty{
                desc = "No description found"
            }
            var url = d["url"].stringValue
            if url.isEmpty{
                url = "No url found"
            }
            let latitude = d["latitude"].floatValue
            let longitude = d["longitude"].floatValue
            let park = StatePark(name:name, latitude:latitude, longitude:longitude, desc:desc, url:url)
            
            
            parks.append(park)
            parks = parks.sorted(
                by: {
                    (park1:StatePark,park2:StatePark)->Bool in
                    return park1.title! < park2.title!
            })
        }
        ParkData.shareData.parks = parks
        print(parks)
        mapView.addAnnotations(ParkData.shareData.parks)
        let metersPerMile:Double = 1609.344
        let myRegion = MKCoordinateRegionMakeWithDistance(parks[0].coordinate, metersPerMile*1000, metersPerMile*1000)
        mapView.setRegion(myRegion, animated:true)
        mapView.selectAnnotation(parks[0], animated:true)
        
    }
    //MARK: -Helper- For adding annotations to the map
    func mapView(_mapView:MKMapView, didSelect view:MKAnnotationView){
        let title = view.annotation?.title ?? "No title Found"
        print("Tapped \(title!)")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StatePark else{
            print("This annotation isn't a StatePark")
            return nil
        }
        let identifier = "pinIdentifier"
        let view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        return view
    }
    //Opens url when info button is tapped.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StatePark else{
            print("This annotation isn't a StatePark")
            
            return
        }
        let url = URL(string: (annotation.urlAdd))
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    //used with the NSNotification to show the specific 
    func showMap(notification: NSNotification){
        tabBarController?.selectedIndex = 0
        
        if let park = notification.userInfo!["park"] as? MKAnnotation{
            mapView.selectAnnotation(park, animated:true)
        }
    }
    //MARK: -Action Methods- for Segmented controller that changes map type
    @IBAction func switchMaps(_ sender: Any) {
        switch((sender as AnyObject).selectedSegmentIndex){
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

