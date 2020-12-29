//
//  CoursList.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 21/12/2020.
//

import SwiftUI

struct CoursList: View {
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(fetchRequest: Cours.getCours()) var cours: FetchedResults<Cours>
    @ObservedObject var modelCours = CoursViewModel()
    
    var body: some View {
        
        #if canImport(UIKit)
        List {
            if cours.isEmpty {
                Text("Aucun cour")
            } else {
                ForEach(cours) { cour in
                    self.row(forCours: cour)
                }
                .onDelete(perform: deleteCours)
            }
        }
        .listStyle(PlainListStyle())
        
        
        
        #elseif os(OSX)
        List {
            if cours.isEmpty {
                Text("Aucun cour")
            } else {
                ForEach(cours) { cour in
                    self.row(forCours: cour)
                        .contextMenu(ContextMenu(menuItems: {
                            menu(forCours: cour)
                        }))
                }
            }
        }
        .listStyle(SidebarListStyle())
        .sheet(isPresented: $modelCours.isNewData, content: {
            CoursForm(modelCours: modelCours)
        })
        
        #else
        #error("Apple product error")
        #endif
    }
    
    
    private func row(forCours cour: Cours) -> some View {
        NavigationLink(
            destination: CoursDetail(cour: cour),
            label: {
                CoursRow(cour: cour)
            })
    }
    
    private func deleteCours(offsets: IndexSet) {
        withAnimation {
            offsets.map { cours[$0] }.forEach(context.delete)
            
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    #if os(OSX)
    private func menu(forCours cour: Cours) -> some View {
        VStack {
            Button(action: { modelCours.editCours(cour: cour) }, label: {
                Text("Modifier")
            })
            
            Button(action: {
                if let index = self.cours.firstIndex(of: cour) {
                    deleteCours(offsets: [index])
                }
            }, label: {
                Text("Supprimer")
            })
        }
    }
    #endif
}

struct CoursList_Previews: PreviewProvider {
    static var previews: some View {
        #if os(iOS)
        ForEach(["iPhone 11 Pro", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            NavigationView {
                CoursList()
                    .environment(\.managedObjectContext, CoreDataStack.preview.container.viewContext)
                    .previewDisplayName(deviceName)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
            }
        }
        
        #elseif os(OSX)
        CoursList()
            .environment(\.managedObjectContext, CoreDataStack.preview.container.viewContext)
        
        #else
        #endif
    }
}
