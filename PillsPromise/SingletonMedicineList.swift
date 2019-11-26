//
//  SingletonMedicineList.swift
//  PillsPromise
//
//  Created by guest on 2019/11/27.
//  Copyright © 2019 guest. All rights reserved.
//

import Foundation

class SingletoneMedicineList {
    static let shared = SingletoneMedicineList()
    
    var medicineList = MedicineList()
    
    private init() {}
}
