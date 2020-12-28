//
//  IntentHandler.swift
//  Homework Intent
//
//  Created by Anthony Peres da Cruz on 26/12/2020.
//

import Intents
import CoreData
import SwiftUI

class IntentHandler: INExtension, SelectCourIntentHandling {
    
    let context = CoreDataStack.shared.container.viewContext
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
    func provideCourOptionsCollection(
        for intent: SelectCourIntent,
        with completion: @escaping (INObjectCollection<CourINO>?, Error?) -> Void
    ) {
        var courItems = [CourINO]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Cours.entity()
        
        let cours = try! context.fetch(fetchRequest) as! [Cours]
        if !cours.isEmpty {
            for cour in cours {
                let courINO = CourINO(identifier: cour.id, display: cour.wrappedIntitule)
                courItems.append(courINO)
            }
        }
        
        completion(INObjectCollection(items: courItems), nil)
    }
    
}
