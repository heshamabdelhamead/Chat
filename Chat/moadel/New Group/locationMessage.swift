//
//  locationMessage.swift
//  Chat
//
//  Created by hesham abd elhamead on 21/09/2023.
//

import Foundation
import CoreLocation
import MessageKit



class locationMessage : NSObject, LocationItem{
    var location: CLLocation
    
    var size: CGSize
    
    init(location : CLLocation) {
        self.location = location
        size = CGSize(width: 240, height: 240)
        
    }
}
