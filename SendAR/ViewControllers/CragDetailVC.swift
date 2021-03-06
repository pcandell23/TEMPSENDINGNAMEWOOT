//
//  CragDetailVC.swift
//  SendAR
//
//  Created by Bennett Baker on 7/11/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//

import UIKit
import MapKit

class CragDetailVC: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var routesView: UIView!
    @IBOutlet weak var routesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var routesTableViewHeightConstraint: NSLayoutConstraint!

    var cragName: String = "Crag Name"
    var crag: Crag? = nil
    var routes: [Route] = []
    
    
    @IBOutlet weak var cragDescription: UILabel!
    @IBOutlet weak var cragMap: MKMapView!
    @IBOutlet weak var routeTable: UITableView!
    @IBOutlet weak var noLocationLabel: UILabel!
    @IBAction func dismissVCButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var routeIndex: Int  = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        centerViewOnCragLocation()
    }
    
    func centerViewOnCragLocation() {
        if crag?.getFenceCoordinates() != nil {
            let cragLocation = CLLocationCoordinate2D(latitude: crag!.getFenceLatitudeDouble(), longitude: crag!.getFenceLongitudeDouble())
            let cragRegion = MKCoordinateRegion.init(center: cragLocation, latitudinalMeters: 2500, longitudinalMeters: 2500)
            cragMap.setRegion(cragRegion, animated: true)
            noLocationLabel.text = ""
        } else {
            noLocationLabel.text = "Location Unavailable"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if crag != nil{
            self.title                  = crag!.getName()
            self.routes                 = crag!.getRoutesAsArray()
            self.cragDescription.text   = crag!.getDescription()
        }
        
        let nib = UINib(nibName: "RouteCell", bundle: nil)
        routeTable.register(nib, forCellReuseIdentifier: "RouteCell")
        routeTable.delegate = self
        routeTable.dataSource = self
        
        formatViews()
    }
    
    func formatViews() {
        cragMap.clipsToBounds = true
        cragMap.layer.cornerRadius = 10.0
        
        descriptionView.clipsToBounds = true
        descriptionView.layer.cornerRadius = 10.0
        
        let font = UIFont.systemFont(ofSize: 17.0)
        var cragDescriptionLength: CGFloat =  17.0
        if crag != nil {
            cragDescriptionLength = heightForView(text: crag!.getDescription(), font: font, width: 364)
            descriptionViewHeight.constant = cragDescriptionLength + 51 //71
        } else {
            descriptionViewHeight.constant = 88
        }
        
        routesView.clipsToBounds = true
        routesView.layer.cornerRadius = 10.0
        routesTableViewHeightConstraint.constant = CGFloat(routes.count * 63)
        routesViewHeightConstraint.constant = routesTableViewHeightConstraint.constant + 41
        
        contentViewHeightConstraint.constant = 270 + descriptionViewHeight.constant + routesViewHeightConstraint.constant
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
           let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
           label.numberOfLines = 0
           label.lineBreakMode = NSLineBreakMode.byWordWrapping
           label.font = font
           label.text = text

           label.sizeToFit()
           return label.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        
        cell.routeName.text     = routes[indexPath.row].getName()
        cell.routeGrade.text    = routes[indexPath.row].getGrade()
        cell.routeType.text     = routes[indexPath.row].getType() + " - " + String(routes[indexPath.row].getPitches()) + " Pitches, " + String(routes[indexPath.row].getAltitude()) + "ft"
        
        let rating = routes[indexPath.row].getRating()
        if rating > 4 && rating <= 5 {
            cell.routeRating.text = "⭐️⭐️⭐️⭐️⭐️"
        } else if rating > 3 {
            cell.routeRating.text = "⭐️⭐️⭐️⭐️"
        } else if rating > 2 {
            cell.routeRating.text = "⭐️⭐️⭐️"
        } else if rating > 1 {
            cell.routeRating.text = "⭐️⭐️"
        } else if rating > 0 {
            cell.routeRating.text = "⭐️"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CragToRoute"{
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! RouteDetailVC
            vc.route = routes[routeIndex]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        routeIndex = indexPath.row

        performSegue(withIdentifier: "CragToRoute", sender: cell)
    }
    
}
