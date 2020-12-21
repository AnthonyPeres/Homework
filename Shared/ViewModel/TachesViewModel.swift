//
//  TachesViewModel.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 04/12/2020.
//

import Foundation
import CoreData
import SwiftUI

class TachesViewModel: ObservableObject {
    @Published var intitule = ""
    @Published var notes = ""
    @Published var type = "Autre"
    @Published var termine = false
    @Published var addDate: Bool = false
    @Published var date = Date()
    @Published var addCour = false
    @Published var cour: Cours!
    @Published var isNewData = false
    @Published var updateData: Taches!
    
    func termine(context: NSManagedObjectContext, tache: Taches) {
        tache.termine.toggle()
        try! context.save()
    }
    
    func addTaches(context: NSManagedObjectContext) {
        if updateData != nil {
            updateData!.intitule = intitule
            updateData!.notes = notes
            updateData!.type = type
            updateData!.termine = termine
            updateData!.date = date
            updateData!.cour = cour
            try! context.save()
            clear()
        } else {
            let newData = Taches(context: context)
            newData.intitule = intitule
            newData.notes = notes
            newData.type = type
            newData.termine = termine
            if addDate { newData.date = date }
            if addCour { newData.cour = cour }
            do {
                try context.save()
                clear()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func editTaches(tache: Taches) {
        updateData = tache
        intitule = tache.intitule!
        notes = tache.notes!
        type = tache.type!
        termine = tache.termine
        if tache.date != nil { date = tache.date! }
        if tache.cour != nil { cour = tache.cour! }
        isNewData.toggle()
    }
    
    func deleteTaches(context: NSManagedObjectContext, offsets: IndexSet) {
        // Ici refaire la fonction deleteTaches.
        // Le context on va le prendre du persistence container ici, on aura plus besoin de le prendre en parametres
        // Voir https://www.youtube.com/watch?v=snXYiXUa1j8
    }
    
    func clear() {
        isNewData = false
        updateData = nil
        intitule = ""
        notes = ""
        type = "Autre"
        termine = false
        addDate = false
        date = Date()
        addCour = false
        cour = nil
    }
    
}
