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

struct CustomHomeworkWidgetProvider: IntentTimelineProvider {
    typealias Entry = CustomCourEntry
    typealias Intent = SelectCourIntent
    
    ///
    func placeholder(in context: Context) -> CustomCourEntry {
        let context = CoreDataStack.preview.container.viewContext
        let cour = Cours(context: context)
        cour.intitule = "Cour"
        return CustomCourEntry(date: Date(), cour: cour)
    }
    
    ///
    func getSnapshot(
        for configuration: SelectCourIntent,
        in context: Context,
        completion: @escaping (CustomCourEntry) -> Void
    ) {
        if context.isPreview {
            let context = CoreDataStack.preview.container.viewContext
            let cour = Cours(context: context)
            cour.intitule = "Cour"
            completion(CustomCourEntry(date: Date(), cour: cour))
            return
        }
        
        let cour = lookupCourDetail(for: configuration)
        let entry = CustomCourEntry(date: Date(), cour: cour)
        completion(entry)
    }
    
    ///
    func getTimeline(
        for configuration: SelectCourIntent,
        in context: Context,
        completion: @escaping (Timeline<CustomCourEntry>) -> Void
    ) {
        var entries = [CustomCourEntry]()
        let cour = lookupCourDetail(for: configuration)
        let entry = CustomCourEntry(date: Date(), cour: cour)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    ///
    private func lookupCourDetail(for configuration: SelectCourIntent) -> Cours {
        let context = CoreDataStack.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Cours.entity()

        let cours = try! context.fetch(fetchRequest) as! [Cours]
        
        guard let courId = configuration.cour?.identifier,
              let courForConfig = cours.first(where: { cour in
                cour.id == courId
              })
        else {
            return cours.first!
        }
        return courForConfig
    }
}


///
struct CustomCourEntry: TimelineEntry {
    let date: Date
    let cour: Cours
}

///
struct CustomHomeworkEntryView: View {
    @Environment(\.managedObjectContext) private var context
    var entry: CustomHomeworkWidgetProvider.Entry
    
    var body: some View {
        HomeworkWidgetView(cour: entry.cour)
    }
}

///
struct CustomHomeworkWidget: Widget {

    /// Le context
    let context = CoreDataStack.shared.container.viewContext
    
    /// Identifiant unique qui représente le widget
    let kind: String = "HomeworkWidget"
    
    var body: some WidgetConfiguration {
    
        /// Intention personnalisée : Une intention personnalisée qui définit les propriétés configurables par l'utilisateur
        IntentConfiguration(
            kind: kind,
            intent: SelectCourIntent.self,
            provider: CustomHomeworkWidgetProvider()
        ) { entry in
            CustomHomeworkEntryView(entry: entry)
                .environment(\.managedObjectContext, context)
        }
        .configurationDisplayName("Custom Homework widget")
        .description("Display a widget with a cour of your choice.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
