//
//  FCollectionReference.swift
//  Chat
//
//  Created by hesham abd elhamead on 30/06/2023.
//

import Foundation
import Firebase
enum collections : String{
    case user
    case Chat
    case Message
    case Typing
}

//let db = Firestore.firestore()
//
//db.collection("user").addDocument(data: <#T##[String : Any]#>)

func fireStoreReference( _ collectionsReference :collections)-> CollectionReference{
    
return Firestore.firestore().collection(collectionsReference.rawValue)
    
    
}


//fireStoreReference(collectionsReference: .ueser)
