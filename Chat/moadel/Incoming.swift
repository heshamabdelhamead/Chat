//
//  Incoming.swift
//  Chat
//
//  Created by hesham abd elhamead on 25/08/2023.
//

import Foundation
import MessageKit
import CoreLocation



class Incoming{
    var messageViewController : MSViewController
    
    init(messageViewController: MSViewController) {
        self.messageViewController = messageViewController
    }
    func createMKmessage (localMessage : localMessage)-> MKMessage{
        let MKMessage = MKMessage(message: localMessage)
        
        if localMessage.type == "photo"{
            
            let photoItem = photoMessage(path: localMessage.pictureUrl)
            MKMessage.photoMessage = photoItem
            MKMessage.kind = MessageKind.photo(photoItem)
            
            fileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { image in
                MKMessage.photoMessage?.image = image
                DispatchQueue.main.async {
                    self.messageViewController.messagesCollectionView.reloadData()

                }
            }
        }
        if localMessage.type == "video" {
            fileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { thumbnail  in
                fileStorage.downloadVideo(videoUrl: localMessage.videoUrl) { readyToPlay, fileName in
                    let videoLink = URL(fileURLWithPath: fileInDoucmentDierctory(fileName: fileName))
                    let videoItem = videoMessage(url: videoLink)
                    MKMessage.videoMessage = videoItem
                    MKMessage.kind = MessageKind.video(videoItem)
                    MKMessage.videoMessage.image = thumbnail
                    DispatchQueue.main.async {
                        
                        self.messageViewController.messagesCollectionView.reloadData()
                    }
                }
            }
            
        }
        
        if localMessage.type == "location"{
            let locationItem = locationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.longitude))
            MKMessage.kind = MessageKind.location(locationItem)
            MKMessage.locationItem = locationItem
        }
        if localMessage.type == "audio"{
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            MKMessage.audioItem = audioMessage
            MKMessage.kind = MessageKind.audio(audioMessage)
            fileStorage.downloadAudio(audioUrl: localMessage.audiourl) { audioFileName in
                let audioUrl = URL(fileURLWithPath: fileInDoucmentDierctory(fileName: audioFileName))
                MKMessage.audioItem?.url = audioUrl
                
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
        }
        
        return MKMessage
    }
}
