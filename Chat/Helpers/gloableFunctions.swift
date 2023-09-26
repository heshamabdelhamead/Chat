//
//  gloableFunctions.swift
//  Chat
//
//  Created by hesham abd elhamead on 26/07/2023.
//

import Foundation
import MessageKit
import AVFoundation

func fileNameFrom(fileUrl : String)-> String{
    let name = fileUrl.components(separatedBy: "_").last
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    return name2!
}
func timeElapsed(_ date : Date)-> String{
    var elapsed = ""
    var seconds = Date().timeIntervalSince(date)
    if seconds < 60{
        elapsed = "just Now"
    }
    else if seconds < 60 * 60{
        let numOFMinutes = Int( seconds / 60)
        let minuteText =  (numOFMinutes > 1 ? "mins": "min")
        elapsed = "\(numOFMinutes)  \(minuteText)"
    }
    else if seconds < 60 * 60 * 24{
        let numHours = Int(seconds/(60*60))
        let hoursText = numHours > 1 ? "hours" : "hour"
        elapsed = "\(numHours) \(hoursText)"

    }
    else {
        elapsed = "\(date.longDate())"
    }
    
    return elapsed
}

func videoThumbnail(videoUrl: URL) -> UIImage {
    do {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return UIImage(systemName: "person")!
    }
}

