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
    var cour: Cours?
    
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

//struct HomeworkWidgetPlaceholderView: View {
//    var body: some View {
//        Color(UIColor.systemGray)
//    }
//}


// MARK: - SMALL

struct HomeworkSmallView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours?
    
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            
            if cour != nil {
                VStack(alignment: .leading) {
                    HStack {
                        Label("", systemImage: "tray.circle.fill")
                            .font(.system(size: 27))
                            .foregroundColor(Color("titleColor"))
                        
                        Spacer()
                        
                        Text(String(cour!.tachesArray.count))
                            .fontWeight(.heavy)
                            .font(.system(size: 27))
                            .foregroundColor(Color("textColor"))
                    }
                    
                    Text(cour!.wrappedIntitule)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundColor(Color("titleColor"))
                    
                    Spacer()
                    
                    TachesList(cour: cour, nbTaches: 3)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 10)
            } else {
                Text("Aucun cour")
            }
            
            
        }
    }
}

struct HomeworkSmallView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        
        let cour = Cours(context: context)
        cour.intitule = "SwiftUI"
        
        for i in 1...3 {
            let tache = Taches(context: context)
            tache.intitule = "Tache \(i)"
            cour.addToTaches(tache)
        }
        
        try? context.save()
        
        return Group {
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context)
                .redacted(reason: .placeholder)
            
        }
    }
}

// MARK: - MEDIUM

struct HomeworkMediumView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours?
    
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            
            if cour != nil {
                HStack {
                    VStack(alignment: .leading) {
                        Label("", systemImage: "tray.circle.fill")
                            .font(.system(size: 27))
                            .foregroundColor(Color("titleColor"))
                        
                        Spacer()
                        
                        Text(String(cour!.tachesArray.count))
                            .fontWeight(.heavy)
                            .font(.system(size: 27))
                            .foregroundColor(Color("textColor"))
                        
                        Text(cour!.wrappedIntitule)
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                            .foregroundColor(Color("titleColor"))
                        
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .frame(width: 90)
                    
                    TachesList(cour: cour, nbTaches: 5)
                }
            } else {
                Text("Aucun cour")
            }
            
            
            
        }
    }
}

struct HomeworkMediumView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        
        let cour = Cours(context: context)
        cour.intitule = "Université"
        
        for i in 0..<10 {
            let tache = Taches(context: context)
            tache.intitule = "Tache \(i)"
            cour.addToTaches(tache)
        }
        
        try? context.save()
        
        return Group {
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context)
                .redacted(reason: .placeholder)
        }
    }
}


// MARK: - LARGE

struct HomeworkLargeView: View {
    
    @Environment(\.managedObjectContext) private var context
    var cour: Cours?
    
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            
            if cour != nil {
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(String(cour!.tachesArray.count))
                            .fontWeight(.heavy)
                            .font(.system(size: 27))
                            .foregroundColor(Color("textColor"))
                        
                        Spacer()
                        
                        Label("", systemImage: "tray.circle.fill")
                            .font(.system(size: 27))
                            .foregroundColor(Color("titleColor"))
                    }
                    
                    Text(cour!.wrappedIntitule)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundColor(Color("titleColor"))
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                        .edgesIgnoringSafeArea(.horizontal)
                    
                    
                    
                    TachesList(cour: cour, nbTaches: 9)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 10)
            } else {
                Text("Aucun cour")
            }
            
            
            
        }
    }
}

struct HomeworkLargeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.container.viewContext
        
        let cour = Cours(context: context)
        cour.intitule = "SwiftUI"
        
        for i in 0..<10 {
            let tache = Taches(context: context)
            tache.intitule = "Tache \(i)"
            cour.addToTaches(tache)
        }
        
        try? context.save()
        
        return Group {
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            
            HomeworkWidgetView(cour: cour)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context)
                .redacted(reason: .placeholder)
        }
    }
}
