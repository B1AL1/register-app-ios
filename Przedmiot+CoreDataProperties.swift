//
//  Przedmiot+CoreDataProperties.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//
//

import Foundation
import CoreData


extension Przedmiot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Przedmiot> {
        return NSFetchRequest<Przedmiot>(entityName: "Przedmiot")
    }

    @NSManaged public var id_przedmiot: String?
    @NSManaged public var nazwa: String?
    @NSManaged public var ocena: NSSet?

}

// MARK: Generated accessors for ocena
extension Przedmiot {

    @objc(addOcenaObject:)
    @NSManaged public func addToOcena(_ value: Ocena)

    @objc(removeOcenaObject:)
    @NSManaged public func removeFromOcena(_ value: Ocena)

    @objc(addOcena:)
    @NSManaged public func addToOcena(_ values: NSSet)

    @objc(removeOcena:)
    @NSManaged public func removeFromOcena(_ values: NSSet)

}

extension Przedmiot : Identifiable {

}
