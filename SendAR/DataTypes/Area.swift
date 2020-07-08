
//
//  Area.swift
//  SendAR
//
//  Created by Peter Candell on 7/7/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//
//
 
import Foundation
import CoreData
 
@objc(Area)
public class Area: NSManagedObject {
 
}
 
extension Area {
 
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Area> {
        return NSFetchRequest<Area>(entityName: "Area")
    }
    
    //Attributes
    @NSManaged public var name: String?
    @NSManaged public var fenceLatitude: String?
    @NSManaged public var fenceLongitude: String?
    @NSManaged public var fenceRadius: Int64
    
    //Relationships
    @NSManaged public var subAreas: [Area]?
    @NSManaged public var superArea: Area?
    
    //Area needs a location variable or a lat/long variable
    
    // MARK: - Getter Functions
    func getName() -> String{
        return name ?? ""
    }
    
    func getSuperArea() -> Area? {
        return superArea
    }
    
    func getSubArea() -> [Area] {
        return subAreas ?? [Area]()
    }
    
    func getFenceLatitude() -> String {
        return fenceLatitude ?? ""
    }
    
    func getFenceLongitude() -> String {
        return fenceLongitude ?? ""
    }
    
    func getFenceRadius() -> Int64 {
        return fenceRadius
    }
    
    // TODO: Fix this to return the correct format for needs.
    func getFenceCorrdinates() -> String {
        return ""
    }
    
    func subAreaIsEmpty() -> Bool {
        if subAreas != nil {
            return subAreas!.isEmpty
        } else {
            return true
        }
    }
    
    func subAreaCount() -> Int {
        if subAreas != nil {
            return subAreas!.count
        } else {
            return 0
        }
    }
    
    // MARK: - Setter Functions
    
    // TODO: Will probably make these all return Bools that return if it succedded or not but for now not gonna worry about it. Might be do catch loops idk the right way in swift that will show the user it failed. Probs both tbh
    
    func setName(newName: String){
        self.name = newName
    }
    
    func setSuperArea(newSuperArea: Area){
        self.superArea = newSuperArea
    }
    
    func setFenceLatitude(newFenceLatitude: String){
        self.fenceLatitude = newFenceLatitude
    }
    
    func setFenceLongitude(newFenceLongitude: String){
        self.fenceLongitude = newFenceLongitude
    }
    
    func setFenceRadius(newFenceRadius: Int64){
        self.fenceRadius = newFenceRadius 
    }
 
 
// MARK: Generated accessors for subAreas
    @objc(addSubAreasObject:)
    @NSManaged public func addToSubAreas(_ value: Area)
 
    @objc(removeSubAreasObject:)
    @NSManaged public func removeFromSubAreas(_ value: Area)
 
    @objc(addSubAreas:)
    @NSManaged public func addToSubAreas(_ values: [Area])
 
    @objc(removeSubAreas:)
    @NSManaged public func removeFromSubAreas(_ values: [Area])
 
}

