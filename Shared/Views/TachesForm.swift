//
//  TachesForm.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct TachesForm: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var modelTaches = TachesViewModel()
    @FetchRequest(fetchRequest: Cours.getCours()) var cours: FetchedResults<Cours>
    let types = ["Revision", "Devoir", "Autre"]
    var title: String {
        get {
            modelTaches.updateData == nil ? "Ajouter une tâche" : "Modifier une tâche"
        }
    }
    var submit: String {
        get {
            modelTaches.updateData == nil ? "Ajouter la tâche" : "Modifier la tâche"
        }
    }
    
    var body: some View {
        #if canImport(UIKit)
        NavigationView {
            form()
                .navigationBarItems(leading: Button(action: {
                    modelTaches.clear()
                }, label: {
                    Text("Annuler")
                }))
                .navigationTitle(title)
        }
        
        #elseif os(OSX)
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .padding(.vertical)
            
            form()
                .padding(10)
                .frame(width: 450, height: 350)
                .toolbar(content: { menu() })
        }
        #else
        #error("OS inconnu")
        #endif
    }
    
    private func form() -> some View {
        Form {
            Section(header: Text("Informations générales")) {
                HStack {
                    Text("Intitule : ")
                    TextField(NSLocalizedString("Entrer l'intitulé de la tâche ici", comment: "Textfield placeholder"), text: $modelTaches.intitule)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                
                HStack {
                    Text("Notes :")
                    TextField(NSLocalizedString("Notes", comment: "Textfield placeholder"), text: $modelTaches.notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
            }
            
            Section(header: Text("Informations complémentaires")) {
                Toggle(isOn: $modelTaches.addDate, label: {
                    Text("Ajouter une date")
                })
                if modelTaches.addDate {
                    DatePicker(selection: $modelTaches.date, label: { Text("Date") })
                        .labelsHidden()
                }
                
                Toggle(isOn: $modelTaches.addCour, label: {
                    Text("\(modelTaches.cour == nil ? "Ajouter un cour" : "Cour selectionné : \(modelTaches.cour.wrappedIntitule)")")
                })
                if modelTaches.addCour {
                    List(cours) { cour in
                        Button(action: { modelTaches.cour = cour }, label: {
                            Text(cour.wrappedIntitule)
                        })
                    }
                }
            }
            
            Section(header: Text("Type de tâche")) {
                Picker("Type de tâche", selection: $modelTaches.type) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
            }
            
            #if canImport(UIKit)
            HStack {
                Button(action: {
                    modelTaches.addTaches(context: context)
                }, label: {
                    Text(submit)
                })
                .padding(10)
                .disabled(modelTaches.intitule == "")
            }
            #endif
            
        }
    }
    
    private func menu() -> some View {
        HStack {
            Button(action: {
                modelTaches.addTaches(context: context)
            }, label: {
                Text(submit)
            })
            .disabled(modelTaches.intitule == "")
            
            Button(action: {
                modelTaches.clear()
            }, label: {
                Text("Annuler")
            })
        }
    }
}

struct TachesForm_Previews: PreviewProvider {
    static var previews: some View {
        TachesForm()
    }
}
