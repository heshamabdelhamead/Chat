//
//  Eextensions.swift
//  Chat
//
//  Created by hesham abd elhamead on 29/07/2023.
//

import Foundation
import UIKit

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
extension Date{
    func longDate()-> String {
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "dd MM yyyy"
        
        return dateFormater.string(from: self)
        
    }
    func time()-> String {
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "HH : MM"
        
        return dateFormater.string(from: self)
        
    }
    func stringDate()-> String {
        
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "ddmmyyyyHHMMss"
        
        return dateFormater.string(from: self)
        
    }
    
    
}
