//
//  GraphDataEntity+CoreDataProperties.swift
//  GraphMaker
//
//  Created by David Rynn on 5/2/22.
//
//

import Foundation
import CoreData


extension GraphDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphDataEntity> {
        return NSFetchRequest<GraphDataEntity>(entityName: "GraphDataEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var mainTitle: String?
    @NSManaged public var xAxisTitle: String?
    @NSManaged public var yAxisTitle: String?
    @NSManaged public var isDate: Bool
    @NSManaged public var pointEntity: NSSet?
    
    var unwrappedMainTitle: String {
        return mainTitle ?? ""
    }
    var unwrappedYAxisTitle: String {
        return yAxisTitle ?? ""
    }
    var unwrappedXAxisTitle: String {
        return xAxisTitle ?? ""
    }
    
    var pointsArray: [Point] {
        guard let points = pointEntity as? Set<PointEntity> else {
            return []
        }
        var pointArray: [Point] = []
        points.forEach { pointArray.append(Point(x: $0.x, y: $0.y)) }
        pointArray.sort { a, b in
            a.x < b.x
        }
        return pointArray
    }


}

// MARK: Generated accessors for pointEntity
extension GraphDataEntity {

    @objc(addPointEntityObject:)
    @NSManaged public func addToPointEntity(_ value: PointEntity)

    @objc(removePointEntityObject:)
    @NSManaged public func removeFromPointEntity(_ value: PointEntity)

    @objc(addPointEntity:)
    @NSManaged public func addToPointEntity(_ values: NSSet)

    @objc(removePointEntity:)
    @NSManaged public func removeFromPointEntity(_ values: NSSet)

}

extension GraphDataEntity : Identifiable {

}
