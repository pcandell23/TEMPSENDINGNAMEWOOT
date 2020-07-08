//
//  Route.swift
//  SendAR
//
//  Created by Peter Candell on 7/7/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//
//
 
import Foundation
import CoreData
 
@objc(Route)
public class Route: NSManagedObject {
 
}
 
extension Route {
 
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }
 
    @NSManaged public var grade: String?
    @NSManaged public var height: Int64
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var type: String?
    @NSManaged public var crag: Area?
    
    // MARK: - Getters
           
    func getName() -> String {
        return name ?? ""
    }
       
    // These next functions do optional checking as I think it'll be easier to do it here so that we don't have any accidental errors in other places. May change.
    func getType() -> String {
        return type ?? ""
    }
       
    func getRating() -> Double{
            return rating
    }
       
    func getGrade() -> String{
        if grade != nil{
            return grade!
        } else {
            return ""
        }
    }
       
    func getCrag() -> Area?{
        if crag != nil{
            return crag!
        } else {
            return nil
        }
    }
    
    // MARK: - Setters
    // TODO: Add error handling and showing to these. As well as check to make sure the name (not racist, idk how we could do that but we can try), grade, and type are actual grades and types and that they match(this will also apply to the init function)
    func changeName(newName: String){
        self.name = newName
    }
    
    func changeRating(newRating: Double){
        self.rating = newRating
    }
       
    func changeGrade(newGrade: String){
        self.grade = newGrade
    }
       
    func changeCrag(newCrag: Crag){
        self.crag = newCrag
    }
}
