//
//  FTypingLisntener.swift
//  Chat
//
//  Created by hesham abd elhamead on 03/09/2023.
//

import Foundation
import Firebase

class FTypeListener{
   static  let shared = FTypeListener()
    var TypeListener : ListenerRegistration!
    private init(){}
    func createTypeObserver(chatRoomId : String, completion : @escaping(_ isTyping : Bool)->Void){
        TypeListener = fireStoreReference(.Typing).document(chatRoomId).addSnapshotListener({ doucmnetsnapShot, error in
            guard let snapshot = doucmnetsnapShot else{return}
            if snapshot.exists{
                for data in snapshot.data()!{
                    if data.key != user.curentId{
                        completion(data.value as! Bool)
                    }
                }
            }
            else{
                completion(false)
                fireStoreReference(.Typing).document(chatRoomId).setData([user.curentId : false])
            }
        })
    }
    class func saveTypeIndictor(typing : Bool,chatRoomId: String){
        fireStoreReference(.Typing).document(chatRoomId).updateData([user.curentId: typing])
    }
    func  removeTypingListener(){
        self.TypeListener.remove()
    }
    
    
}
