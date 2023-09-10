//
//  startChat.swift
//  Chat
//
//  Created by hesham abd elhamead on 12/08/2023.
//

import Foundation
import Firebase

func restartChat(chatRoomId : String,memberIds : [String]){
    FUserLisner.shared.downloadUsersFromfirestorge(withIDs: memberIds) { allUesers in // this is the bug
    
        if allUesers.count < 0 {    // this is the bug
         creatChatRooms(chatRoomId: chatRoomId, users: allUesers)
        }
    }
}
var allChatRoomsIDs : [String] = []



func startChat(sender : user,receiver : user )-> String{
    var chatRoomId = ""
    let value = sender.id.compare(receiver.id).rawValue
    
    chatRoomId = value < 0 ? (sender.id + receiver.id ) : (receiver.id + sender.id)
    
   // if  !allChatRoomsIDs.contains(chatRoomId){
        creatChatRooms(chatRoomId : chatRoomId , users : [ sender, receiver])
 //       allChatRoomsIDs.append(chatRoomId)
//    }
    
    return chatRoomId
}



func creatChatRooms(chatRoomId : String , users : [user]){
    
   var  userTocreateChatsFor : [String]
    userTocreateChatsFor = []
    
    for user in users {
        userTocreateChatsFor.append(user.id)
        
    }
    
    
    fireStoreReference(.Chat).whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { querysnapsnapshot , error  in
        guard let snapshot = querysnapsnapshot else{return}
        if !snapshot.isEmpty{
            for chatData in snapshot.documents{
                let curentChat = chatData.data() as Dictionary
                if let curentUserId = curentChat["senderId"]{
                    if userTocreateChatsFor.contains(curentUserId as! String){
                        userTocreateChatsFor.remove(at: userTocreateChatsFor.firstIndex(of: curentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in userTocreateChatsFor {
            
            let senderUser = userId == user.curentId ? user.currentUser! : getRecieverFrom(users: users)
            let recieverUser = userId == user.curentId ?    getRecieverFrom(users: users) : user.currentUser!
            let chatRoomObject = chatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id , senderName: senderUser.userName, recevierId: recieverUser.id, recevierName: recieverUser.userName, date: Date(), membersIds: [senderUser.id , recieverUser.id], lastMessage: "" , unReadedCounter: 0 , avtarLink: recieverUser.avatarLink)
            
            //TODO: save chat room 
            FChatRoomListener.shared.saveChatRoom(chatRoomObject)
        }
        
    }
    
}

func getRecieverFrom (users : [user])-> user {
    var allUsers = users
    allUsers.remove(at: allUsers.firstIndex(of: user.currentUser!)!)
    return allUsers.first!
}
