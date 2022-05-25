//
//  Przedmiot+CoreDataProperties.swift
//  Projekt
//
//  Created by student on 25/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//
//

import Foundation
import CoreData


extension Przedmiot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Przedmiot> {
        return NSFetchRequest<Przedmiot>(entityName: "Przedmiot")
    }

    @NSManaged public var id_przedmiot: UUID?
    @NSManaged public var nazwa: String?
    @NSManaged public var oceny: NSSet?

}

// MARK: Generated accessors for oceny
extension Przedmiot {

    @objc(addOcenyObject:)
    @NSManaged public func addToOceny(_ value: Ocena)

    @objc(removeOcenyObject:)
    @NSManaged public func removeFromOceny(_ value: Ocena)

    @objc(addOceny:)
    @NSManaged public func addToOceny(_ values: NSSet)

    @objc(removeOceny:)
    @NSManaged public func removeFromOceny(_ values: NSSet)

}
