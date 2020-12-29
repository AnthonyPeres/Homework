//
//  Cours.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 02/12/2020.
//
//

import Foundation
import CoreData

public class Cours: NSManagedObject {
    @NSManaged public var intitule: String?
    @NSManaged public var taches: NSSet?
    
    public var wrappedIntitule: String {
        intitule ?? "Intitulé null"
    }
    
    public var tachesArray: [Taches] {
        let set = taches as? Set<Taches> ?? []
        return set.sorted {
            $0.wrappedIntitule < $1.wrappedIntitule
        }
    }
}

// MARK: FetchRequests
extension Cours {
    static func getCours() -> NSFetchRequest<Cours> {
        let request = Cours.fetchRequest() as! NSFetchRequest<Cours>
        request.sortDescriptors = [NSSortDescriptor(key: "intitule", ascending: true)] 
        return request
    }
}

extension Cours: Identifiable {
    public var id: String {
        wrappedIntitule
    }
}

// MARK: Accessors for taches
extension Cours {

    @objc(addTachesObject:)
    @NSManaged public func addToTaches(_ value: Taches)

    @objc(removeTachesObject:)
    @NSManaged public func removeFromTaches(_ value: Taches)

    @objc(addTaches:)
    @NSManaged public func addToTaches(_ values: NSSet)

    @objc(removeTaches:)
    @NSManaged public func removeFromTaches(_ values: NSSet)

}
