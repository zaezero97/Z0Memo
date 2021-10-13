//
//  Memo+CoreDataProperties.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/13.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?

}

extension Memo : Identifiable {

}
