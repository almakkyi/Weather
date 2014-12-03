//
//  Location.swift
//  Weather
//
//  Created by Ibrahim Almakky on 01/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var city: String
    @NSManaged var country: String

}
