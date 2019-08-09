//
//  ViewController.swift
//  Werkstuk2_2dezit
//
//  Created by M_FLY on 02/08/2019.
//  Copyright © 2019 ehb. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var managedContext:NSManagedObjectContext?
    
    @IBOutlet weak var btnVernieuw: UIBarButtonItem!
    @IBOutlet weak var lblLaatsteGeupdate: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var color:UIColor?
    //coordinates dat we binnen krijgen
    
    var inkomendCoordinaten:[Coordinaat] = []
    var inkomendRecords:[Records] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        // drag MKmapview to yellow square and  choose delegate
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        eersteLaunch()
        checkLocationService()
    }

    override func viewDidAppear(_ animated: Bool) { // alert venster
        
        
        // createAlert(title: "eerste keer")
    }
    /*
     func createAlert (title:String){
     let alert = UIAlertController(nibName: title, bundle: UIAlertController.Style.alert)
     alert.addAction(UIAlertAction(title: "good to know", style: UIAlertAction.style.default, handler: {(action) in
     alert.dismiss(animated: true, completion: nil)
     }))
     }
     */
    
    
    //https://stackoverflow.com/questions/27208103/detect-first-launch-of-ios-app
    func eersteLaunch(){
        
        
        
        let Eerstelaunch = UserDefaults.standard.bool(forKey: "EersteLaunch") // declareren en gelijkstellen met als een boolean met de key "EersteLaunch"
        
        if !Eerstelaunch  {
            dataOphalen()

            
            UserDefaults.standard.set(true, forKey: "Eerstelaunch")
            print("Dit is de eerste launch")
            
            
            
        } else {
            coreDataOphalen()
            
            print("De app is meerdere keren gelaunch geweest")
            
        }
    }
    
    @IBAction func VernieuwData(_ sender: Any) {
        dataOphalen() // roept de methode/function dataOphalne op voor de knop "vernieuwen"
    }
    
    func coreDataOphalen(){
        
        mapView.removeOverlays(mapView.overlays) //
        
        // entity opmaken
        let haalCoordinaten = NSFetchRequest<NSFetchRequestResult>(entityName: "Coordinaat")         //Coordinaten & Records ophalen  FetchRequest
        let haalRecords = NSFetchRequest<NSFetchRequestResult>(entityName: "Records")
        //  entity ophalen
        do {
            self.inkomendRecords = try self.managedContext!.fetch(haalRecords) as! [Records]
            lblLaatsteGeupdate.text = inkomendRecords[0].timestamp
            for record in self.inkomendRecords{
                // filtering van resultaten met NSpredicate
                haalCoordinaten.predicate = NSPredicate(format: "recordid == %@", record.recordid!)
                self.inkomendCoordinaten = try self.managedContext!.fetch(haalCoordinaten) as! [Coordinaat]
                if(record.level_of_service=="ORANGE"){
                    self.color = UIColor.orange
                }
                if(record.level_of_service=="ROUGE"){
                    self.color = UIColor.red
                }
                if(record.level_of_service=="VERT"){
                    self.color = UIColor.green
                }
                var points = [CLLocationCoordinate2D]()
                for coordinaat in self.inkomendCoordinaten {
                    points.append(CLLocationCoordinate2D(latitude: coordinaat.latitude, longitude: coordinaat.longitude))
                    let polyLine = MKGeodesicPolyline(coordinates: points, count: points.count)
                    self.mapView.addOverlay(polyLine)
                }
                points.removeAll()
            }
        } catch {
            fatalError("Kan data niet fetchen: \(error)")
        }
    }
    
    
    func dataOphalen() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else
        {
            return
        }
         managedContext = appDelegate.persistentContainer.viewContext
        
    }
    
    
    
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func centerViewOnUserLocation(){
        if let location  = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            //
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: //als de app actief is kan het locatie gebruiken
            mapView.showsUserLocation = true // set  Scheme/Edit Scheme/Options/Allow Location Simulation checked but don't have a default location set.
            centerViewOnUserLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            
            break
        case .authorizedAlways: // als de app zelfs niet actief is.
            break
            
        }
    }
    
    
    
    
    
}

//https://stackoverflow.com/questions/25437891/use-of-undeclared-type-in-swift-even-though-type-is-internal-and-exists-in-s
