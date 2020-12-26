//
//  HomeworkWidget.swift
//  HomeworkWidget
//
//  Created by Anthony Peres da Cruz on 24/12/2020.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

// MARK: - CONFIGURATION

struct Provider: IntentTimelineProvider {
    
    private func fetchCour() -> Cours? {
        let context = CoreDataStack.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Cours.entity()
        if let results = try? context.fetch(fetchRequest) as? [Cours] {
            return results.first
        } else {
            return nil
        }
    }
    
    private func fetchTaches() -> [Taches]? {
        let context = CoreDataStack.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Taches.entity()
        fetchRequest.predicate = NSPredicate(format: "cour = %@", fetchCour() ?? NSNull())
        if let results = try? context.fetch(fetchRequest) as? [Taches] {
            return results
        } else {
            return nil
        }
    }
    
    // When WidgetKit displays your widget for the first time, it renders the widget’s view as a placeholder. A placeholder view displays a generic representation of your widget, giving the user a general idea of what the widget shows
    func placeholder(in context: Context) -> HomeworkEntry {
        //        if context.isPreview && !hasFetchedGameStatus {
        //            entry = GameStatusEntry(date: date, gameStatus: "—")
        //        } else {
        //            entry = GameStatusEntry(date: date, gameStatus: gameStatusFromServer)
        //        }
        
        HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: fetchCour(), taches: fetchTaches())
    }

    //    For configurable widgets, the provider conforms to IntentTimelineProvider. This provider performs the same functions as TimelineProvider, but it incorporates the values that users customize on the widget. You typically include the user-configured values as properties of your custom timeline entry type, so the details are available to the widget’s view.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (HomeworkEntry) -> ()) {
        let entry = HomeworkEntry(date: Date(), configuration: configuration, cour: fetchCour(), taches: fetchTaches())
        completion(entry)
    }
    
    //    For configurable widgets, the provider conforms to IntentTimelineProvider. This provider performs the same functions as TimelineProvider, but it incorporates the values that users customize on the widget. You typically include the user-configured values as properties of your custom timeline entry type, so the details are available to the widget’s view.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<HomeworkEntry>) -> ()) {
        let entries: [HomeworkEntry] = [HomeworkEntry(date: Date(), configuration: configuration, cour: fetchCour(), taches: fetchTaches())]
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HomeworkEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let cour: Cours?
    let taches: [Taches]?
}




// MARK: - VUES

@main
struct HomeworkWidget: Widget {
    /// Identifiant unique qui représente le widget
    let kind: String = "HomeworkWidget"
    
    var body: some WidgetConfiguration {
        /// Intention personnalisée : Une intention personnalisée qui définit les propriétés configurables par l'utilisateur
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HomeworkWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}




struct HomeworkWidget_Previews: PreviewProvider {
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
            
            HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)
            
            HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            
            HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
            
            HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            HomeworkWidgetView(entry: HomeworkEntry(date: Date(), configuration: ConfigurationIntent(), cour: cour, taches: taches))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
