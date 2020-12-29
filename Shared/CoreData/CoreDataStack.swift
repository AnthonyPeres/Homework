//
//  CoreDataStack.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 21/12/2020.
//

import CoreData

extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

struct CoreDataStack {
    static let shared = CoreDataStack()
    
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "Homework")
        
        if inMemory {
            container.persistentStoreDescriptions = [.init(url: URL(fileURLWithPath: "/dev/null"))]
        } else {
            container.persistentStoreDescriptions = [.init(url: .storeURL(for: "group.Anthony.PeresdaCruz.Homework", databaseName: "primary"))]
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    let container: NSPersistentContainer
    
    static var preview: CoreDataStack = {
        let result = CoreDataStack(inMemory: true)
        let viewContext = result.container.viewContext
        
        let cour1 = Cours(context: viewContext)
        cour1.intitule = "ASI Mobile 2"
        
        let cour2 = Cours(context: viewContext)
        cour2.intitule = "Audit des SI"
        
        let cour3 = Cours(context: viewContext)
        cour3.intitule = "Gestion de projets"
        
        let cour4 = Cours(context: viewContext)
        cour4.intitule = "Outils BI"
        
        let tache1 = Taches(context: viewContext)
        tache1.intitule = "Tache 1"
        tache1.notes = "Notes de la tâche 1"
        tache1.date = Date()
        tache1.type = "Autre"
        tache1.termine = false
        
        let tache2 = Taches(context: viewContext)
        tache2.intitule = "Tache 2"
        tache2.notes = "Notes de la tâche 2"
        tache2.date = Date()
        tache2.type = "Revision"
        tache2.termine = true
        
        cour1.addToTaches(tache1)
        cour2.addToTaches(tache2)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
