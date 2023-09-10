//
//  messageInputBar.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/08/2023.
//

import Foundation
import InputBarAccessoryView

extension MSViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        updateMicButtonStatus(show:  text == "")
        if text != " "{
            startTypingIndictor()
        }
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
    
    
}
