//
//  outgoing.swift
//  Chat
//
//  Created by hesham abd elhamead on 22/08/2023.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery

class Outgoing{
    class func sendMessage(chatId : String, text: String?,photo : UIImage?,veideo : Video?,audio : String?,  audioDuration: Float=0.0, location: String?, membersId: [String]){
        //1: create local Message form the data we have
        let currentUser = user.currentUser!
        
        let message = localMessage()
        message.Id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.userName
        message.senderInilials = String( currentUser.userName.first!)
        message.date = Date()
        message.status = "sent"
        //2:check message type
        if text != nil{
            SendText(message: message, text: text!, memberIds: membersId)
            
        }
        if photo != nil{
            sendPhoto(message: message, photo: photo!, memberIds: membersId )
            
        }
        if veideo != nil{
            
        }
        if location != nil{
            
        }
        if audio != nil{
            
        }
        //3: save message locallay
        //4: save message to firestore
    }
    class func saveMessage(message : localMessage,meberIds: [String]){
        RealmManager.Shared.save(message)
        for memberId in meberIds{
            FMessageListener.Shared.addMessage(message: message, memberId: memberId)
        }
    }
}

func SendText(message : localMessage,text : String, memberIds : [String]){
    message.message = text
    message.type = "text"
    Outgoing.saveMessage(message: message, meberIds: memberIds)
}
func sendPhoto(message : localMessage, photo : UIImage,memberIds : [String]){
    message.message = "photo Message"
    message.type = "photo"
    let fileName = Date().stringDate()
    
    let fileDirectory = "MediaMessages/Photo/"+"\(message.chatRoomId)"+"\(fileName)"+".jpg"
    fileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality : 0.6)! as NSData , fileName: fileName)
    fileStorage.uploadImage(photo, directory: fileDirectory) { imageUrl in
        if imageUrl != nil {
            message.pictureUrl = imageUrl!
            Outgoing.saveMessage(message: message, meberIds: memberIds)
        }
    }
    
}
