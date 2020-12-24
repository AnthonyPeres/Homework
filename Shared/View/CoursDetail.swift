//
//  CoursDetail.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct CoursDetail: View {
    
    var cour: Cours?
    
    init(cour: Cours? = nil) {
        self.cour = cour
    }
    
    var body: some View {
        #if canImport(UIKit)
        VStack {
            TachesList(type: .cour, cour: cour)
                .navigationBarTitle(cour?.intitule! ?? "Les tâches")
        }
        #elseif os(OSX)
        VStack(alignment: .leading) {
            Text(cour?.wrappedIntitule ?? "")
                .font(.title)
            
            TachesList(type: .cour, cour: cour)
        }
        .padding()
        #else
        #error("OS inconnu")
        #endif
    }
}

struct CoursDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        let newCours = Cours(context: context)
        newCours.intitule = "SwiftUI"
        
        #if canImport(UIKit)
        return NavigationView {
            CoursDetail(cour: newCours)
        }
        #elseif os(OSX)
        return CoursDetail(cour: newCours)
        #else
        #error("OS inconnu")
        #endif
        
    }
}
