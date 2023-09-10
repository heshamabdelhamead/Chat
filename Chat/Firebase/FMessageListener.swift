//
//  FMessageListener.swift
//  Chat
//
//  Created by hesham abd elhamead on 22/08/2023.
//

import Foundation
import Firebase

class FMessageListener{
    static let Shared = FMessageListener()
    private init(){}
    var newMessageLisener : ListenerRegistration!
    
    func addMessage(message : localMessage, memberId: String){
        do{
            try fireStoreReference(.Message).document(memberId).collection(message.chatRoomId).document(message.Id).setData(from:message)
        }
        catch {
            print("error saving message to fireStorge",error.localizedDescription)
        }
    }
    
    //MARK: add old Messages form firestore
    
    func checkForOldMessage(documentId : String, collectionId: String){
        fireStoreReference(.Message).document(documentId).collection(collectionId).getDocuments { snapshot, error in
               
                guard let  doucments  = snapshot?.documents else{return}
                var oldMessages = doucments.compactMap({ doucment in
                    
               return    try? doucment.data(as: localMessage.self)
                })
            oldMessages.sort(by: {$0.date < $1.date})           // change here
            
            for message in oldMessages{
                RealmManager.Shared.save(message)
            }
            
        }
    }
    func listenForNewMessage(doucmentId: String,collectionId: String,lastMessageDate : Date){
        newMessageLisener = fireStoreReference(.Message).document(doucmentId).collection(collectionId).addSnapshotListener({ querySnapshot, error in
            guard let ListenerSnapshout = querySnapshot else{return}
            
            for change in ListenerSnapshout.documentChanges{
                if   change.type == .added{
                    let result = Result{
                        try? change.document.data(as: localMessage.self)
                        
                    }
                    switch result{
                        
                    case .success(let objectMessage):
                        
                        if let message = objectMessage {
                            if message.senderId != user.curentId{
                                RealmManager.Shared.save(message)
                            }
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    
                        
                    
                        
                    }
                    
                }
            }
        })
        
    }
    
    func  removeMessageListener(){
        self.newMessageLisener.remove()
    }
    
    
    
}
