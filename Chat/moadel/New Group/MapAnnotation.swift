//
//  MapAnnotation.swift
//  Chat
//
//  Created by hesham abd elhamead on 22/09/2023.
//

import Foundation
import MapKit


class mapAnnotation : NSObject , MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    init(coordinate : CLLocationCoordinate2D ,title : String?) {
         self.coordinate = coordinate
        self.title = title
    }
}
