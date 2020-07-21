//
//  MyAreasVC.swift
//  SendAR
//
//  Created by Peter Candell on 6/29/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MyAreasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet var myAreasTableView: UITableView!
    
    let delegate = AppDelegate.shared()
    
    var areas: [Area] = []
    var crags: [Crag] = []
    var areasAndCrags = [Area]()
    
    var areaIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let areaNib = UINib(nibName: "AreaCell", bundle: nil)
        myAreasTableView.register(areaNib, forCellReuseIdentifier: "AreaCell")
        let cragNib = UINib(nibName: "CragCell", bundle: nil)
        myAreasTableView.register(cragNib, forCellReuseIdentifier: "CragCell")
        myAreasTableView.delegate = self
        myAreasTableView.dataSource = self
        fetchAreas()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areasAndCrags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.areasAndCrags[indexPath.row] is Crag {
            let cragCell = tableView.dequeueReusableCell(withIdentifier: "CragCell", for: indexPath) as! CragCell
            
            cragCell.cragName.text = (areasAndCrags[indexPath.row] as! Crag).getName()
            cragCell.cragProximity.text = cragCell.getProximity()
            cragCell.numberOfRoutes.text = String((areasAndCrags[indexPath.row] as! Crag).routeCount()) + " routes"
            
            return cragCell
        } else {
            let areaCell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreaCell
            
            areaCell.areaName.text = (areasAndCrags[indexPath.row] ).getName()
            areaCell.areaProximity.text = areaCell.getProximity()
            if (areasAndCrags[indexPath.row] ).subAreaCount() > 0 {
                areaCell.subAreasLabel.text = String((areasAndCrags[indexPath.row] ).subAreaCount()) + " sub-areas"
            } else {
                areaCell.subAreasLabel.text = "No sub-areas"
            }
            
            return areaCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            if editingStyle == .delete {
                let moc = delegate.dataController?.persistentContainer.viewContext
                if moc == nil {
                    return
                }
                let commit = areasAndCrags[indexPath.row]
                moc!.delete(commit)
                areasAndCrags.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                delegate.dataController?.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO
        if segue.identifier == "MyAreasToArea"{
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! AreaDetailVC
            vc.area = areasAndCrags[areaIndex]
        } else if segue.identifier == "MyAreasToCrag"{
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! CragDetailVC
            vc.crag = areasAndCrags[areaIndex] as? Crag
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        areaIndex = indexPath.row
        
        if type(of: areasAndCrags[areaIndex]) == Crag.self{
            performSegue(withIdentifier: "MyAreasToCrag", sender: cell)
        } else {
            performSegue(withIdentifier: "MyAreasToArea", sender: cell)
        }

        performSegue(withIdentifier: "MyAreasToArea", sender: cell)
    }

    func fetchAreas(){
        let moc = delegate.dataController?.persistentContainer.viewContext
        if moc == nil{
            print("Failed to fetch routes.")
            return
        }
        let requestAreas = NSFetchRequest<Area>(entityName: "Area")
        var fetched: [Area]?
        do {
            fetched = try moc?.fetch(requestAreas)
        } catch {
            print("Could not fetch. \(error)")
        }
        
        if fetched != nil {
            areasAndCrags = fetched!
        }
    }
    
}
