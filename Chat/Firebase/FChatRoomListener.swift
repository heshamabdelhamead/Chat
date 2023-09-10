//
//  FChatRoomListener.swift
//  Chat
//
//  Created by hesham abd elhamead on 16/08/2023.
//

import Foundation
import Firebase
class FChatRoomListener {
    static let shared = FChatRoomListener()
    private init(){}
    func saveChatRoom(_ chatRoom : chatRoom ){
        do {
            try fireStoreReference(.Chat).document(chatRoom.id).setData(from: chatRoom)
        }
        catch{
            print("unable to save chat room" + error.localizedDescription )
        }
    }
    
    
    //MARK: download all chatRoom
    func downloadAllChatRooms(completion : @escaping ( _ chatRooms : [chatRoom])->Void){
        fireStoreReference(.Chat).whereField("senderId", isEqualTo: user.curentId).addSnapshotListener { snapshots, error in
            var chatRooms : [chatRoom] = []
            guard let documents = snapshots?.documents else{
               print("no chat room downloaded")
                return
            }
            
            let allChatRooms = documents.compactMap { QueryDocumentSnapshot in
                return try? QueryDocumentSnapshot.data(as: chatRoom.self)
                
            }
            for chatRoom in allChatRooms {
                if chatRoom.lastMessage != ""{
                    chatRooms.append(chatRoom)
                }
                chatRooms.sorted(by: {$0.date! > $1.date!})
                completion(chatRooms)
                    
            }
            
        }
        
    }
    func delelt (chatRoom : chatRoom){
        fireStoreReference(.Chat).document(chatRoom.id).delete()
    }
}
