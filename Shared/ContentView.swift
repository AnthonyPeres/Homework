//
//  ContentView.swift
//  Shared
//
//  Created by Anthony Peres da Cruz on 21/12/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Cours.getCours()) var cours: FetchedResults<Cours>
    @ObservedObject var modelCours = CoursViewModel()
    @ObservedObject var modelTaches = TachesViewModel()
    
    var body: some View {
        #if canImport(UIKit)
        NavigationView {
            VStack {
//                CategoriesList()
                CoursList()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        modelTaches.isNewData.toggle()
                    }) {
                        Label("Tâche", systemImage: "plus")
                            .font(.system(size: 18, weight: .medium, design: .default))
                    }
                    .sheet(isPresented: $modelTaches.isNewData, content: {
//                        TachesForm(modelTaches: modelTaches)
//                            .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        modelCours.isNewData.toggle()
                    } ) {
                        Text("Ajouter un cour")
                    }
                    .sheet(isPresented: $modelCours.isNewData, content: {
                        CoursForm(modelCours: modelCours)
                            .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
                    })
                }
                .padding(.horizontal)
            }
        }
        #elseif os(OSX)
        NavigationView {
            VStack {
                CoursList()
                Spacer()
                
                HStack {
                    Button(action: { modelCours.isNewData.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .padding()
                    .sheet(isPresented: $modelCours.isNewData, content: {
                        CoursForm(modelCours: modelCours)
                            .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
                    })
                    Spacer()
                }
            }
            .frame(minWidth: 180, maxWidth: 300, maxHeight: .infinity)
        }
        .toolbar(content: {
            Button(action: { modelTaches.isNewData.toggle() }, label: {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $modelTaches.isNewData, content: {
//                TachesForm(modelTaches: modelTaches)
//                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            })
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    toggleSidebar()
                }, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        })
        #else
        #error("Erreur")
        #endif
    }

    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataStack.preview.container.viewContext)
    }
}
