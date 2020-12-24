//
//  HomeworkApp.swift
//  Shared
//
//  Created by Anthony Peres da Cruz on 21/12/2020.
//

import SwiftUI

@main
struct HomeworkApp: App {
    let persistenceController = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
