//
//  User.swift
//  EMTableView
//
//  Created by Edgard Matos on 08/01/18.
//  Copyright © 2018 Edgard Matos. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic let endDate: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
