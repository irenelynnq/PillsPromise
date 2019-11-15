//
//  IntakeAlarmItem.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class IntakeAlarmItem: NSObject {
    var id = ""
    var medicineItem : MedicineItem = MedicineItem()
    var alarms : [timeval] = []
}
