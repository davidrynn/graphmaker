//
//  GraphView.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import SwiftUI

struct GraphView: View {
    let barColor: Color = .blue
    let graphData: GraphDataEntity
    let axisTitleLength: CGFloat = 10
    var inflatedPoints: [Point] {
        let points = graphData.pointsArray
        let maxXValue = points.max { a, b in
            a.x < b.x
        }?.x ?? 0
        let maxIntValue: Int = Int(maxXValue)
        var inflated: [Point] = []
        (0...maxIntValue).forEach { number in
            if let p = points.first(where: { Int($0.x) == number }) {
                inflated.insert(p, at: number)
            } else {
                inflated.insert(Point(x: Double(number), y: 0), at: number)
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
                        .rotationEffect(Angle(degrees: 90))
                        .font(.system(size: axisTitleLength))
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(Color.black)
                                .frame(maxWidth: 1.0, maxHeight: .infinity)
                            // Points
                            HStack {
                                ForEach(inflatedPoints) { point in
                                    // 3
                                    VStack {
                                        // 4
                                        Spacer()
                                        // 5
                                        Rectangle()
                                            .fill(barColor)
                                            .frame(width: calculatePointWidth(),
                                                   height: calculatePointHeight() * point.y)
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
        let maxWidth = UIScreen.screenWidth * 0.30
        let largestXPoint = graphData.pointsArray.max { a, b in
            a.x < b.x
        }
        guard let largestX = largestXPoint?.x, largestX != 0 else { return 0 }
        return maxWidth / largestX
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


