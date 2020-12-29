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
    
    /// placeholder function is used by the system to generate a template view in the widget gallery. You can provide mock data here that will look nice in the gallery.
    func placeholder(in context: Context) -> CustomCourEntry {
        let context = CoreDataStack.preview.container.viewContext
        let cour = Cours(context: context)
        cour.intitule = "Cour"
        return CustomCourEntry(date: Date(), cour: cour)
    }
    
    /// fourni rapidement un timelineEntry (ici : CustomCourEntry) pour présenter une vue de widget utilisée dans des situations transitoires, par exemple, dans la galerie de widgets.
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
        
        let cour = lookupCour(for: configuration)
        let entry = CustomCourEntry(date: Date(), cour: cour)
        completion(entry)
    }
    
    /// Fourni un tableau d'entry, un pour l'instant présent et d'autres pour les temps futurs en fonction de l'intervalle de mise à jour du widget.
    /// Exemple mise à jour du widget toutes les heures.
    func getTimeline(
        for configuration: SelectCourIntent,
        in context: Context,
        completion: @escaping (Timeline<CustomCourEntry>) -> Void
    ) {
        var entries = [CustomCourEntry]()
        let cour = lookupCour(for: configuration)
        let entry = CustomCourEntry(date: Date(), cour: cour)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    ///
    private func lookupCour(for configuration: SelectCourIntent) -> Cours? {
        let context = CoreDataStack.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Cours.entity()
        
        let cours = try! context.fetch(fetchRequest) as! [Cours]
        
        if cours.isEmpty {
            return nil
        }
        
        
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


/// Données du widget (peut être mises à jour en fonction du cas d'utilisation de l'application)
struct CustomCourEntry: TimelineEntry {
    let date: Date
    let cour: Cours?
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
    
    /// Kind est une chaîne qui identifie le type de widget. Votre application peut avoir plusieurs widgets. Dans ce cas, un identifiant de genre vous permet de mettre à jour des widgets d'un type particulier
    let kind: String = "HomeworkWidget"
    
    var body: some WidgetConfiguration {
        
        /// Intention personnalisée : Une intention personnalisée qui définit les propriétés configurables par l'utilisateur
        IntentConfiguration(
            kind: kind,
            intent: SelectCourIntent.self,
            provider: CustomHomeworkWidgetProvider() // récupérer les données du widget.
        ) { entry in
            CustomHomeworkEntryView(entry: entry)
                .environment(\.managedObjectContext, context)
        }
        .configurationDisplayName("Custom Homework widget")
        .description("Display a widget with a cour of your choice.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
