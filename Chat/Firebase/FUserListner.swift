//
//  FUserListner.swift
//  Chat
//
//  Created by hesham abd elhamead on 30/06/2023.
//

import Foundation
import Firebase


class FUserLisner{
    static let shared = FUserLisner()
    private init(){}
    //MARK: - login
    func loginUserWith(email : String,Password:String ,completion : @escaping (_ error: Error? ,_ isEmailVerified : Bool)->Void){
        Auth.auth().signIn(withEmail: email, password: Password) { authResults, error in
            if error == nil && authResults?.user.isEmailVerified == true {
                completion(error,true)
                self.downloadUserFromFirestore(userId: authResults!.user.uid)
                
            }
            else{
                completion(error,false)
            }
        }
    }
    
    //MARK: - register
    func registerUserWith(email : String,password : String , completion : @escaping (_ error : Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) {[self] (authResults, error ) in
            completion(error)
            print(error)
            if error == nil{
                
                authResults!.user.sendEmailVerification{(error) in
                    completion(error)
                    
                }
            }
            if authResults?.user != nil{
                print("saveUserTofirestore(user)")
                
                let user = user(id:authResults!.user.uid , userName: email, emial: email ,pushId: "",avatarLink: "", status: "iam using dardsh")
                saveUserTofirestore(user)
                saveUserLocally (user : user)
                
            }
        }
        
    }
    //MARK: - resend  email verfication
    func resendEmailVerification (eamil :String,completion : @escaping(_ error : Error?)->Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error )
                
            })
        })
    }
    
    //MARK: - resetforgetPassword
    func resetpassword(email : String ,completion : @escaping(_ error : Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    
    //MARK: - save user to firestore
    func saveUserTofirestore(_ user : user){
        do{
            try    fireStoreReference( .user).document(user.id).setData(from: user)
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    // MARK: - this function for downloding user data form firestore to updata the userDefault value
    private func downloadUserFromFirestore(userId : String){
        fireStoreReference(.user).document(userId).getDocument { doucment, error in
            guard let userDoucment = doucment else{
                print("no data founded ")
                return
            }
            let result = Result{
                try? userDoucment.data(as: user.self)
            }
            switch result{
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user: user)
                }else{
                    print("doucment dose not exist")
                }
            case .failure(let error ):
                print("errror decoding User", error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - logout
    func logoutFromUser(compeletion : @escaping(_ error : Error?)->Void){
        do {
            
            
            try   Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey:  "currentUser")
            UserDefaults.standard.synchronize()
            compeletion(nil)
        }
        catch let error as NSError{
            compeletion(error)
            
        }
        
    }
    //MARK: download users using Ids
    func downloadUsersFromfirestorge(withIDs :[String],completion : @escaping(_ allUesers : [user])-> Void){
        var count = 0
        var usersArray : [user]=[]
        for userId in withIDs{
            fireStoreReference(.user).document(userId).getDocument { (querySnapshot, error) in
                guard let doucment = querySnapshot else{return}
                //do{
                let user = try? doucment.data(as:user.self)
                usersArray.append(user!)
                count += 1
                if count == withIDs.count{
                    completion(usersArray)
                    //  }
                    
                }
                //                catch{
                //                    print(error.localizedDescription)
                //                }
                
                
            }
            
        }
    }
    
    //MARK: download all uesers
    func downloadAllUsersFromFireStroge(completion : @escaping( _ allUsers : [user])->Void){
        var users : [user] = []
        
        fireStoreReference(.user).getDocuments { snapshots, error in
            
            guard let doucments = snapshots?.documents else{
                print("cant download users ")
                return
            }
            let allUesrs = doucments.compactMap { (snapshot)->user? in
                return try? snapshot.data(as: user.self)
            }
            let curentUserId = user.curentId
            
            for user  in allUesrs {
                
                if curentUserId != user.id  {
                users.append(user)
                
                     }
            }
            completion(users)
        }
        
        
    }
    
}




