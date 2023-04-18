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
}
