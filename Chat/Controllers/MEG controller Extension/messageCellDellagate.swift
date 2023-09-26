//
//  messageCellDellagate.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser

extension MSViewController: MessageCellDelegate{
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        let indexPath = messagesCollectionView.indexPath(for: cell)
        
        let mkMessage = MKMessages[indexPath!.section]
      if   mkMessage.photoMessage != nil && mkMessage.photoMessage.image != nil {
            var images = [SKPhoto]()
            var photo = SKPhoto.photoWithImage(mkMessage.photoMessage.image!)
            images.append(photo)
          let browser =   SKPhotoBrowser(photos: images)
            self.present(browser, animated: true )
        }
        
    if   mkMessage.videoMessage != nil && mkMessage.videoMessage.url != nil {
        
             let playerController = AVPlayerViewController()
        let player = AVPlayer(url: mkMessage.videoMessage!.url!)
        
        playerController.player = player
        
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(.playAndRecord, mode: .default , options: .defaultToSpeaker)
       // try! session.setCategory(.playAndRecord)
        
        present(playerController, animated: true) {
            playerController.player!.play()
            
        }
        
        }
        
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let MKMessage = MKMessages[indexPath.section]
            if MKMessage.locationItem != nil {
                let mapView = mapViewController()
                mapView.location = MKMessage.locationItem.location
                navigationController?.pushViewController(mapView, animated: true )
            }
        }
        
            
    }
    func didTapPlayButton(in cell: AudioMessageCell) {
      guard
        let indexPath = messagesCollectionView.indexPath(for: cell),
        let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
      else {
        print("Failed to identify message when audio cell receive tap gesture")
        return
      }
      guard audioController.state != .stopped else {
        // There is no audio sound playing - prepare to start playing for given audio message
        audioController.playSound(for: message, in: cell)
        return
      }
      if audioController.playingMessage?.messageId == message.messageId {
        // tap occur in the current cell that is playing audio sound
        if audioController.state == .playing {
          audioController.pauseSound(for: message, in: cell)
        } else {
          audioController.resumeSound()
        }
      } else {
        // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
        audioController.stopAnyOngoingPlaying()
        audioController.playSound(for: message, in: cell)
      }
    }

     
}
