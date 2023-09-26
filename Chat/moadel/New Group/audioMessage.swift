//
//  audioMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 26/09/2023.
//

import Foundation
import MessageKit


class AudioMessage: NSObject , AudioItem{
    
    var url: URL
    
    var duration: Float
    
    var size: CGSize
    
    init(duration : Float){
       self.url = URL(fileURLWithPath : "")
       // self.url = url

        self.size = CGSize(width: 180, height: 35)
        self.duration = duration
    }
    
}
