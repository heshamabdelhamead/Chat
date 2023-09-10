//
//  messageLayoutDelgate.swift
//  Chat
//
//  Created by hesham abd elhamead on 28/08/2023.
//

import Foundation
import MessageKit
extension MSViewController : MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
     if    indexPath.section % 3 == 0  {
         if (indexPath.section == 0 ) && (displayingMessages < allLocalMessages.count){
             return 40 
         }
                
            
        }
        return 10 
        
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 17 : 0
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
      return  indexPath.section != MKMessages.count - 1  ? 10 : 0
    }
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: MKMessages[indexPath.section].senderInitials))
    }
     
    
}
