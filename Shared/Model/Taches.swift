//
//  Taches.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 02/12/2020.
//
//

import Foundation
import CoreData

public class Taches: NSManagedObject, Identifiable {
    @NSManaged public var intitule: String?
    @NSManaged public var notes: String?
    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var termine: Bool
    @NSManaged public var cour: Cours?
    @NSManaged public var tachesfilles: NSSet?
    @NSManaged public var tachemere: Taches?
    
    public var wrappedIntitule: String {
        intitule ?? "Intitulé null"
    }
    
    public var readableDate: String {
        if date != nil {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date!)
            let month = calendar.component(.month, from: date!)
            let year = calendar.component(.year, from: date!)
            let hour = calendar.component(.hour, from: date!)
            let minute = calendar.component(.minute, from: date!)
            
            return String("\(day < 10 ? "0\(day)" : "\(day)")/\(month < 10 ? "0\(month)" : "\(month)")/\(year) \(hour < 10 ? "0\(hour)" : "\(hour)"):\(minute < 10 ? "0\(minute)" : "\(minute)")")
        }
        return ""
    }
}

// MARK: FetcheRequests
extension Taches {
    static func getTaches() -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        return request
    }
    
    static func getTachesByCour(cour: Cours?) -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        request.predicate = NSPredicate(format: "cour = %@", cour ?? NSNull())
        return request
    }
    
    static func getTachesByTache(tache: Taches?) -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        request.predicate = NSPredicate(format: "tachemere = %@", tache ?? NSNull())
        return request
    }
    
    // MARK: TODO : Refaire cette fonction.
    static func getTachesOfToday() -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        return request
    }
    
    static func getTachesScheduled() -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        request.predicate = NSPredicate(format: "date != nil")
        return request
    }
    
    static func getTachesTypeDevoir() -> NSFetchRequest<Taches> {
        let request = Taches.fetchRequest() as! NSFetchRequest<Taches>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)]
        request.predicate = NSPredicate(format: "type = %@", "Devoir")
        return request
    }
}

// MARK: Accessors for tachesfilles
extension Taches {

    @objc(addTachesfillesObject:)
    @NSManaged public func addToTachesfilles(_ value: Taches)

    @objc(removeTachesfillesObject:)
    @NSManaged public func removeFromTachesfilles(_ value: Taches)

    @objc(addTachesfilles:)
    @NSManaged public func addToTachesfilles(_ values: NSSet)

    @objc(removeTachesfilles:)
    @NSManaged public func removeFromTachesfilles(_ values: NSSet)

}
