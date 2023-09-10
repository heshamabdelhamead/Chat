//
//  gloableFunctions.swift
//  Chat
//
//  Created by hesham abd elhamead on 26/07/2023.
//

import Foundation
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
