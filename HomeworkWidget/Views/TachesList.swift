//
//  TachesList.swift
//  HomeworkWidgetExtension
//
//  Created by Anthony Peres da Cruz on 27/12/2020.
//

import SwiftUI
import WidgetKit

struct TachesList: View {
    let context = CoreDataStack.shared.container.viewContext
    var cour: Cours?
    var fetchRequest: FetchRequest<Taches>
    var taches: FetchedResults<Taches> {
        fetchRequest.wrappedValue
    }
    var nombreTaches: Int
    
    init(cour: Cours? = nil, nbTaches: Int = 0) {
        fetchRequest = FetchRequest(fetchRequest: Taches.getTachesByCour(cour: cour), animation: .default)
        nombreTaches = nbTaches
    }
     
    var body: some View {
        VStack(alignment: .leading) {
            
            if taches.isEmpty {
                Text("Aucune tâche")
            } else {
                ForEach(0..<nombreTaches) { i in
                    if taches.count >= i {
                        Text(taches[i].wrappedIntitule)
                    } else {
                        Text("")
                    }
                }
            }
            
        }
    }
}

struct TachesList_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        let newCours = Cours(context: context)
        newCours.intitule = "SwiftUI"
        
        return TachesList(cour: newCours, nbTaches: 3)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
