//
//  HomeworkWidgetView.swift
//  HomeworkWidgetExtension
//
//  Created by Anthony Peres da Cruz on 26/12/2020.
//

import SwiftUI
import WidgetKit
import CoreData


struct HomeworkWidgetView : View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.widgetFamily) var widgetFamily
    var cour: Cours
    
    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall: HomeworkSmallView(cour: cour)
        case .systemMedium: HomeworkMediumView(cour: cour)
        case .systemLarge: HomeworkLargeView(cour: cour)
        default: Text("WidgetFamily inconnue")
        }
    }
}

struct HomeworkWidgetPlaceholderView: View {
    var body: some View {
        Color(UIColor.systemGray)
    }
}

struct HomeworkSmallView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours
    
    var body: some View {
        VStack {
            Text("Cour selectionné : \(cour.wrappedIntitule).")
            TachesList(cour: cour, nbTaches: 3)
        }
    }
}

struct HomeworkMediumView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours
    
    var body: some View {
        Text("Cour selectionné : \(cour.wrappedIntitule).")
    }
}

struct HomeworkLargeView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours
    
    var body: some View {
        Text("Cour selectionné : \(cour.wrappedIntitule).")
    }
}

struct HomeworkWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        let cour = Cours(context: context)
        cour.intitule = "SwiftUI"
        
        let tache = Taches(context: context)
        tache.intitule = "Tache1"
        
        cour.addToTaches(tache)
        
        try? context.save()
        
        return Group {
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
            
        }
    }
}
