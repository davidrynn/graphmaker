//
//  GraphView.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import SwiftUI

struct GraphView: View {
    let graphData: GraphData
    let axisTitleLength: CGFloat = 10
    var yAxisLength: CGFloat = 400
    var xAxisLength: CGFloat = 200
    var body: some View {
        var yAxisMultiplier: CGFloat = graphData.points.max(by: { (a, b) -> Bool in
                return a.y < b.y
            })?.y ?? 1
        VStack {
            Text(graphData.title)
            HStack {
                Text(graphData.axisData.yTitle)
                    .rotationEffect(Angle(degrees: 90))
                    .font(.system(size: axisTitleLength))
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(Color.black)
                                .frame(maxWidth: 1.0, maxHeight: .infinity)
                            // Points
                            HStack {
                                ForEach(graphData.points) { point in
                                    // 3
                                    VStack {
                                        // 4
                                        Spacer()
                                        // 5
                                        Rectangle()
                                            .fill(Color.green)
                                            .frame(width: CGFloat(xAxisLength/CGFloat(graphData.points.count)),
                                                   height: CGFloat(point.y * yAxisMultiplier/yAxisLength))
                                        // 6
                                        //              Text("Test")
                                        //                .font(.footnote)
                                        //                .frame(height: 20)
                                    }
                                }
                            }
                            Spacer()
                        }
                        Rectangle()
                            .fill(Color.black)
                            .frame(maxWidth: .infinity, maxHeight: 1.0)
                        Text(graphData.axisData.xTitle)
                            .font(.system(size: axisTitleLength))
                    }
                Spacer()
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graphData: GraphData(title: "Test Graph",
                                       points: [],
                                       axisData: AxisData(xTitle: "Testx",
                                                          yTitle: "TestY",
                                                          xValue: 10,
                                                          yValue: 10)))
    }
}

let mockPoints = [Point(x: 1, y: 3), Point(x: 2, y: 2), Point(x: 3, y: 5), Point(x: 4, y: 4), Point(x: 5, y: 10)]
let mockAxisData = AxisData(xTitle: "Time - bottom", yTitle: "Data y", xValue: 10, yValue: 10)
let mockGraphData = GraphData(title: "Test Graph", points: mockPoints, axisData: mockAxisData)
