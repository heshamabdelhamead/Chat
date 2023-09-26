//
//  MKMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import MessageKit
import CoreLocation


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
    var photoMessage : photoMessage!
    var videoMessage : videoMessage!
    var locationItem : locationMessage!
    var audioItem : AudioMessage!
    
      init (message : localMessage) {
        self.messageId = message.senderId
        self.MKSender = Chat.sender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
          
          switch message.type {
              
          case "text" :
              self.kind = MessageKind.text(message.message)
          case "photo" :
              let photoMessage = Chat.photoMessage(path: message.pictureUrl)
              self.kind = MessageKind.photo(photoMessage)
              self.photoMessage = photoMessage
          case "video" :
              let videoItem = Chat.videoMessage(url: nil)
              self.kind = MessageKind.video(videoItem)
              self.videoMessage = videoItem
          case "location":
              let locationItem = locationMessage(location: CLLocation(latitude: message.latitude, longitude: message.longitude))
              self.kind = MessageKind.location(locationItem)
              self.locationItem = locationItem
          case "audio" :
              let audioItem = AudioMessage(duration: 2.0)
              self.kind = MessageKind.audio(audioItem)
              self.audioItem = audioItem
          default :
              self.kind = MessageKind.text(message.message)
          
              
          }
          
          
          
          
          
        self.senderInitials = message.senderInilials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = user.curentId != MKSender.senderId
        
    }
    
    
}
