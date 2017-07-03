//
//  Checklist.swift
//  Checklists
//
//  Created by Mitesh Malaviya on 7/2/17.
//  Copyright © 2017 Mitesh Malaviya. All rights reserved.
//

import Foundation
import UIKit
class Checklist: NSObject {
    
    var items = [ChecklistItem]()
    var name = ""
    var iconName: String

    init(name: String, iconName: String) {
        self.name = name
        self.iconName = "Appointments"
        super.init()
    }


    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }



}

