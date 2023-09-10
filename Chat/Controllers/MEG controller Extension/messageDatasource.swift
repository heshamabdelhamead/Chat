//
//  messageDatasource.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import MessageKit

extension MSViewController : MessagesDataSource{
    func currentSender() -> MessageKit.SenderType {
        return curentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
      return  MKMessages[indexPath.section]
      //  return 1 as! MessageType
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
      return   MKMessages.count
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        var showMore = indexPath.section == 0 && allLocalMessages.count > displayingMessages
        if indexPath.section % 3 == 0{
            let text = showMore ? "pull for more information  " : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showMore ? UIFont.systemFont(ofSize: 13) : UIFont.systemFont(ofSize: 10)
            let color = showMore ? UIColor.systemBlue : UIColor.darkGray
            return NSAttributedString(string: text, attributes: [.font : font, .foregroundColor : color ])
            
        }
        return nil
    }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message){
            let message = MKMessages[indexPath.section]
            let  status = indexPath.section == MKMessages.count - 1 ? message.status + " " + message.readDate.time() : ""
                let font = UIFont.systemFont(ofSize: 10)
                let color = UIColor.darkGray
            return NSAttributedString(string: status , attributes: [.font: font,.foregroundColor : color])
                
        }
        return nil
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != MKMessages.count - 1 {
            let font = UIFont.systemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time() , attributes: [.font : font,.foregroundColor: color])
        }
        return nil
    }
    
    
}
