//
//  audioRecorder.swift
//  Chat
//
//  Created by hesham abd elhamead on 23/09/2023.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject,AVAudioRecorderDelegate{
    
    var recordSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    var isaudioRecordingGranted : Bool!
    
    static let shared = AudioRecorder()
    
     private override init() {
        super.init()
        checkForRecordPermission()
    }
    
    func checkForRecordPermission(){
        
        switch   AVAudioSession.sharedInstance().recordPermission{
            
        case .granted: isaudioRecordingGranted = true
            break
        case .denied: isaudioRecordingGranted = false
            break
        case .undetermined : AVAudioSession.sharedInstance().requestRecordPermission { permission in
            self.isaudioRecordingGranted = permission
        }
        default :
            break
        }
        
    }
    
    func setupRecord(){
        if isaudioRecordingGranted {
            
             recordSession = AVAudioSession.sharedInstance()
            do {
                try recordSession.setCategory(.playAndRecord , mode: .default )
                try recordSession.setActive(true)
                
            }
            catch
            {
                print ("error setting Up rcording session ", error.localizedDescription)
            }
            
        }
    }
    
    func startRecording(fileName: String){
        let audioFileName = getDoucmentDirectory().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        let settings = [ AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                       AVSampleRateKey: 12000,
                AVNumberOfChannelsKey : 1 ,
              AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                        
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            
            audioRecorder.record()
        }
        catch {
            
            print("error recording " + error.localizedDescription)
            finshRecording()
        }
        
    }
    
    
    
    
    func finshRecording(){
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
}
