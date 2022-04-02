//
//  GraphMakerApp.swift
//  GraphMaker
//
//  Created by David Rynn on 12/19/21.
//

import SwiftUI

@main
struct GraphMakerApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
