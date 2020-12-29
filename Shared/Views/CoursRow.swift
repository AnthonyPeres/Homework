//
//  CoursRow.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct CoursRow: View {
    var cour: Cours?
    var fetchRequest: FetchRequest<Taches>
    var taches: FetchedResults<Taches> {
        fetchRequest.wrappedValue
    }
    
    init(cour: Cours? = nil) {
        self.cour = cour
        fetchRequest = FetchRequest(fetchRequest: Taches.getTachesByCour(cour: cour), animation: .default)
    }
    
    var body: some View {
        HStack {
            #if os(iOS)
            Image(systemName: "book.circle.fill")
                .imageScale(.medium)
                .foregroundColor(.blue)
            #endif
            
            Text(cour?.wrappedIntitule ?? "")
            
            Spacer()
            
            Text(taches.count.description)
                .foregroundColor(.gray)
        }
    }
}

struct CoursRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        let newCours = Cours(context: context)
        newCours.intitule = "SwiftUI"
        
        return CoursRow(cour: newCours)
            .previewLayout(.fixed(width: 250, height: 50))
    }
}
