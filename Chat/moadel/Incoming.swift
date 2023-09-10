//
//  Incoming.swift
//  Chat
//
//  Created by hesham abd elhamead on 25/08/2023.
//

import Foundation
import MessageKit



class Incoming{
    var messageViewController : MSViewController
    
    init(messageViewController: MSViewController) {
        self.messageViewController = messageViewController
    }
    func createMKmessage (localMessage : localMessage)-> MKMessage{
        let MKMessage = MKMessage(message: localMessage)
        
        return MKMessage
    }
}
