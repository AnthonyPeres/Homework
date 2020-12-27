//
//  CoursForm.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 21/12/2020.
//

import SwiftUI

struct CoursForm: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var modelCours = CoursViewModel()
    
    var body: some View {
        #if canImport(UIKit)
        NavigationView {
            Form {
                HStack{
                    Text("Nom :")
                    TextField(NSLocalizedString("Entrer le nom du cour ici", comment: "Textfield placeholder"), text: $modelCours.intitule)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                HStack {
                    Button(action: { modelCours.addCours(context: context) }, label: {
                        Text(modelCours.updateData == nil ? "Ajouter un cour" : "Modifier un cour")
                    })
                    .padding(10)
                    .disabled(modelCours.intitule == "")
                }
            }
            .navigationBarItems(leading: Button(action: {
                modelCours.isNewData.toggle()
                modelCours.updateData = nil
            }) {
                Text("Annuler")
            })
            .navigationBarTitle(modelCours.updateData == nil ? "Ajouter un cour" : "Modifier un cour")
        }
        #elseif os(OSX)
        form()
            .frame(width: 350, height: 100)
            .padding()
            .toolbar(content: {
                menu()
            })
        #else
        #endif
        
    }
    
    private func form() -> some View {
        Form {
            #if os(OSX)
            Text(modelCours.updateData == nil ? "Ajouter un cour" : "Modifier un cour")
                .font(.title)
            #endif
            
            HStack {
                Text("Nom :")
                TextField("Entrez le nom du cour ici", text: $modelCours.intitule)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical)
            }
        }
    }
    
    private func menu() -> some View {
        HStack {
            Button(action: {
                    modelCours.addCours(context: context)
            }, label: {
                Text(modelCours.updateData == nil ? "Ajouter un cour" : "Modifier un cour")
            })
            .disabled(modelCours.intitule == "")
            
            #if os(OSX)
            Button(action: {
                modelCours.isNewData.toggle()
                modelCours.updateData = nil
            }, label: {
                Text("Annuler")
            })
            #endif

        }
    }
}

struct CoursForm_Previews: PreviewProvider {
    static var previews: some View {
        CoursForm()
    }
}
