//
//  TachesRow.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct TachesRow: View {
    
    var tache: Taches
    @ObservedObject var modelTaches = TachesViewModel()
    
    var body: some View {
        HStack(alignment: .top) {
            TacheStatut(modelTaches: modelTaches, tache: tache)
            TacheDetail(modelTaches: modelTaches, tache: tache)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct TacheStatut: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var modelTaches = TachesViewModel()
    var tache: Taches
    
    var body: some View {
        Button(action: {
            modelTaches.termine(context: context, tache: tache)
        }, label: {
            Image(systemName: tache.termine ? "circle.fill" : "circle")
                .foregroundColor(.orange)
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct TacheDetail: View {
    @ObservedObject var modelTaches = TachesViewModel()
    var tache: Taches
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(tache.wrappedIntitule)
            
            if tache.date != nil {
                Text(tache.readableDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if tache.notes != nil && tache.notes != "" {
                Text(tache.notes!)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(tache.type!)
                .font(.subheadline)
                .foregroundColor(.orange)
        }
        .onTapGesture {
            modelTaches.editTaches(tache: tache)
        }
        .sheet(isPresented: $modelTaches.isNewData, content: {
            TachesForm(modelTaches: modelTaches)
                .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
        })
    }
}

struct TachesRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        
        let tache1 = Taches(context: context)
        tache1.intitule = "Faire le TD3"
        tache1.termine = true
        tache1.date = Date()
        tache1.notes = "Il faut faire l'étape 4 du TD3 et l'étape 2 du 4 et blabla bla bla"
        tache1.type = "Révisions"
        
        return TachesRow(tache: tache1)
            .previewLayout(.fixed(width: 360, height: 100))
    }
}
