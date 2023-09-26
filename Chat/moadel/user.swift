//
//  User.swift
//  Chat
//
//  Created by hesham abd elhamead on 30/06/2023.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct user : Codable , Equatable {
    
    var id = ""
    var userName : String
    var emial : String
    var pushId = ""
    var avatarLink = ""
    var status : String 
    
    
    static  var currentUser : user? {
        
        if Auth.auth().currentUser != nil {
            
            if let data = UserDefaults.standard.data(forKey: "currentUser"){
                
                let decodeer = JSONDecoder()
                do{
                    let userData = try decodeer.decode(user.self ,from: data )
                    return userData
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
        }
         return nil 
    }
    
    
    static var curentId : String{
        return Auth.auth().currentUser!.uid
    }
    
    
    
    static func == (lhs : user , rhs : user)->Bool {
       
        lhs.id == rhs.id
    }
    
    
    
    
    
}
//func saveUserLocally(user : user){
//    let encoder = JSONEncoder()
//    do{
//        let data = try encoder.encode(user)
//        UserDefaults.setValue(data, forKey: curentUser)
//    }
//    catch{
//        print(error.localizedDescription)
//    }
//
//}


func saveUserLocally(user: user) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.setValue(data, forKey: "currentUser")
    } catch {
        print(error.localizedDescription)
    }
}

func createDummyUsers(){
    let names = ["joshua-rondeau","andre-sebastian","kirill-balobanov","renato-marque"]
    var imageIndex = 1
    var userIndex = 1
    for i in 0..<4{
        let id = UUID().uuidString
        let fileDierctory = "Avatars/" + "_\(id)" + ".jpg"
        fileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDierctory) { avatarLink in
            let user = user(id: id, userName: names[i], emial: "user\(userIndex)@mail.com", pushId: "", avatarLink: avatarLink ?? "", status: "no status")
            
            userIndex += 1
            FUserLisner.shared.saveUserTofirestore(user)
            
        }
        imageIndex += 1
        if imageIndex == 5{
            imageIndex = 1
        }
    }
}
