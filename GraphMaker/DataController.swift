//
//  DataController.swift
//  GraphMaker
//
//  Created by David Rynn on 4/1/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "GraphMaker")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load data: \(error.localizedDescription)")
            }
        }
    }
    
}
