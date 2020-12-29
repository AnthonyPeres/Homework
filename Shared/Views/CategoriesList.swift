//
//  CategoriesList.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 22/12/2020.
//

import SwiftUI

struct CategoriesList: View {
    var body: some View {
        List {
            NavigationLink(
                destination: TachesList(type: .today).navigationTitle("Aujourd'hui"),
                label: {
                    CategoriesRow(name: "Aujourd'hui", image: "bookmark.circle.fill")
                })
            
            NavigationLink(
                destination: TachesList(type: .program).navigationTitle("Programmés"),
                label: {
                    CategoriesRow(name:"Programmés", image: "calendar.circle.fill")
                })
            
            NavigationLink(
                destination: TachesList(type: .devoir).navigationTitle("Devoirs"),
                label: {
                    CategoriesRow(name:"Devoirs", image: "doc.circle.fill")
                })
            
            NavigationLink(
                destination: TachesList(type: .tout).navigationTitle("Tout"),
                label: {
                    CategoriesRow(name:"Tout", image: "tray.circle.fill")
                })
        }
        
        .listStyle(style())
        .frame(height: size)
//        .navigationBarHidden(true)
    }
    
    private var size: CGFloat {
        get {
            #if canImport(UIKit)
            return 180
            #elseif os(OSX)
            return 135
            #else
            #error("OS inconnu")
            #endif
        }
    }
    
    private func style() -> some ListStyle {
        #if canImport(UIKit)
        return PlainListStyle()
        #elseif os(OSX)
        return SidebarListStyle()
        #else
        #error("OS inconnu")
        #endif
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        #if canImport(UIKit)
        CategoriesList()
            .previewLayout(.fixed(width: 350, height: 180))
        
        #elseif os(OSX)
        CategoriesList()
        #else
        #error("OS inconnu")
        #endif
    }
}
