//
//  HomeworkApp.swift
//  HomeworkWatchOS Extension
//
//  Created by Anthony Peres da Cruz on 30/12/2020.
//

import SwiftUI

@main
struct HomeworkApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
