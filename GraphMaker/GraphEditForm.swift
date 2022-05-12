//
//  GraphEditForm.swift
//  GraphMaker
//
//  Created by David Rynn on 4/2/22.
//

import SwiftUI

struct GraphEditForm: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    let graph: GraphDataEntity
    var isDate: Bool {
        return graph.isDate
    }
    @State var points: [Point]
    @State var xString: String = ""
    @State var yString: String = ""
    @State var errorText: String = ""
    @State var title: String
    @State var xAxisTitle: String
    @State var yAxisTitle: String
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    var body: some View {
        VStack {
            Form {
                ForEach(points) { point in
                    Text("x: \(getStringX(point.x)) , y: \(point.y)")
                }
                .onDelete { indexSet in
                    self.points.remove(atOffsets: indexSet)
                }
            }
            Form {
                TextField("Title", text: $title)
                TextField("X Axis Title", text: $xAxisTitle)
                TextField("Y Axis Title", text: $yAxisTitle)
            }
            Form {
                HStack {
                    TextField(isDate ? "MM/DD/YYYY" : "x value", text: $xString)
                    TextField("y value", text: $yString)
                }
                Button("Add Point") {
                    guard let x = Double(xString), let y = Double(yString) else {
                        errorText = "Not a valid number"
                        return
                    }
                    let point = Point(x: x, y: y)
                    points.append(point)
                    xString = ""
                    yString = ""
                }
            }
            Text(errorText)
            Button("Add Graph and finish") {
                var pointEntities: [PointEntity] = []
                for point in points {
                    let entity = PointEntity(context: moc)
                    entity.x = point.x
                    entity.y = point.y
                    entity.id = point.id
                    pointEntities.append(entity)
                }
                graph.pointEntity = NSSet(array: pointEntities)
                graph.xAxisTitle = xAxisTitle
                graph.yAxisTitle = yAxisTitle
                graph.mainTitle = title
                do {
                    try moc.save()
                } catch {
                    errorText = "unable to save"
                    return
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func getStringX(_ x: Double) -> String {
        if isDate {
            let timeInterval = TimeInterval(x)
            let dateX = Date(timeIntervalSince1970: timeInterval)
            let dateString = GraphEditForm.formatter.string(from: dateX)
            return dateString
        }
        return String(x)
    }
}

//struct GraphEditForm_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphEditForm()
//    }
//}
