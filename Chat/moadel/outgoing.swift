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
    class func sendMessage(chatId : String, text: String?,photo : UIImage?,video : Video?,audio : String?,  audioDuration: Float=0.0, location: String?, membersId: [String]){
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
        if video != nil{
            sendVideo(message: message, video: video! , memberIds: membersId)
        }
        if location != nil{
            sendLocation(message: message, memberIds: membersId )
            
        }
        if audio != nil{
            print("hi there")
            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: membersId)
            
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


func sendVideo(message : localMessage,video : Video,memberIds:[String]){
    message.message  = "video message"
    message.type = "video"
    let fileName = Date().stringDate()
    let thumbnailDirectory = "MediaMessages/Photo/"+"\(message.chatRoomId)"+"_\(fileName)"+".jpg"
    let videoDirectory = "MediaMessages/Video/"+"\(message.chatRoomId)"+"\(fileName)"+".mov"
    let editor = VideoEditor()
    editor.process(video: video) { processVideo, videoUrl in
        if let tempPath = videoUrl{
            let thumbnail = videoThumbnail(videoUrl: tempPath)
            fileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
            fileStorage.uploadImage(thumbnail, directory: thumbnailDirectory) { imageLink in
                if imageLink != nil {
                    let videoData = NSData(contentsOfFile : tempPath.path)
                    fileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    fileStorage.uploadvideo(videoData! , directory: videoDirectory) { videoLink in
                        message.videoUrl = videoLink ?? ""
                        message.pictureUrl = imageLink ?? ""
                        Outgoing.saveMessage(message: message, meberIds: memberIds)

                    }
                    
                }
                
            }
        }
    }
    

    
}

func sendLocation(message : localMessage,memberIds:[String]){
    let currentLocation = LocationManger.shared.curentLocation
    message.message = "location messsage"
    message.type = "location"
    message.latitude = currentLocation?.latitude ?? 0.0
    message.longitude = currentLocation?.longitude ?? 0.0
    Outgoing.saveMessage(message: message, meberIds: memberIds)
}

func sendAudio(message: localMessage, audioFileName: String ,audioDuration : Float, memberIds : [String]){
    
    message.message = "Audio message "
    message.type = "audio"
    let fileDiectory = "MediaMessages/Audio/"+"\(message.chatRoomId)"+"_\(audioFileName)"+".m4a"
    print("hi there")

    fileStorage.uploadAudio(audioFileName, directory: fileDiectory) { audioLink in

        if audioLink != nil {
            message.audiourl = audioLink ?? " "
            message.audioDuration = Double(audioDuration)
            Outgoing.saveMessage(message: message, meberIds: memberIds)
        }
    }
    

    
}
