//
//  PointEntity+CoreDataProperties.swift
//  GraphMaker
//
//  Created by David Rynn on 3/20/22.
//
//

import Foundation
import CoreData


extension PointEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointEntity> {
        return NSFetchRequest<PointEntity>(entityName: "PointEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var graphData: GraphDataEntity?

}

extension PointEntity : Identifiable {

}
