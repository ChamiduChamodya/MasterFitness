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
       ///   - userRequest: The User Info (email, password, username,height,weight,fitnessGoal,age,bmi)
       ///   - completion: A completion with two values...
       ///   - Bool: wasRegistered - Determins if the user was registered and saved in DB
       ///   - Error?: An Optional Error if Firebase throws one
       public func registerUser(with userRequest: RegisterUserDetailRequest, completion: @escaping(Bool, Error?) ->Void){
           let username = userRequest.username
           let email = userRequest.email
           let password = userRequest.password
           let height = userRequest.height
           let weight = userRequest.weight
           let goal = userRequest.fitnessGoal
           let age = userRequest.age
           let bmi = userRequest.bmi
           
           let workoutPlan = getWorkOutPlan(weight: weight)
           
           print("workout plan \(workoutPlan)")

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
                       "height": height,
                       "weight": weight,
                       "fitnessGoal": goal,
                       "age": age,
                       "bmi": bmi,
                       "userWorkoutPlan": workoutPlan
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

    public func forgotPassword(with email: String, completion: @escaping (Error?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
        
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            completion(error)
//        }
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
                   let email = SnapshotData["email"] as? String {
                    let user = User(username: username, email: email, userUID: userUID)
                    completion(user, nil)
                }
            }
    }
    
    public func fetchWokoutsBegginer(completion: @escaping(Workout?, Error?) -> Void){
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let db = Firestore.firestore()

        db.collection("workouts")
            .document("beginner")
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let snapshot = snapshot,
                   let SnapshotData = snapshot.data(),
                   let abs = SnapshotData["abs"],
                   let arm = SnapshotData["arm"],
                   let chest = SnapshotData["chest"],
                   let leg = SnapshotData["leg"],
                   let shoulderAndback = SnapshotData["shoulder&back"] {
                    let workout = Workout(abs: abs, arm: arm, chest: chest, leg: leg, shoulderandBack: shoulderAndback)
                    completion(workout, nil)
                }
            }
    }
    
    public func fetchWokoutsIntermediate(completion: @escaping(Workout?, Error?) -> Void){
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let db = Firestore.firestore()

        db.collection("workouts")
            .document("beginner")
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let snapshot = snapshot,
                   let SnapshotData = snapshot.data(),
                   let abs = SnapshotData["abs"],
                   let arm = SnapshotData["arm"],
                   let chest = SnapshotData["chest"],
                   let leg = SnapshotData["leg"],
                   let shoulderAndback = SnapshotData["shoulder&back"] {
                    let workout = Workout(abs: abs, arm: arm, chest: chest, leg: leg, shoulderandBack: shoulderAndback)
                    completion(workout, nil)
                }
            }
    }
    
    @objc private func getWorkOutPlan(weight: String) -> [String : [Any]] {
        
        let weightValue: Int = Int(weight) ?? 0
        
        if weightValue <= 60 {
            return [
                "abs": [
                    [
                    "exercise": "Bicycle Crunches",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank",
                    "reps": "2",
                    "time": "30"
                    ],
                    [
                    "exercise": "Mountain Climbers",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Push-Ups",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Dumbbell Bench Press",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Dips",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Bicep Curls",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Dips",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hammer Curls",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Squats",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lunges",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "12",
                    "time": "30"
                    ]
                ]
            ]
        }else if weightValue > 60 && weightValue <= 70 {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "2",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "12",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "12",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ]
            ]
        }else if weightValue > 70 && weightValue <= 80 {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ]
            ]
        }else if weightValue > 80 && weightValue <= 90 {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "15",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "15",
                    "time": "30"
                    ]
                ]
            ]
        }else if weightValue > 90 && weightValue <= 100 {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ]
            ]
        }else {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30"
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "16",
                    "time": "30"
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "16",
                    "time": "30"
                    ]
                ]
            ]
        }
    }
    
}
