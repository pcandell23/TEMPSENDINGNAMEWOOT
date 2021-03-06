//
//  Alert.swift
//  SendAR
//
//  Created by Bennett Baker on 7/8/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//

import Foundation
import UIKit

//May change to Alert class and different Alert Type subclasses later
struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
        print("\(title) alert displayed.")
    }
    
    static func showLocationServicesDeniedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Location Services Denied", message: "Please enable location services for SendAR in your device settings.")
    }
    
    static func showLocationServicesRestrictedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Location Services Restricted", message: "Location services are restricted on this device.")
    }
    
    static func showRouteNameInvalidAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Route Name Invalid", message: "Please enter a route name before tracking")
    }
    
    static func showAlreadyTrackingAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Tracking In Progress", message: "Please end the current tracking session before attempting to start a new tracking session.")
    }
    
    static func showIncompleteRouteDataAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Route Information Incomplete", message: "Please enter route information for each field before proceeding to the next step.")
    }
    
    static func showIncompleteAreaDataAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Area Information Incomplete", message: "Please enter a name to submit a new area.")
    }
    
    static func showNoAreaSelectedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "No Area Selected", message: "Please select an area before tapping confirm. To add the route without an area, tap \"Not Sure\"")
    }
    
}

/*
     
 //these dont work currently
     func locationServiceDeniedAlert() {
         let alert = UIAlertController(title: "Location Services Denied", message: "Please enable location services for SendAR in your device settings", preferredStyle: .alert)
         // settings button
         alert.addAction(settingsAction)
         alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
         //alert.present(alert, animated: true)
         print("Location Services Denied")
     }
     
     func locationServiceRestrictedAlert() {
         let alert = UIAlertController(title: "Location Services Restricted", message: "Location services are restricted on this device", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
         //alert.present(alert, animated: true)
         print("Location Services Restricted")
     }
     
 
 */
