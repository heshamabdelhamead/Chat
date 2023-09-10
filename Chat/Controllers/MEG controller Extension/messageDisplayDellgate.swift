//
//  messageDisplayDellgate.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import MessageKit

extension MSViewController: MessagesDisplayDelegate{
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        .label
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let bubbleColorOutgoing = UIColor(named: "colorOutgoingBubble")
        let bubbleColorIngoing = UIColor(named: "colorIncomingBubble")
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing as! UIColor : bubbleColorIngoing as! UIColor
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
    
    
}
