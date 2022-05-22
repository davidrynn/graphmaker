//
//  GraphView.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import SwiftUI
//https://blog.logrocket.com/building-custom-charts-swiftui/
struct GraphView: View {
    /*
     let query = NSPredicate(format: "%K == %@", "projectId", proj.id! as CVarArg)
     requestSessions.predicate = query
     */
    @FetchRequest(sortDescriptors: []) var graphs: FetchedResults<GraphDataEntity>
    let axisTitleLength: CGFloat = 10
    let barColor: Color = .blue
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    let graphData: GraphDataEntity
    @State var graphStyle: Int = 0
    var highestData: Double {
        let largestYPoint = graphData.pointsArray.max { a, b in
            a.y < b.y
        }
        guard let largestYValue = largestYPoint?.y, largestYValue != 0 else { return 0 }
        return largestYValue
    }
    
    /// Assumes that values to be charted on x axis are linear, and any point that is missing an x or y value should still be plotted
    /// as empy on the x axis.
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
        let minXValue = points.min { a, b in
            a.x < b.x
        }?.x ?? 0
        let maxIntValue: Int = Int(maxXValue)
        let minIntValue: Int = Int(minXValue)
        //inflated makes sure that space inbetween points gets spaced correctly
        var inflated: [Point] = []
        (minIntValue...maxIntValue).forEach { number in
            //if number is a value in points then chart it
            if let point = points.first(where: { Int($0.x) == number }) {
                inflated.append(point)
            } else {
                //otherwise put a value with 0 y so that it takes up space but no bar value
                //TODO: Figure out way to chart x value without 0 y points.   Wouldn't work in line graph.
                inflated.append(Point(x: Double(number), y: 0))
            }
        }
        //put date back into timeinterval now that it's been expanded per day
        if graphData.isDate {
            inflated = inflated.map { Point(x: $0.x * Double(86400), y: $0.y) }
        }
        return inflated
    }
    
    var body: some View {
        //        NavigationView {
        VStack {
            Picker("Type of Graph", selection: $graphStyle) {
                Text("TabBar").tag(0)
                Text("Line").tag(1)
            }
            .pickerStyle(.segmented)
            Text(graphData.unwrappedMainTitle)
            //if bar graph
            HStack {
                Text(graphData.unwrappedYAxisTitle).rotationEffect(.degrees(-90))
                let points = inflatedPoints
                if graphStyle == 0 {
                    GeometryReader { geometry in
                        HStack(alignment: .bottom, spacing: 4.0) {
                            ForEach(points.indices, id: \.self) { index in
                                let width = (geometry.size.width / CGFloat(points.count)) - 4.0
                                let height = geometry.size.height * points[index].y / highestData
                                let adjWidth = width < 1 ? 1 : width
                                BarView(datum: points[index].y, colors: [.blue])
                                    .frame(width: adjWidth, height: height, alignment: .bottom)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                } else {
                    //if line graph
                    GeometryReader { geometry in
                        let height = geometry.size.height
                        let width = geometry.size.width
                        let indexStart = points.count > Int(width) ? points.count - Int(width) : 0
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
                            for index in indexStart..<inflatedPoints.count {
                                let point = CGPoint(
                                    x: CGFloat(index) * width / CGFloat(inflatedPoints.count - 1),
                                    y: height * self.ratio(for: index))
                                path.addEllipse(in: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4))
                            }
                            path.closeSubpath()
                        }
                        .fill()
                        
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
                            for index in 0..<inflatedPoints.count {
                                let point = CGPoint(
                                    x: CGFloat(index) * width / CGFloat(inflatedPoints.count - 1),
                                    y: height * self.ratio(for: index))
                                path.addLine(to: point)
                            }
                        }
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                
            }
            //Text meter
            GeometryReader { geometry in
                let points = inflatedPoints
                HStack(alignment: .bottom, spacing: 1.0) {
                    ForEach(points.indices, id: \.self) { index in
                        let width = (geometry.size.width / CGFloat(points.count)) - 4.0
                        let adjWidth = width < 1 ? 1 : width
                        let text = getXAxisText(points[index].x)
                        Text(text)
                            .font(.system(size: 8.0))
//                            .rotationEffect(.degrees(-90), anchor: .topLeading)
                            .frame(width: adjWidth, alignment: .top)
                    }
                }
            }
            .offset(CGSize(width: 30, height: 0))
            .padding(.vertical)
            .padding(.horizontal)
            Text(graphData.unwrappedXAxisTitle)
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
    
    private func getXAxisText(_ value: Double) -> String {
        var text: String
        if self.graphData.isDate {
            let dateInterval = TimeInterval(value)
            let date = Date(timeIntervalSince1970: dateInterval)
            text = GraphView.formatter.string(from: date)
        } else {
            let cleaned = Int(value)
            text = String(cleaned)
        }
        return text
    }
    
    private func ratio(for index: Int) -> Double {
        1 - (inflatedPoints[index].y / highestData)
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView(graphData: GraphDataEntity())
//    }
//}



