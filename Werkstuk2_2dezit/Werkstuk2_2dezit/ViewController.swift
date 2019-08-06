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
    
}

