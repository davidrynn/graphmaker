//
//  GraphDataEntity+CoreDataProperties.swift
//  GraphMaker
//
//  Created by David Rynn on 3/20/22.
//
//

import Foundation
import CoreData
import CoreGraphics


extension GraphDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphDataEntity> {
        return NSFetchRequest<GraphDataEntity>(entityName: "GraphDataEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var mainTitle: String?
    @NSManaged public var xAxisLength: Double
    @NSManaged public var yAxisLength: Double
    @NSManaged public var yAxisTitle: String?
    @NSManaged public var xAxisTitle: String?
    @NSManaged public var pointEntity: NSSet?
    
    public var unwrappedMainTitle: String {
        mainTitle ?? ""
    }
    
    public var pointArray: [CGPoint] {
        let set = pointEntity as? Set<PointEntity> ?? []
        let points = set.map { CGPoint(x: $0.x, y: $0.y)}
        return points.sorted {
            $0.x < $1.x
        }
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
