//
//  CoursViewModel.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 03/12/2020.
//

import Foundation
import CoreData
import WidgetKit

class CoursViewModel: ObservableObject {
    @Published var intitule = ""
    @Published var isNewData = false
    @Published var updateData: Cours!
    
    func addCours(context: NSManagedObjectContext) {
        if updateData != nil {
            updateData!.intitule = intitule
            try! context.save()
            
            // Widget kit
            WidgetCenter.shared.reloadAllTimelines()
            clear()
        } else {
            let newData = Cours(context: context)
            newData.intitule = intitule
            do {
                try context.save()
                WidgetCenter.shared.reloadAllTimelines()
                clear()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteCours(context: NSManagedObjectContext, cour: Cours) {
        do {
            context.delete(cour)
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func editCours(cour: Cours) {
        updateData = cour
        intitule = cour.intitule!
        isNewData.toggle()
    }
 
    func clear() {
        updateData = nil
        isNewData = false
        intitule = ""
    }
    
}
