//
//  GraphIntake.swift
//  GraphMaker
//
//  Created by David Rynn on 3/30/22.
//

import SwiftUI

struct GraphIntakeForm: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var points: [Point] = []
    @State var xString: String = ""
    @State var yString: String = ""
    @State var errorText: String = ""
    @State var title: String = ""
    @State var xAxisTitle: String = ""
    @State var yAxisTitle: String = ""
    @State var isDate: Bool = false
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                ForEach(points) { point in
                    Text("x: \(point.x) , y: \(point.y)")
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
                    TextField((isDate ? "MM/DD/YYYY" : "x value"), text: $xString)
                    TextField("y value", text: $yString)
                }
                Button("Add Point") {
                    let x: Double
                    let textError = "Not a valid number"
                    guard let y = Double(yString) else {
                        errorText = textError
                        return
                    }
                    if isDate {
                        guard let date: Date = GraphIntakeForm.formatter.date(from: xString) else {
                            errorText = "Not a valid date"
                            return
                        }
                        let timeInterval = date.timeIntervalSince1970
                        x = Double(timeInterval)
                    } else {
                        guard let xDouble = Double(xString) else {
                            errorText = textError
                            return
                        }
                        x = xDouble
                    }
                    let point = Point(x: x, y: y)
                    points.append(point)
                    xString = ""
                    yString = ""
                }
                Toggle(isOn: $isDate) {
                    Text("Use Dates")
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
                let data = GraphDataEntity(context: moc)
                data.pointEntity = NSSet(array: pointEntities)
                data.xAxisTitle = xAxisTitle
                data.yAxisTitle = yAxisTitle
                data.mainTitle = title
                data.id = UUID()
                data.isDate = isDate
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
}

struct GraphIntake_Previews: PreviewProvider {
    static var previews: some View {
        GraphIntakeForm()
    }
}
