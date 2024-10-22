//
//  LearnLockApp.swift
//  LearnLock
//
//  Created by Adam Pascarella on 10/21/24.
//
// This is the main code that will launch the app and load the UI.

import SwiftUI

@main
struct LearnLockApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
