//
//  Ocena+CoreDataProperties.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//
//

import Foundation
import CoreData


extension Ocena {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ocena> {
        return NSFetchRequest<Ocena>(entityName: "Ocena")
    }

    @NSManaged public var id_ocena: String?
    @NSManaged public var kategoria: String?
    @NSManaged public var waga: Double
    @NSManaged public var wartosc: Double
    @NSManaged public var przedmiot: Przedmiot?

}

extension Ocena : Identifiable {

}
