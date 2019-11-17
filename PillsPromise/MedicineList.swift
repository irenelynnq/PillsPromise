//
//  MedicineList.swift
//  PillsPromise
//
//  Created by guest on 2019/11/15.
//  Copyright © 2019 guest. All rights reserved.
//

import Foundation

class MedicineList{
    
    var medicines: [MedicineItem] = []
    
    init(){
        let row0Item = MedicineItem()
        let row1Item = MedicineItem()
        let row2Item = MedicineItem()
        
        row0Item.name = "후시딘"
        row1Item.name = "마데카솔"
        row2Item.name = "밴드"
        
        medicines.append(row0Item)
        medicines.append(row1Item)
        medicines.append(row2Item)
    }
    
    func newMedicine() -> MedicineItem {
        let item = MedicineItem()
        item.name = "New one"
        medicines.append(item)
        return item
    }
}
