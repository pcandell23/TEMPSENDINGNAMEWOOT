//
//  NearbyAreas.swift
//  SendAR
//
//  Created by Bennett Baker on 7/2/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//

import UIKit

class NearbyAreasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nearbyAreasTableView: UITableView!
    
    let areas: [Area] = []
    let crags: [Crag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AreaCell", bundle: nil)
        nearbyAreasTableView.register(nib, forCellReuseIdentifier: "AreaCell")
        let cragNib = UINib(nibName: "CragCell", bundle: nil)
        nearbyAreasTableView.register(cragNib, forCellReuseIdentifier: "CragCell")
        nearbyAreasTableView.delegate = self
        nearbyAreasTableView.dataSource = self
    
    }
    
    //TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count + crags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreaCell
        cell.areaName.text = areas[indexPath.row].getName()
        
        //add CragCell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO
        //for area cell and crag cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "NearbyAreasToArea", sender: cell)
        
        //add Crag Cell
    }
    
    func fetchAreas() {
        //TODO
    }
    
    func fetchCrags() {
        //TODO
    }
    
}
