//
//  chatRoom.swift
//  Chat
//
//  Created by hesham abd elhamead on 11/08/2023.
//

import Foundation
import FirebaseFirestoreSwift




struct chatRoom : Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var recevierId = ""
    var recevierName = ""
    @ServerTimestamp var date = Date()
    var membersIds = [""]
    var lastMessage = "last message"
    var unReadedCounter = 0
    var avtarLink = ""
    
    
}
