//
//  AuthService.swift
//  MasterFitness
//
//  Created by Chamidu on 18/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {

    public static let shared = AuthService()
    private init() {}

    /// Register the User
       /// - Parameters:
       ///   - userRequest: The User Info (email, password, username)
       ///   - completion: A completion with two values...
       ///   - Bool: wasRegistered - Determins if the user was registered and saved in DB
       ///   - Error?: An Optional Error if Firebase throws one
       public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?) ->Void){
           let username = userRequest.username
           let email = userRequest.email
           let password = userRequest.password

           Auth.auth().createUser(withEmail: email, password: password) { Result, error in
               if let error = error {
                   completion(false, error)
                   return
               }
               guard let resultUser = Result?.user else {
                   completion(false, nil)
                   return
               }

               let db = Firestore.firestore()

               db.collection("users")
                   .document(resultUser.uid)
                   .setData([
                       "username": username,
                       "email": email,
                       "isOnBoardingDone": false,
                   ]) { error in
                       if let error = error {
                           completion(false, error)
                           return
                       }
                       completion(true, nil)
                   }
           }
       }
    
    public func signIn(with userRequest : LoginUserRequest, completion: @escaping(Error?)->Void){
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

    public func signOut(completion: @escaping(Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        }catch let error {
            completion(error)
        }
    }

    public func forgotPassword(with email: String, completion: @escaping (Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }

    public func fetchUser(completion: @escaping(User?, Error?) -> Void){
        guard let userUID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()

        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let snapshot = snapshot,
                   let SnapshotData = snapshot.data(),
                   let username = SnapshotData["username"] as? String,
                   let email = SnapshotData["email"] as? String,
                   let isOnBoardingDone = SnapshotData["isOnBoardingDone"] as? Bool {
                    let user = User(username: username, email: email, userUID: userUID, isOnBoardingDone: isOnBoardingDone)
                    completion(user, nil)
                }
            }
    }
    
}
