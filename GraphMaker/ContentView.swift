//
//  ContentView.swift
//  GraphMaker
//
//  Created by David Rynn on 12/19/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var graphs: FetchedResults<GraphDataEntity>

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    ForEach(graphs) { graph in
                        NavigationLink(destination: GraphView(graphData: graph)) {
                            Text(graph.unwrappedMainTitle)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { indx in
                            delete(graphs[indx])
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: GraphIntakeForm()) {
                        Image(systemName: "plus")
                    }
                }
            }

        }
    }
    
    func delete(_ graph: GraphDataEntity) {
        moc.delete(graph)
        do {
            try moc.save()
        } catch {
            print("unable to save")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
