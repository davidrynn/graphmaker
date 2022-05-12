//
//  GraphView.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import SwiftUI

struct GraphView: View {
    /*
     let query = NSPredicate(format: "%K == %@", "projectId", proj.id! as CVarArg)
     requestSessions.predicate = query
     */
    @FetchRequest(sortDescriptors: []) var graphs: FetchedResults<GraphDataEntity>
    let barColor: Color = .blue
    let graphData: GraphDataEntity
    let maximumPoints: Double = 300
    let axisTitleLength: CGFloat = 10
    let maxWidth = UIScreen.screenWidth * 0.30
    var inflatedPoints: [Point] {
        let points: [Point]
        if graphData.isDate {
            points = graphData.pointsArray.compactMap { Point(x: ($0.x / Double(86400)), y: $0.y) }
        } else {
           points = graphData.pointsArray
        }
        let maxXValue = points.max { a, b in
            a.x < b.x
        }?.x ?? 0
        let maxIntValue: Int = Int(maxXValue)
        //keep points to less than 300
        let minIntValue: Int = (maxXValue > maxWidth) ? Int(maxXValue - maxWidth) : 0
        //inflated makes sure that space inbetween points gets spaced correctly
        var inflated: [Point] = []
        ((minIntValue + 1)...maxIntValue).forEach { number in
            //if number is a value in points then chart if
            if let p = points.first(where: { Int($0.x) == number }) {
                inflated.append(p)
            } else {
                //otherwise put a value with 0 y so that it takes up space but no bar value
                //TODO: Figure out way to chart x value without 0 y points.   Wouldn't work in line graph.
                inflated.append(Point(x: Double(number), y: 0))
            }
            
        }
//        (0...maxIntValue).enumerated().map { index, number in
//            if let p = points.first(where: { Int($0.x) == number }) {
//                return p
//            }
//            let x = Double(number)
//            return Point(x: x, y: 0)
//        }
//        return inflated.sorted { a, b in
//            a.x < b.x
//        }
        return inflated
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(graphData.unwrappedMainTitle)
                HStack {
                    Text(graphData.yAxisTitle ?? "No title")
                        .rotationEffect(Angle(degrees: 270))
                        .font(.system(size: axisTitleLength))
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(Color.black)
                                .frame(maxWidth: 1.0, maxHeight: .infinity)
                            // Points
                            HStack {
                                let width = calculatePointWidth()
                                let height = calculatePointHeight()
                                ForEach(inflatedPoints) { point in
                                    // 3
                                    VStack {
                                        // 4
                                        Spacer()
                                        // 5
                                        Rectangle()
                                            .fill(barColor)
                                            .frame(width: width,
                                                   height: height * point.y)
                                    }
                                }
                            }
                            Spacer()
                        }
                        Rectangle()
                            .fill(Color.black)
                            .frame(maxWidth: .infinity, maxHeight: 1.0)
                        Text(graphData.xAxisTitle ?? "No Title")
                            .font(.system(size: axisTitleLength))
                    }
                    Spacer()
                }
            }
        }
        .toolbar {

            ToolbarItem {
                let destination = GraphEditForm(graph: graphData, points: graphData.pointsArray, title: graphData.unwrappedMainTitle, xAxisTitle: graphData.unwrappedXAxisTitle, yAxisTitle: graphData.unwrappedYAxisTitle)
                NavigationLink(destination: destination) {
                    Text("Edit")
                }
            }
        }
    }
    
    func calculatePointWidth() -> CGFloat {
        return maxWidth / CGFloat(inflatedPoints.count)
    }
    
    func calculatePointHeight() -> CGFloat {
        let maxHeight = UIScreen.screenHeight * 0.50
        let largestYPoint = graphData.pointsArray.max { a, b in
            a.y < b.y
        }
        guard let largestY = largestYPoint?.y, largestY != 0 else { return 0 }
        return maxHeight / largestY
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView(graphData: GraphDataEntity())
//    }
//}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
