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
    
    init() {
        /* 어플리케이션을 맨 처음에 실행했을 때 나타나는 더미 데이터.
         더미 데이터로 초기화를 원한다면 simulator - hardware - erase all content and settings
         이후로는 사용자 설정이 저장됨
         */
        let row0Item = MedicineItem(name: "후시딘", med_info: "연고", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
        let row1Item = MedicineItem(name: "마데카솔", med_info: "연고", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
        let row2Item = MedicineItem(name: "뽀로로밴드", med_info: "상처났을 때", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
        let row3Item = MedicineItem(name: "타이레놀", med_info: "진통제", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
        let row4Item = MedicineItem(name: "지르텍", med_info: "알레르기약", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
        
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
        alarmsformatter.dateFormat = "HH:mm"
        
        
        row0Item.alarms.append(alarmsformatter.date(from: "21:40")!)
        row1Item.alarms.append(alarmsformatter.date(from: "12:00")!)
        row2Item.alarms.append(alarmsformatter.date(from: "09:20")!)
        row3Item.alarms.append(alarmsformatter.date(from: "10:10")!)
        row3Item.alarms.append(alarmsformatter.date(from: "08:02")!)

        
        medicines.append(row0Item)
        medicines.append(row1Item)
        medicines.append(row2Item)
        medicines.append(row3Item)
        medicines.append(row4Item)
 
    }
    
    
    func newMedicine() -> MedicineItem {
        let item = MedicineItem(name: "", med_info: "", date_expiration: nil, take_info: "", other_info: "", alarms: [], image: nil)
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
    
    func removeAlarms(items: [MedicineItem]) {
        for item in items {
            item.deleteAlarms()
        }
    }
    
    func listOfHavingAlarms() -> [MedicineItem] {
        return medicines.filter {
            $0.alarms.count > 0
        }
    }
    
    func save() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: medicines)
        UserDefaults.standard.setValue(encodedData, forKey: "medicines")
    }
    func load() {
        guard let encodedData = UserDefaults.standard.value(forKeyPath: "medicines") as? Data else {return }
        medicines = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [MedicineItem]
    }
    
 
}
