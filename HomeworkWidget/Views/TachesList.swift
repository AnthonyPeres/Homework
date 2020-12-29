//
//  TachesList.swift
//  HomeworkWidgetExtension
//
//  Created by Anthony Peres da Cruz on 27/12/2020.
//

import SwiftUI
import WidgetKit

struct TachesList: View {
    @Environment(\.managedObjectContext) private var context
    
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
                    .font(.system(size: 12))
            } else {
                ForEach(0..<nombreTaches) { i in
                    if i < taches.count {
                        Text(taches[i].wrappedIntitule)
                            .foregroundColor(Color("textColor"))
                            .font(.system(size: 11))
                    } else {
                        Text("")
                    }
                    
                    if (i + 1) != nombreTaches {
                        Divider()
                    }
                }
            }
            
        }
    }
}

struct TachesList_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        
        let cour = Cours(context: context)
        cour.intitule = "SwiftUI"
        
        for i in 0..<10 {
            let tache = Taches(context: context)
            tache.intitule = "Tache \(i)"
            cour.addToTaches(tache)
        }
        
        try? context.save()
        
        return Group {
            TachesList(cour: cour, nbTaches: 3)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
            
            TachesList(cour: cour, nbTaches: 5)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
            
            TachesList(cour: cour, nbTaches: 9)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
        }
    }
}
