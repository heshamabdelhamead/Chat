//
//  localMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 20/08/2023.
//

import Foundation
import RealmSwift


class localMessage : Object, Codable{
    @objc dynamic var senderId = ""
    @objc dynamic var Id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var senderName = ""
    @objc dynamic var senderInilials  = ""
    @objc dynamic var readDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    @objc dynamic var message = ""
    @objc dynamic var audiourl = ""
    @objc dynamic var   videoUrl = ""
    @objc dynamic var pictureUrl = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuration = 0.0
    override class func primaryKey() -> String? {
        return "Id"
    }
}
