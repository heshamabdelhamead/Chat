//
//  RealmManger.swift
//  Chat
//
//  Created by hesham abd elhamead on 22/08/2023.
//

import Foundation
import RealmSwift
class RealmManager{
    static let Shared = RealmManager()
    let realm = try! Realm()
    private init() {}
    func save < T : Object >( _ object : T){
        do{
            
            try  realm.write{
                realm.add(object, update: .all)
            }
            
        }
        catch{
            print("error Saving data ", error.localizedDescription)
        }
    }
    
}

