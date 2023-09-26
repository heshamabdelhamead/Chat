//
//  FileStorage.swift
//  Chat
//
//  Created by hesham abd elhamead on 12/07/2023.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseStorage

let KFILEREFERENCE = "gs://chat-ae334.appspot.com/"
class fileStorage {
    class func uploadImage (_ image : UIImage,directory : String,completion : @escaping(_ doucmentLink: String?)->Void){
        // 1 - create a folder on fireStore
        
        let storageRef = Storage.storage().reference(forURL: KFILEREFERENCE).child(directory)
        // 2: - convert the image to data
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        // 3 : - put the data into firestore and return the link
        var task : StorageUploadTask!
        task = storageRef.putData(imageData!, completion: { metaData, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("error uploading image \(error!.localizedDescription)")
                return
            }
            storageRef.downloadURL { url , errror in
                guard let downloadURL = url else{
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
                
            }
        })
        //4. observe percentage upload
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount/snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    
    
    class func downloadImage(imageUrl : String ,completion :  @escaping(_ image : UIImage?)->Void ){
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        if fileExistAtPath(path: imageFileName){
            
            if let contentOffile = UIImage(contentsOfFile: fileInDoucmentDierctory(fileName: imageFileName)){
                completion(contentOffile)
            } else{
                print("could not convert image ")
                completion(UIImage(named: "avatar")!)
            }
            
        }
        else{
            if imageUrl != nil{
                let doucmentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue ")
                downloadQueue.async {
                    let data = NSData(contentsOf: doucmentUrl!)
                    if data != nil {
                        fileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }

                        }
                        
                    
                else{
                        print ("no doucment found in databasae")
                        completion(nil)
                    }
                }
            }
        }
            

    }
    //MARK: upload viedo
    
    class func uploadvideo (_ video : NSData,directory : String,completion : @escaping(_ doucmentLink: String?)->Void){
        // 1 - create a folder on fireStore
        
        let storageRef = Storage.storage().reference(forURL: KFILEREFERENCE).child(directory)
        
        
        // 3 : - put the data into firestore and return the link
        var task : StorageUploadTask!
        task = storageRef.putData(video as Data , completion: { metaData, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("error uploading video \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url , errror in
                guard let downloadURL = url else{
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
                
            }
        })
        //4. observe percentage upload
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount/snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    //MARK: upload audio
    
    class func uploadAudio (_ audioFileName : String ,directory : String ,completion : @escaping(_ audioLink : String?)->Void){
        // 1 - create a folder on fireStore
        let fileName = audioFileName + ".m4a"
        let storageRef = Storage.storage().reference(forURL: KFILEREFERENCE).child(directory)
        
        
        // 3 : - put the data into firestore and return the link
        
        var task : StorageUploadTask!
        
        if fileExistAtPath(path: fileName){
            print("hi from fileStorge")
            if let audioData = NSData(contentsOfFile: fileInDoucmentDierctory(fileName: fileName)){
                task = storageRef.putData(audioData as Data , completion: { metaData, error in
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    if error != nil{
                        print("error uploading audio \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url , errror in
                        guard let downloadURL = url else{
                            completion(nil)
                            return
                        }
                        completion(downloadURL.absoluteString)
                        
                    }
                })
                //4. observe percentage upload
                task.observe(StorageTaskStatus.progress) { snapshot in
                    let progress = snapshot.progress!.completedUnitCount/snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
                
            }
            else{
                print("nothing to upload file does not exist")
            }
        }
    }
    //MARK: download video
    
    class func downloadVideo (videoUrl : String ,completion :  @escaping(_ IsReadyTOPlay : Bool , _ videoFileName : String )->Void ){
        let videoFileName = fileNameFrom(fileUrl: videoUrl) + ".mov"
        
        if fileExistAtPath(path: videoFileName){
            
           completion(true,videoFileName)
            
        }
        else{
            if videoUrl != ""{
                let doucmentUrl = URL(string: videoUrl)
                let downloadQueue = DispatchQueue(label: "videoDownloadQueue ")
                downloadQueue.async {
                    let data = NSData(contentsOf: doucmentUrl!)
                    if data != nil {
                        fileStorage.saveFileLocally(fileData: data!, fileName: videoFileName)
                        
                        DispatchQueue.main.async {
                            completion(true,videoFileName)
                        }

                        }
                        
                    
                else{
                        print ("no doucment found in databasae")
                      }
                }
            }
        }
            

    }
    //MARK: downLoadAudio
    
    class func downloadAudio (audioUrl : String ,completion :  @escaping(_ audioFileName : String )->Void ){
        let audioFileName = fileNameFrom(fileUrl: audioUrl)
        
        if fileExistAtPath(path: audioFileName){
            
           completion(audioFileName)
            
        }
        else{
            if audioUrl != nil{
                let doucmentUrl = URL(string: audioUrl)
                let downloadQueue = DispatchQueue(label: "audioDownloadQueue ")
                downloadQueue.async {
                    let data = NSData(contentsOf: doucmentUrl!)
                    if data != nil {
                        fileStorage.saveFileLocally(fileData: data!, fileName: audioFileName)
                        
                        DispatchQueue.main.async {
                            completion(audioFileName)
                        }

                        }
                        
                    
                else{
                        print ("no doucment found in databasae")
                      }
                }
            }
        }
            

    }
    
    
    
    //MARK: - save file locally
    
    class func saveFileLocally(fileData: NSData,fileName : String){
        let url = getDoucmentDirectory().appendingPathComponent(fileName , isDirectory: false)
        fileData.write(to: url,atomically: true)
    }
}


func getDoucmentDirectory()->URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDoucmentDierctory(fileName : String)-> String{
    return getDoucmentDirectory().appendingPathComponent(fileName).path
}


func fileExistAtPath(path : String)-> Bool{
    return FileManager.default.fileExists(atPath: fileInDoucmentDierctory(fileName: path)) 
}
