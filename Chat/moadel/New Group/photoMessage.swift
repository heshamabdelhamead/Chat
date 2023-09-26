//
//  photoMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 15/09/2023.
//

import Foundation
import MessageKit

class photoMessage : NSObject , MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(path : String){
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(systemName: "person")!
        self.size = CGSize(width: 240, height: 240)
        
    }
    
}
