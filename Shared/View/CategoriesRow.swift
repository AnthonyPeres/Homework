//
//  CategoriesRow.swift
//  Homework
//
//  Created by Anthony Peres da Cruz on 23/12/2020.
//

import SwiftUI

struct CategoriesRow: View {
    var name: String
    var image: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(.blue)
            
            Text(name)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("0")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 5)
    }
}

struct CategoriesRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesRow(name: "Tout", image: "tray.circle.fill")
            .previewLayout(.fixed(width: 250, height: 50))
    }
}
