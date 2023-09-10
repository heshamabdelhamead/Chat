//
//  MKMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import MessageKit


class MKMessage : NSObject, MessageType{
    var sentDate: Date
    var MKSender : sender
    var sender: MessageKit.SenderType{return MKSender }
    var messageId: String
    var kind: MessageKit.MessageKind
    var senderInitials : String
    var status : String
    var readDate : Date
    var incoming : Bool
    
      init (message : localMessage) {
        self.messageId = message.senderId
        self.MKSender = Chat.sender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        self.senderInitials = message.senderInilials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = user.curentId != MKSender.senderId
        
    }
    
    
}
