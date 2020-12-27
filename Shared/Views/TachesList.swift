//
//  TachesList.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct TachesList: View {
    
    // MARK: - TODO : NETTOYER LE CODE ET IMPLEMENTER LA MODIFICATION D'UNE TACHE
    
    
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var modelTaches = TachesViewModel()
    @ObservedObject var modelCours = CoursViewModel()
    
    var cour: Cours?
    var fetchRequest: FetchRequest<Taches>
    var taches: FetchedResults<Taches> {
        fetchRequest.wrappedValue
    }
    
    enum TypeList {
        case cour
        case today
        case program
        case devoir
        case tout
    }
    
    init(type: TypeList, cour: Cours? = nil) {
        switch type {
        case .cour:
            self.cour = cour
            fetchRequest = FetchRequest(fetchRequest: Taches.getTachesByCour(cour: cour), animation: .default)
        case .today:
            fetchRequest = FetchRequest(fetchRequest: Taches.getTachesOfToday(), animation: .default)
        case .program:
            fetchRequest = FetchRequest(fetchRequest: Taches.getTachesScheduled(), animation: .default)
        case .devoir:
            fetchRequest = FetchRequest(fetchRequest: Taches.getTachesTypeDevoir(), animation: .default)
        default:
            fetchRequest = FetchRequest(fetchRequest: Taches.getTaches(), animation: .default)
        }
    }
    
    
    var body: some View {
        #if canImport(UIKit)
        VStack(alignment: .leading) {
            List {
                if taches.isEmpty {
                    Text("Aucune tâche")
                } else {
                    ForEach(taches) { tache in
                        row(forTaches: tache)
                    }
                    .onDelete(perform: deleteTaches)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: menu())
            .sheet(isPresented: $modelCours.isNewData) {
                CoursForm(modelCours: modelCours)
                    .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    if cour != nil {
                        modelTaches.addCour = true
                        modelTaches.cour = cour!
                    }
                    modelTaches.isNewData.toggle()
                }, label: {
                    Label("Ajouter une tâche", systemImage: "plus")
                })
                .padding(.horizontal)
            }
            .sheet(isPresented: $modelTaches.isNewData, content: {
                TachesForm(modelTaches: modelTaches)
                    .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
            })
        }
        #elseif os(OSX)
        VStack(alignment: .leading) {
            List {
                if taches.isEmpty {
                    Text("Aucune tâche")
                } else {
                    ForEach(taches) { tache in
                        row(forTaches: tache)
                            .contextMenu(ContextMenu(menuItems: { HStack {
                                Button(action: {}, label: {
                                    Text("Modifier")
                                })
                                
                                Button(action: {
                                    if let index = self.taches.firstIndex(of: tache) {
                                        deleteTaches(offsets: [index])
                                    }
                                }, label: {
                                    Text("Supprimer")
                                })
                            } }))
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
        #else
        #error("OS inconnu")
        #endif
    }
    
    /**
     Affiche une CoursRow redirigeant vers un CoursDetail pour un cour passé en paramètre.
     - parameter cour: Le cours a afficher.
    */
    private func row(forTaches tache: Taches) -> some View {
        TachesRow(tache: tache)
    }
    
    #if canImport(UIKit)
    private func menu() -> some View {
        return Menu {
            if cour != nil {
                Button(action: { modelCours.editCours(cour: self.cour!) }, label: {
                        Text("Modifier le cour")
                })
                
                Button(action: { modelCours.deleteCours(context: context, cour: self.cour!) }, label: {
                        Text("Supprimer le cour")
                })
                
                Divider()
            }
        
            EditButton()
        
        } label: {
            Label("", systemImage: "rectangle.and.pencil.and.ellipsis")
        }
    }
    #endif
    
    private func deleteTaches(offsets: IndexSet) {
        withAnimation {
            offsets.map { taches[$0] }.forEach(context.delete)

            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TachesList_Previews: PreviewProvider {
    static var previews: some View {
        TachesList(type: .tout, cour: nil)
            .environment(\.managedObjectContext, CoreDataStack.preview.container.viewContext)
    }
}
