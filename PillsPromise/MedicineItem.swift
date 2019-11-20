//
//  MedicineItem.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class MedicineItem: NSObject {
    var id = ""
    var name = ""
    var med_info = ""
    var date_expiration: Date = Date(timeIntervalSince1970: 0) //유통기한 탭에서는 이걸 기준으로 필터해서 보여줍니다
    var take_info = ""
    var other_info = ""
    var alarms: [Date] = [] //알람 탭에서는 이걸 기준으로 필터해서 보여줍니다
}
