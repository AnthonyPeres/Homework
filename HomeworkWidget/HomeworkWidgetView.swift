//
//  HomeworkWidgetView.swift
//  HomeworkWidgetExtension
//
//  Created by Anthony Peres da Cruz on 26/12/2020.
//

import SwiftUI
import WidgetKit

struct HomeworkWidgetView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall: NormalView(entry: entry)
        case .systemMedium: NormalView(entry: entry)
        case .systemLarge: NormalView(entry: entry)
        default: Text("WidgetFamily inconnue")
        }
    }
}

struct NormalView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            VStack(alignment: .leading) {
                HStack {
                    Text(entry.cour?.wrappedIntitule ?? "")
                        .bold()
                        // .unredacted()
                        .foregroundColor(Color("textColor"))
                        .padding(.all, 5)
                    
                    Spacer()
                    
                    Text("3")
                        .foregroundColor(Color("textColor"))
                    
                    Label("", systemImage: "tray.circle.fill")
                        .foregroundColor(Color("textColor"))
                    
                }
                .cornerRadius(15)
                .background(ContainerRelativeShape().fill(Color.white))
                
                Spacer()
                
                TachesList(size: 3, entry: entry)
                
                Spacer()
            }
            .padding()
        }
    }
}


struct TachesList: View {
    var size: Int
    var entry: Provider.Entry
    
    var body: some View {
        if entry.taches != nil {
            ForEach(0..<size) { i in
                if i < entry.taches!.count {
                    Text(entry.taches![i].wrappedIntitule)
                } else {
                    Text("")
                }
                
                if (i + 1) != size {
                    Divider()
                }
            }
        }
    }
}

struct HomeworkWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        let cour = Cours(context: context)
        cour.intitule = "SwiftUI"
        
        var taches: [Taches] = []
        for i in 0..<10 {
            let newTache = Taches(context: context)
            newTache.intitule = "Nouvelle tâche \(i)"
            taches.append(newTache)
        }
        
        try? context.save()
        
        return Group {
        HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
