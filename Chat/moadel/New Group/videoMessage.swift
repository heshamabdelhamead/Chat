//
//  videoMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 16/09/2023.
//

import Foundation
import MessageKit

class videoMessage : NSObject , MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url : URL?){
        self.url = url
        self.placeholderImage = UIImage(systemName: "person")!
        self.size = CGSize(width: 240, height: 240)
        
    }
    
}
