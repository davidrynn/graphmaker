//
//  AxisData.swift
//  GraphMaker
//
//  Created by David Rynn on 12/28/21.
//

import Foundation

struct AxisData: Identifiable {
    let id = UUID()
    let xTitle: String
    let yTitle: String
    let xValue: Double
    let yValue: Double
}
