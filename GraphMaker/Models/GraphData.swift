//
//  GraphData.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import Foundation

struct GraphData: Identifiable {
    let id = UUID()
    let title: String
    let points: [Point]
    let axisData: AxisData
}
