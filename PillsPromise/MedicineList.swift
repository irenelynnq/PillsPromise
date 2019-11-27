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
        let row3Item = MedicineItem()
        let row4Item = MedicineItem()
        
        row0Item.name = "후시딘"
        row0Item.med_info = "연고"
        row1Item.name = "마데카솔"
        row1Item.med_info = "연고"
        row2Item.name = "뽀로로밴드"
        row2Item.med_info = "상처났을 때"
        row3Item.name = "타이레놀"
        row3Item.med_info = "진통제"
        row4Item.name = "지르텍"
        row4Item.med_info = "알레르기약"
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        row0Item.date_expiration = formatter.date(from: "2019-11-10")
        row1Item.date_expiration = formatter.date(from: "2020-07-07")
        row2Item.date_expiration = formatter.date(from: "2018-01-19")
        row3Item.date_expiration = formatter.date(from: "2019-12-20")
        row4Item.date_expiration = formatter.date(from: "2020-02-05")
        
        let alarmsformatter = DateFormatter()
        alarmsformatter.locale = Locale(identifier:"ko_KR")
        alarmsformatter.dateFormat = "hh:mm"
        
        
        row0Item.alarms.append(alarmsformatter.date(from: "21:40")!)
        row1Item.alarms.append(alarmsformatter.date(from: "12:00")!)
        row2Item.alarms.append(alarmsformatter.date(from: "09:20")!)
        row3Item.alarms.append(alarmsformatter.date(from: "10:10")!)

        
        
        medicines.append(row0Item)
        medicines.append(row1Item)
        medicines.append(row2Item)
        medicines.append(row3Item)
        medicines.append(row4Item)
    }
    
    func newMedicine() -> MedicineItem {
        let item = MedicineItem()
        item.name = "New one"
        medicines.append(item)
        return item
    }
    
    func move(item: MedicineItem, to index: Int) {
        guard let currentIndex = medicines.firstIndex(of: item) else {
            return
        }
        medicines.remove(at: currentIndex)
        medicines.insert(item, at: index)
    }
    
    func remove(items: [MedicineItem]) {
        for item in items {
            if let index = medicines.firstIndex(of: item) {
                medicines.remove(at: index)
            }
        }
    }
}
