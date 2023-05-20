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
                   let email = SnapshotData["email"] as? String,
                   let userWorkoutPlan = SnapshotData["userWorkoutPlan"] as? [String: [[String: Any]]]{
                    let user = User(username: username, email: email, userUID: userUID, userWorkoutPlan: userWorkoutPlan)
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
                   let workoutPlan = SnapshotData["workoutPlan"] as? [String: [[String: Any]]] {
                    let workout = Workout(workoutPlan: workoutPlan)
                    completion(workout, nil)
                }
            }
    }
    
    public func fetchWokoutsIntermediate(completion: @escaping(Workout?, Error?) -> Void){
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let db = Firestore.firestore()

        db.collection("workouts")
            .document("intermediate")
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let snapshot = snapshot,
                   let SnapshotData = snapshot.data(),
                   let workoutPlan = SnapshotData["workoutPlan"] as? [String: [[String: Any]]] {
                    let workout = Workout(workoutPlan: workoutPlan)
                    completion(workout, nil)
                }
            }
    }
    
    public func fetchWokoutsAdvanced(completion: @escaping(Workout?, Error?) -> Void){
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let db = Firestore.firestore()

        db.collection("workouts")
            .document("advanced")
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let snapshot = snapshot,
                   let SnapshotData = snapshot.data(),
                   let workoutPlan = SnapshotData["workoutPlan"] as? [String: [[String: Any]]] {
                    let workout = Workout(workoutPlan: workoutPlan)
                    completion(workout, nil)
                }
            }
    }
    
    @objc private func getWorkOutPlan(weight: String) -> [String: [[String: Any]]] {
        
        let weightValue: Int = Int(weight) ?? 0
        
        if weightValue <= 60 {
            return [
                "abs": [
                    [
                    "exercise": "Bicycle Crunches",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/qMGYQbAaPpw",
                    "howTo": "Lie on your back with your hands placed lightly behind your head and your knees bent. Lift your head, shoulder blades, and feet off the ground. Straighten your right leg while twisting your torso to bring your left elbow towards your right knee. Alternate by straightening your left leg and bringing your right elbow towards your left knee. Continue alternating in a pedaling motion.",
                    "effectivePart": "Abdominal muscles, including the rectus abdominis, obliques, and hip flexors."
                    ],
                    [
                    "exercise": "Plank",
                    "reps": "2",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/0G_OI6oVzLA",
                    "howTo": "Start by getting into a push-up position with your hands directly under your shoulders and your toes on the ground. Engage your core, squeeze your glutes, and keep your body in a straight line from head to toe. Hold this position, keeping your abdominals and glutes contracted, while avoiding sagging or lifting your hips. Aim to maintain the plank for a desired duration, such as 30 seconds to 1 minute.",
                    "effectivePart": "Core muscles, including the rectus abdominis, transverse abdominis, obliques, and lower back muscles. Also engages the shoulders, chest, and glutes as stabilizing muscles."
                    ],
                    [
                    "exercise": "Mountain Climbers",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/9yyKVy8OWnA",
                    "howTo": "Start in a push-up position with your hands directly under your shoulders and your body in a straight line. Engage your core and bring one knee towards your chest, then quickly switch legs, alternating in a running motion. Keep your hips low and your upper body stable throughout the exercise.",
                    "effectivePart": "Full-body exercise that primarily targets the core muscles, including the rectus abdominis, obliques, and hip flexors. Also engages the shoulders, chest, and leg muscles."
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Push-Ups",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/yQEx9OC2C3E",
                    "howTo": "Start in a plank position with your hands slightly wider than shoulder-width apart, fingers pointing forward. Lower your chest towards the ground by bending your elbows, keeping your body in a straight line. Push back up to the starting position and repeat.",
                    "effectivePart": "Chest muscles (pectoralis major and minor), shoulders, triceps, and core muscles."
                    ],
                    [
                    "exercise": "Dumbbell Bench Press",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/2AopA8XXMDw",
                    "howTo": "Lie on a flat bench with a dumbbell in each hand, palms facing forward. Position the dumbbells at shoulder level. Push the dumbbells upward, extending your arms while keeping your wrists straight. Lower the dumbbells back down to the starting position in a controlled manner.",
                    "effectivePart": "Chest muscles (pectoralis major and minor), shoulders, and triceps."
                    ],
                    [
                    "exercise": "Chest Dips",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/NuhXmq6x9Sk",
                    "howTo": "Position yourself between parallel bars with your arms fully extended and your feet off the ground. Lower your body by bending your elbows, keeping them close to your sides, until your upper arms are parallel to the ground. Push yourself back up to the starting position by extending your arms.",
                    "effectivePart": "Chest muscles (pectoralis major and minor), shoulders, and triceps."
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Bicep Curls",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/2ZlISIiQJ4Y",
                    "howTo": "Stand tall with a dumbbell in each hand, palms facing forward and arms fully extended by your sides. Keep your elbows close to your sides and your upper arms stationary. Curl the dumbbells upward by flexing your elbows, contracting your biceps. Continue the curling motion until the dumbbells reach shoulder level. Pause briefly, then slowly lower the dumbbells back down to the starting position.",
                    "effectivePart": "Biceps brachii (the two-headed muscle in the upper arm) and forearm muscles."
                    ],
                    [
                    "exercise": "Tricep Dips",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/SpSE_A5L-YA",
                    "howTo": "Sit on the edge of a stable bench or chair with your hands gripping the edge, fingers facing forward. Walk your feet forward and extend your legs. Lower your body by bending your elbows until your upper arms are parallel to the ground. Push back up to the starting position and repeat.",
                    "effectivePart": "Triceps, shoulders, and chest muscles."
                    ],
                    [
                    "exercise": "Hammer Curls",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/vpRngzQA0v0",
                    "howTo": "Stand tall with a dumbbell in each hand, palms facing your torso. Keeping your elbows close to your sides, curl the dumbbells upward while maintaining a neutral grip (palms facing each other). Lower the dumbbells back down to the starting position in a controlled manner.",
                    "effectivePart": "Biceps brachii, brachialis, and forearm muscles."
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Squats",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/SLOkdLLWj8A",
                    "howTo": "Stand with your feet shoulder-width apart or slightly wider, toes pointing forward or slightly outward. Lower your body by bending your knees and pushing your hips back, as if sitting back into a chair. Keep your chest lifted and your weight on your heels. Straighten your legs and return to the starting position, squeezing your glutes at the top. Repeat.",
                    "effectivePart": "Leg muscles, including quadriceps, hamstrings, and glutes, as well as core muscles for stability."
                    ],
                    [
                    "exercise": "Lunges",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/LCWWq3Lx2Sk",
                    "howTo": "Stand tall with your feet hip-width apart. Take a step forward with one leg, lowering your body until both knees are bent at a 90-degree angle. Push through your front heel to return to the starting position. Alternate legs and repeat.",
                    "effectivePart": "Leg muscles, including the quadriceps, hamstrings, and glutes."
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "12",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/fOfPwmb5FXU",
                    "howTo": "Stand with your feet hip-width apart and your toes pointing forward. Raise your heels off the ground by extending your ankles as high as possible. Hold the raised position for a moment, then lower your heels back down to the ground.",
                    "effectivePart": "Calf muscles (gastrocnemius and soleus)."
                    ]
                ],
                "shoulder&back": [
                [
                "exercise": "Shoulder Press",
                "reps": "12",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/dyv6g4xBFGU",
                "howTo": "To perform the Shoulder Press exercise, follow these steps: Stand or sit with your back straight and core engaged. Hold a dumbbell in each hand at shoulder level, palms facing forward. Press the dumbbells upward until your arms are fully extended overhead. Slowly lower the dumbbells back to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "The Shoulder Press primarily targets the deltoid muscles, particularly the anterior deltoids (front of the shoulders). It also engages the trapezius, triceps, and upper chest muscles to a lesser extent."
                ],
                [
                "exercise": "Bent-Over Rows",
                "reps": "12",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/dD-jK2l_zQE",
                "howTo": "To perform Bent-Over Rows, follow these steps: Stand with your feet shoulder-width apart, knees slightly bent. Hold a dumbbell in each hand with your palms facing your body, and hinge forward at the hips while keeping your back straight. Let your arms hang straight down toward the floor, maintaining a slight bend in your elbows. Engage your back muscles and pull the dumbbells up toward your torso, squeezing your shoulder blades together. Lower the dumbbells back to the starting position in a controlled manner. Repeat for the desired number of repetitions.",
                "effectivePart": "Bent-Over Rows target the muscles in your upper back, including the latissimus dorsi (lats), rhomboids, and trapezius. It also engages the biceps, rear deltoids, and the muscles in your lower back and core for stability."
                ],
                [
                "exercise": "Lateral Raises",
                "reps": "12",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/G-piLwLu0d4",
                "howTo": "To perform Lateral Raises, follow these steps: Stand with your feet shoulder-width apart, knees slightly bent. Hold a dumbbell in each hand, palms facing inward and resting at your sides. Keeping a slight bend in your elbows, raise your arms out to the sides until they are parallel to the floor. Pause briefly at the top, then lower your arms back down to the starting position in a controlled manner. Repeat for the desired number of repetitions.",
                "effectivePart": "Lateral Raises primarily target the lateral deltoids (middle shoulder muscles). They also engage the anterior deltoids and other stabilizing muscles in the shoulders and upper back, such as the trapezius and rotator cuff muscles."
                ]
                ]
            ]
        }else if weightValue > 60 && weightValue <= 70 {
            return [
                "abs": [
                  [
                  "exercise": "Russian Twists",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/ukjB-FoEy2Q",
                  "howTo": "To perform Russian Twists, follow these steps: Sit on the floor with your knees bent and feet flat on the ground. Lean back slightly while keeping your back straight. Hold your hands together in front of your chest or hold a weight or medicine ball. Lift your feet off the ground, balancing on your sit bones. Twist your torso to the right, bringing your hands or the weight to the right side of your body. Pause briefly, then twist to the left side. Repeat this twisting motion for the desired number of repetitions.",
                  "effectivePart": "Russian Twists primarily target the oblique muscles (side abdominal muscles). They also engage the rectus abdominis (six-pack muscles) and the deeper transverse abdominis muscles for stability."
                  ],
                  [
                  "exercise": "Plank with Leg Raises",
                  "reps": "2",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/watch?v=EpHPUI4gx58",
                  "howTo": "To perform Plank with Leg Raises, follow these steps: Start in a plank position with your forearms on the ground and your body in a straight line from head to heels. Engage your core and glutes to maintain stability. Lift one leg off the ground while keeping it straight and parallel to the floor. Hold for a moment, then lower the leg back down. Repeat with the opposite leg. Continue alternating leg raises for the desired number of repetitions.",
                  "effectivePart": "Plank with Leg Raises primarily targets the core muscles, including the rectus abdominis, transverse abdominis, and obliques. It also engages the glutes and lower back muscles for stability."
                  ],
                  [
                  "exercise": "Hanging Leg Raises",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/7DoFMV1Dnow",
                  "howTo": "To perform Hanging Leg Raises, follow these steps: Find a pull-up bar or sturdy overhead bar. Hang from the bar with your arms fully extended and your shoulders engaged. Keep your legs together and lift them upward by flexing your hips and bending your knees. Continue raising your legs until they are parallel to the floor or as high as you can comfortably go. Slowly lower your legs back down to the starting position. Repeat for the desired number of repetitions.",
                  "effectivePart": "Hanging Leg Raises primarily target the lower abs and hip flexors. They also engage the upper abs, obliques, and hip extensors to a lesser extent."
                  ]
                ],
                "chest": [
                  [
                  "exercise": "Decline Push-Ups",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/watch?v=QuaOc1mFcqs",
                  "howTo": "To perform Decline Push-Ups, follow these steps: Place your feet on an elevated surface such as a bench or step, while assuming a push-up position with your hands slightly wider than shoulder-width apart on the ground. Keep your body in a straight line from head to heels. Lower your chest towards the ground by bending your elbows, while keeping your core engaged and glutes tight. Push back up to the starting position by extending your arms. Repeat for the desired number of repetitions.",
                  "effectivePart": "Decline Push-Ups primarily target the upper chest muscles (pectoralis major) and also engage the triceps, front shoulders (anterior deltoids), and core muscles."
                  ],
                  [
                  "exercise": "Barbell Bench Press",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/0cXAp6WhSj4",
                  "howTo": "To perform Barbell Bench Press, follow these steps: Lie flat on a bench with your feet firmly on the ground and your back and head supported. Grasp the barbell with an overhand grip slightly wider than shoulder-width apart. Unrack the barbell and lower it towards your chest while keeping your elbows at a 90-degree angle. Press the barbell back up to the starting position by extending your arms. Repeat for the desired number of repetitions.",
                  "effectivePart": "Barbell Bench Press primarily targets the pectoralis major (chest muscles) and also engages the triceps, front shoulders (anterior deltoids), and the muscles in your upper back and core for stability."
                  ],
                  [
                  "exercise": "Chest Flyes",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/Jz7oEmzhnfE",
                  "howTo": "To perform Chest Flyes, follow these steps: Lie flat on a bench with a dumbbell in each hand. Extend your arms upward above your chest with a slight bend in your elbows. Lower the dumbbells out to the sides in a wide arc until your chest muscles are stretched. Maintain a slight bend in your elbows throughout the movement. Bring the dumbbells back up to the starting position by squeezing your chest muscles. Repeat for the desired number of repetitions.",
                  "effectivePart": "Chest Flyes primarily target the pectoralis major (chest muscles), particularly the outer chest. They also engage the front shoulders (anterior deltoids) and the muscles in your upper back and core for stability."
                  ]
                ],
                "arm": [
                  [
                  "exercise": "Barbell Bicep Curls",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/2ZlISIiQJ4Y",
                  "howTo": "To perform Barbell Bicep Curls, follow these steps: Stand with your feet shoulder-width apart and hold a barbell with an underhand grip, palms facing upward. Keep your upper arms close to your sides and your elbows locked in position. Curl the barbell upward by flexing your elbows while keeping your upper arms stationary. Continue lifting until your biceps are fully contracted and the barbell is at shoulder level. Slowly lower the barbell back down to the starting position. Repeat for the desired number of repetitions.",
                  "effectivePart": "Barbell Bicep Curls primarily target the biceps brachii (front upper arm muscles). They also engage the brachialis and brachioradialis muscles to a lesser extent."
                  ],
                  [
                  "exercise": "Tricep Pushdowns",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/WjLJ7zIppXQ",
                  "howTo": "To perform Tricep Pushdowns, follow these steps: Stand in front of a cable machine with your feet shoulder-width apart. Grasp the cable attachment with an overhand grip, palms facing down. Keep your elbows close to your sides and your upper arms stationary. Push the cable down by fully extending your elbows until your arms are straight. Contract your triceps at the bottom of the movement. Slowly release and allow the cable to return to the starting position. Repeat for the desired number of repetitions.",
                  "effectivePart": "Tricep Pushdowns primarily target the triceps brachii (back of the upper arm muscles). They also engage the anconeus muscle and to a lesser extent, the muscles of the shoulders and forearms."
                  ],
                  [
                  "exercise": "Skull Crushers",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/gTrlbuuMufQ",
                  "howTo": "To perform Skull Crushers, follow these steps: Lie flat on a bench with a barbell or dumbbells. Hold the weight(s) with an overhand grip, palms facing away from your body. Extend your arms upward above your chest, keeping a slight bend in your elbows. Lower the weight(s) toward your forehead by bending your elbows. Keep your upper arms stationary throughout the movement. Extend your arms back to the starting position by contracting your triceps. Repeat for the desired number of repetitions.",
                  "effectivePart": "Skull Crushers primarily target the triceps brachii (back of the upper arm muscles). They also engage the muscles of the shoulders, chest, and core for stability."
                  ]
                ],
                "leg": [
                  [
                  "exercise": "Barbell Squats",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/unQgFZTOfLU",
                  "howTo": "To perform Barbell Squats, follow these steps: Stand with your feet shoulder-width apart and place a barbell across your upper back, resting it on your traps or rear delts. Engage your core and keep your chest up. Bend your knees and lower your body into a squat position, as if sitting back into a chair. Keep your knees in line with your toes and your heels planted on the ground. Go as low as you comfortably can, ideally until your thighs are parallel to the ground. Push through your heels and extend your legs to return to the starting position. Repeat for the desired number of repetitions.",
                  "effectivePart": "Barbell Squats primarily target the quadriceps (front of the thigh muscles), hamstrings, and glutes. They also engage the muscles of the calves, lower back, and core for stability."
                  ],
                  [
                  "exercise": "Romanian Deadlifts",
                  "reps": "12",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/d-hn_0sEpRQ",
                  "howTo": "To perform Romanian Deadlifts, follow these steps: Stand with your feet shoulder-width apart and hold a barbell or dumbbells in front of your thighs with an overhand grip. Engage your core and keep your back straight. Hinge at the hips and lower the weight(s) by pushing your hips backward and allowing your knees to bend slightly. Keep your back straight and chest up as you lower the weight(s) toward the ground, feeling a stretch in your hamstrings. Lower the weight(s) until you feel a comfortable stretch or until they reach mid-shin level. Push through your heels and extend your hips to return to the starting position. Repeat for the desired number of repetitions.",
                  "effectivePart": "Romanian Deadlifts primarily target the hamstrings, glutes, and lower back muscles. They also engage the muscles of the calves and core for stability."
                  ],
                  [
                  "exercise": "Calf Raises",
                  "reps": "15",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/fOfPwmb5FXU",
                  "howTo": "To perform Calf Raises, follow these steps: Stand with your feet shoulder-width apart and place the balls of your feet on an elevated surface such as a step or block. Keep your core engaged and your hands resting on a wall or holding a stable object for balance. Rise up onto your toes by extending your ankles, lifting your heels off the ground. Pause briefly at the top, then slowly lower your heels back down until you feel a stretch in your calves. Repeat for the desired number of repetitions.",
                  "effectivePart": "Calf Raises primarily target the gastrocnemius and soleus muscles, which make up the calf muscles. They also engage the muscles of the ankles and feet for stability."
                  ]
                ],
                "shoulder&back": [
                  [
                  "exercise": "Shoulder Press",
                  "reps": "15",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/dyv6g4xBFGU",
                  "howTo": "To perform Shoulder Press, follow these steps: Stand with your feet shoulder-width apart and hold a barbell or dumbbells at shoulder level with an overhand grip. Engage your core and keep your back straight. Push the weight(s) overhead by extending your arms until they are fully extended. Avoid arching your lower back or shrugging your shoulders. Lower the weight(s) back down to shoulder level with control. Repeat for the desired number of repetitions.",
                  "effectivePart": "Shoulder Press primarily targets the deltoid muscles (shoulders), specifically the front (anterior) and middle (lateral) deltoids. It also engages the triceps and muscles of the upper back and core for stability."
                  ],
                  [
                  "exercise": "Bent-Over Rows",
                  "reps": "15",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/dD-jK2l_zQE",
                  "howTo": "To perform Bent-Over Rows, follow these steps: Stand with your feet shoulder-width apart and hold a barbell or dumbbells with an overhand grip. Bend your knees slightly and hinge forward at the hips while keeping your back straight. Let the weight(s) hang in front of you with your arms fully extended. Pull the weight(s) toward your upper abdomen by retracting your shoulder blades and bending your elbows. Squeeze your back muscles at the top of the movement. Lower the weight(s) back down to the starting position with control. Repeat for the desired number of repetitions.",
                  "effectivePart": "Bent-Over Rows primarily target the muscles of the upper back, including the latissimus dorsi (lats), rhomboids, and trapezius. They also engage the muscles of the biceps and core for stability."
                  ],
                  [
                  "exercise": "Lateral Raises",
                  "reps": "15",
                  "time": "30",
                  "videoURL": "https://www.youtube.com/shorts/G-piLwLu0d4",
                  "howTo": "To perform Lateral Raises, follow these steps: Stand with your feet shoulder-width apart and hold a dumbbell in each hand by your sides with your palms facing inward. Engage your core and keep your back straight. Lift the dumbbells out to the sides with a slight bend in your elbows, until your arms are parallel to the floor. Maintain control and avoid swinging or using momentum. Lower the dumbbells back down to the starting position with control. Repeat for the desired number of repetitions.",
                  "effectivePart": "Lateral Raises primarily target the lateral deltoids (side shoulder muscles). They also engage the front deltoids (anterior deltoids), rear deltoids (posterior deltoids), and the muscles of the upper back and core for stability."
                  ]
                ]
            ]
        }else if weightValue > 70 && weightValue <= 80 {
            return [
                "abs": [
                [
                "exercise": "Russian Twists",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/ukjB-FoEy2Q",
                "howTo": "Sit on the floor with your knees bent and feet elevated slightly off the ground. Lean back slightly while maintaining a straight back. Hold your hands together in front of your chest. Twist your torso to the right, bringing your hands to the right side of your body. Then, twist to the left, bringing your hands to the left side of your body. Repeat this twisting motion for the desired number of repetitions.",
                "effectivePart": "Russian Twists primarily target the oblique muscles, which are responsible for rotational movements of the torso. They also engage the rectus abdominis (six-pack muscles) and the muscles of the lower back for stability."
                ],
                [
                "exercise": "Plank with Leg Raises",
                "reps": "5",
                "time": "30",
                "videoURL": "https://www.youtube.com/watch?v=EpHPUI4gx58",
                "howTo": "Start in a plank position with your forearms on the ground and your body in a straight line from head to heels. Engage your core muscles and lift one leg off the ground, keeping it straight and parallel to the floor. Hold this position for a moment, then lower the leg back down and repeat with the other leg. Alternate lifting each leg for the desired number of repetitions.",
                "effectivePart": "Plank with Leg Raises primarily targets the core muscles, including the rectus abdominis, obliques, and transverse abdominis. It also engages the muscles of the shoulders, arms, and glutes for stability."
                ],
                [
                "exercise": "Hanging Leg Raises",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/7DoFMV1Dnow",
                "howTo": "Hang from a pull-up bar with your arms fully extended and your shoulders relaxed. Engage your core muscles and lift your legs up by bending at the hips and knees, bringing your thighs towards your chest. Pause at the top of the movement, then slowly lower your legs back down to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Hanging Leg Raises primarily target the lower abdominal muscles (lower abs) and hip flexors. They also engage the muscles of the upper abs, obliques, and lower back for stability."
                ]
                ],
                "chest": [
                [
                "exercise": "Decline Push-Ups",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/watch?v=QuaOc1mFcqs",
                "howTo": "Assume a push-up position with your feet elevated on a bench or step, forming a decline angle. Place your hands slightly wider than shoulder-width apart on the floor. Lower your chest towards the ground by bending your elbows, keeping your body in a straight line. Push through your palms to extend your arms and return to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Decline Push-Ups primarily target the chest muscles (pectoralis major and minor), specifically the lower chest. They also engage the muscles of the shoulders, triceps, and core for stability."
                ],
                [
                "exercise": "Barbell Bench Press",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/0cXAp6WhSj4",
                "howTo": "Lie flat on a bench with your feet on the ground and your eyes aligned with the barbell. Grasp the barbell with a grip slightly wider than shoulder-width apart. Lift the barbell off the rack and lower it to your chest while keeping your elbows at a 90-degree angle. Push the barbell back up to the starting position, fully extending your arms. Repeat for the desired number of repetitions.",
                "effectivePart": "Barbell Bench Press primarily targets the chest muscles (pectoralis major and minor), along with the front deltoids and triceps. It also engages the muscles of the shoulders and core for stability."
                ],
                [
                "exercise": "Chest Flyes",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/Jz7oEmzhnfE",
                "howTo": "Lie on a flat bench with a dumbbell in each hand. Extend your arms straight up above your chest, palms facing each other. Keeping a slight bend in your elbows, lower the dumbbells out to the sides in a wide arc until you feel a stretch in your chest. Reverse the motion and squeeze your chest muscles as you bring the dumbbells back together. Repeat for the desired number of repetitions.",
                "effectivePart": "Chest Flyes primarily target the chest muscles (pectoralis major and minor) and help isolate and develop the inner chest. They also engage the muscles of the shoulders and arms for stability."
                ]
                ],
                "arm": [
                [
                "exercise": "Barbell Bicep Curls",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/2ZlISIiQJ4Y",
                "howTo": "Stand with your feet shoulder-width apart, holding a barbell with an underhand grip, arms fully extended and palms facing forward. Keep your upper arms stationary and exhale as you curl the barbell upward, contracting your biceps. Pause briefly at the top of the movement, then inhale as you slowly lower the barbell back down to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Barbell Bicep Curls primarily target the biceps muscles of the upper arms. They also engage the muscles of the forearms and shoulders as stabilizers."
                ],
                [
                "exercise": "Tricep Pushdowns",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/WjLJ7zIppXQ",
                "howTo": "Stand in front of a cable machine with a high pulley attachment. Grasp the handle with an overhand grip and position your elbows close to your sides. Push the handle downward by extending your elbows until your arms are fully extended. Keep your upper arms stationary throughout the movement. Slowly release the handle back up to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Tricep Pushdowns primarily target the triceps muscles of the upper arms. They also engage the muscles of the shoulders and forearms for stability."
                ],
                [
                "exercise": "Skull Crushers",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/gTrlbuuMufQ",
                "howTo": "Lie flat on a bench with a barbell in your hands, arms fully extended and palms facing forward. Lower the barbell by bending your elbows, allowing it to come close to your forehead. Keep your upper arms stationary and only move your forearms. Pause briefly at the bottom of the movement, then extend your arms to lift the barbell back up to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Skull Crushers primarily target the triceps muscles of the upper arms. They also engage the muscles of the chest and shoulders for stability."
                ]
                ],
                "leg": [
                [
                "exercise": "Barbell Squats",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/unQgFZTOfLU",
                "howTo": "Stand with your feet slightly wider than shoulder-width apart, with a barbell resting on your upper back. Brace your core and lower your body by bending at the knees and hips, keeping your chest up and your knees tracking over your toes. Descend until your thighs are parallel to the ground, then push through your heels to return to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Barbell Squats primarily target the quadriceps (front thigh muscles), hamstrings (back thigh muscles), and glutes. They also engage the muscles of the calves and core for stability."
                ],
                [
                "exercise": "Romanian Deadlifts",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/d-hn_0sEpRQ",
                "howTo": "Stand with your feet hip-width apart, holding a barbell in front of your thighs with an overhand grip. Hinge forward at the hips, pushing your hips back and lowering the barbell towards the ground while keeping your back straight. Lower the barbell until you feel a stretch in your hamstrings, then engage your glutes and hamstrings to return to the starting position. Repeat for the desired number of repetitions.",
                "effectivePart": "Romanian Deadlifts primarily target the hamstrings, glutes, and lower back. They also engage the muscles of the upper back and core for stability."
                ],
                [
                "exercise": "Calf Raises",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/fOfPwmb5FXU",
                "howTo": "Stand with the balls of your feet on the edge of a raised platform or step, with your heels hanging off. Rise up on your toes as high as possible, lifting your bodyweight with the calf muscles. Pause at the top of the movement, then slowly lower your heels back down below the platform. Repeat for the desired number of repetitions.",
                "effectivePart": "Calf Raises primarily target the calf muscles (gastrocnemius and soleus). They help develop strength and definition in the calves."
                ]
                ],
                "shoulder&back": [
                [
                "exercise": "Shoulder Press",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/dyv6g4xBFGU",
                "howTo": "Stand with your feet shoulder-width apart and hold a barbell or dumbbells at shoulder level with an overhand grip. Engage your core and keep your back straight. Push the weight(s) overhead by extending your arms until they are fully extended. Avoid arching your lower back or shrugging your shoulders. Lower the weight(s) back down to shoulder level with control. Repeat for the desired number of repetitions.",
                "effectivePart": "Shoulder Press primarily targets the deltoid muscles (shoulders), specifically the front (anterior) and middle (lateral) deltoids. It also engages the triceps and muscles of the upper back and core for stability."
                ],
                [
                "exercise": "Bent-Over Rows",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/dD-jK2l_zQE",
                "howTo": "Stand with your feet shoulder-width apart, knees slightly bent, and hold a barbell or dumbbells with an overhand grip. Bend forward at the hips while keeping your back straight and chest up. Let the weight(s) hang down in front of you. Pull the weight(s) up towards your lower chest by squeezing your shoulder blades together. Lower the weight(s) back down with control. Repeat for the desired number of repetitions.",
                "effectivePart": "Bent-Over Rows primarily target the muscles of the upper back, including the latissimus dorsi (lats), rhomboids, and trapezius. They also engage the muscles of the lower back, biceps, and core for stability."
                ],
                [
                "exercise": "Lateral Raises",
                "reps": "15",
                "time": "30",
                "videoURL": "https://www.youtube.com/shorts/G-piLwLu0d4",
                "howTo": "Stand with your feet shoulder-width apart, holding dumbbells by your sides with your palms facing inward. Engage your core and keep a slight bend in your elbows. Raise your arms out to the sides, keeping them parallel to the ground, until they reach shoulder level. Pause briefly at the top of the movement, then lower the dumbbells back down to your sides with control. Repeat for the desired number of repetitions.",
                "effectivePart": "Lateral Raises primarily target the lateral deltoid muscles (outer shoulders). They also engage the muscles of the upper back and core for stability."
                ]
                ]
            ]
        }else if weightValue > 80 && weightValue <= 100 {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/ukjB-FoEy2Q",
                    "howTo": "Sit on the floor with your knees bent and feet elevated slightly off the ground. Lean back slightly while maintaining a straight back. Hold your hands together in front of your chest. Twist your torso to the right, bringing your hands to the right side of your body. Then, twist to the left, bringing your hands to the left side of your body. Repeat this twisting motion for the desired number of repetitions.",
                    "effectivePart": "Russian Twists primarily target the oblique muscles, which are responsible for rotational movements of the torso. They also engage the rectus abdominis (six-pack muscles) and the muscles of the lower back for stability."
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/watch?v=EpHPUI4gx58",
                    "howTo": "Start in a plank position with your forearms on the ground and your body in a straight line from head to heels. Engage your core muscles and lift one leg off the ground, keeping it straight and parallel to the floor. Hold this position for a moment, then lower the leg back down and repeat with the other leg. Alternate lifting each leg for the desired number of repetitions.",
                    "effectivePart": "Plank with Leg Raises primarily targets the core muscles, including the rectus abdominis, obliques, and transverse abdominis. It also engages the muscles of the shoulders, arms, and glutes for stability."
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/7DoFMV1Dnow",
                    "howTo": "Hang from a pull-up bar with your arms fully extended and your shoulders relaxed. Engage your core muscles and lift your legs up by bending at the hips and knees, bringing your thighs towards your chest. Pause at the top of the movement, then slowly lower your legs back down to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Hanging Leg Raises primarily target the lower abdominal muscles (lower abs) and hip flexors. They also engage the muscles of the upper abs, obliques, and lower back for stability."
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/watch?v=QuaOc1mFcqs",
                    "howTo": "Assume a push-up position with your feet elevated on a bench or step, forming a decline angle. Place your hands slightly wider than shoulder-width apart on the floor. Lower your chest towards the ground by bending your elbows, keeping your body in a straight line. Push through your palms to extend your arms and return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Decline Push-Ups primarily target the chest muscles (pectoralis major and minor), specifically the lower chest. They also engage the muscles of the shoulders, triceps, and core for stability."
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/0cXAp6WhSj4",
                    "howTo": "Lie flat on a bench with your feet on the ground and your eyes aligned with the barbell. Grasp the barbell with a grip slightly wider than shoulder-width apart. Lift the barbell off the rack and lower it to your chest while keeping your elbows at a 90-degree angle. Push the barbell back up to the starting position, fully extending your arms. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Bench Press primarily targets the chest muscles (pectoralis major and minor), along with the front deltoids and triceps. It also engages the muscles of the shoulders and core for stability."
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/Jz7oEmzhnfE",
                    "howTo": "Lie on a flat bench with a dumbbell in each hand. Extend your arms straight up above your chest, palms facing each other. Keeping a slight bend in your elbows, lower the dumbbells out to the sides in a wide arc until you feel a stretch in your chest. Reverse the motion and squeeze your chest muscles as you bring the dumbbells back together. Repeat for the desired number of repetitions.",
                    "effectivePart": "Chest Flyes primarily target the chest muscles (pectoralis major and minor) and help isolate and develop the inner chest. They also engage the muscles of the shoulders and arms for stability."
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/2ZlISIiQJ4Y",
                    "howTo": "Stand with your feet shoulder-width apart, holding a barbell with an underhand grip, arms fully extended and palms facing forward. Keep your upper arms stationary and exhale as you curl the barbell upward, contracting your biceps. Pause briefly at the top of the movement, then inhale as you slowly lower the barbell back down to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Bicep Curls primarily target the biceps muscles of the upper arms. They also engage the muscles of the forearms and shoulders as stabilizers."
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/WjLJ7zIppXQ",
                    "howTo": "Stand in front of a cable machine with a high pulley attachment. Grasp the handle with an overhand grip and position your elbows close to your sides. Push the handle downward by extending your elbows until your arms are fully extended. Keep your upper arms stationary throughout the movement. Slowly release the handle back up to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Tricep Pushdowns primarily target the triceps muscles of the upper arms. They also engage the muscles of the shoulders and forearms for stability."
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/gTrlbuuMufQ",
                    "howTo": "Lie flat on a bench with a barbell in your hands, arms fully extended and palms facing forward. Lower the barbell by bending your elbows, allowing it to come close to your forehead. Keep your upper arms stationary and only move your forearms. Pause briefly at the bottom of the movement, then extend your arms to lift the barbell back up to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Skull Crushers primarily target the triceps muscles of the upper arms. They also engage the muscles of the chest and shoulders for stability."
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/unQgFZTOfLU",
                    "howTo": "Stand with your feet slightly wider than shoulder-width apart, with a barbell resting on your upper back. Brace your core and lower your body by bending at the knees and hips, keeping your chest up and your knees tracking over your toes. Descend until your thighs are parallel to the ground, then push through your heels to return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Squats primarily target the quadriceps (front thigh muscles), hamstrings (back thigh muscles), and glutes. They also engage the muscles of the calves and core for stability."
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/d-hn_0sEpRQ",
                    "howTo": "Stand with your feet hip-width apart, holding a barbell in front of your thighs with an overhand grip. Hinge forward at the hips, pushing your hips back and lowering the barbell towards the ground while keeping your back straight. Lower the barbell until you feel a stretch in your hamstrings, then engage your glutes and hamstrings to return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Romanian Deadlifts primarily target the hamstrings, glutes, and lower back. They also engage the muscles of the upper back and core for stability."
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/fOfPwmb5FXU",
                    "howTo": "Stand with the balls of your feet on the edge of a raised platform or step, with your heels hanging off. Rise up on your toes as high as possible, lifting your bodyweight with the calf muscles. Pause at the top of the movement, then slowly lower your heels back down below the platform. Repeat for the desired number of repetitions.",
                    "effectivePart": "Calf Raises primarily target the calf muscles (gastrocnemius and soleus). They help develop strength and definition in the calves."
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/dyv6g4xBFGU",
                    "howTo": "Stand with your feet shoulder-width apart and hold a barbell or dumbbells at shoulder level with an overhand grip. Engage your core and keep your back straight. Push the weight(s) overhead by extending your arms until they are fully extended. Avoid arching your lower back or shrugging your shoulders. Lower the weight(s) back down to shoulder level with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Shoulder Press primarily targets the deltoid muscles (shoulders), specifically the front (anterior) and middle (lateral) deltoids. It also engages the triceps and muscles of the upper back and core for stability."
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/dD-jK2l_zQE",
                    "howTo": "Stand with your feet shoulder-width apart, knees slightly bent, and hold a barbell or dumbbells with an overhand grip. Bend forward at the hips while keeping your back straight and chest up. Let the weight(s) hang down in front of you. Pull the weight(s) up towards your lower chest by squeezing your shoulder blades together. Lower the weight(s) back down with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Bent-Over Rows primarily target the muscles of the upper back, including the latissimus dorsi (lats), rhomboids, and trapezius. They also engage the muscles of the lower back, biceps, and core for stability."
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/G-piLwLu0d4",
                    "howTo": "Stand with your feet shoulder-width apart, holding dumbbells by your sides with your palms facing inward. Engage your core and keep a slight bend in your elbows. Raise your arms out to the sides, keeping them parallel to the ground, until they reach shoulder level. Pause briefly at the top of the movement, then lower the dumbbells back down to your sides with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Lateral Raises primarily target the lateral deltoid muscles (outer shoulders). They also engage the muscles of the upper back and core for stability."
                    ]
                ]
            ]
        }else {
            return [
                "abs": [
                    [
                    "exercise": "Russian Twists",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/ukjB-FoEy2Q",
                    "howTo": "Sit on the floor with your knees bent and feet elevated slightly off the ground. Lean back slightly while maintaining a straight back. Hold your hands together in front of your chest. Twist your torso to the right, bringing your hands to the right side of your body. Then, twist to the left, bringing your hands to the left side of your body. Repeat this twisting motion for the desired number of repetitions.",
                    "effectivePart": "Russian Twists primarily target the oblique muscles, which are responsible for rotational movements of the torso. They also engage the rectus abdominis (six-pack muscles) and the muscles of the lower back for stability."
                    ],
                    [
                    "exercise": "Plank with leg Raises",
                    "reps": "5",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/watch?v=EpHPUI4gx58",
                    "howTo": "Start in a plank position with your forearms on the ground and your body in a straight line from head to heels. Engage your core muscles and lift one leg off the ground, keeping it straight and parallel to the floor. Hold this position for a moment, then lower the leg back down and repeat with the other leg. Alternate lifting each leg for the desired number of repetitions.",
                    "effectivePart": "Plank with Leg Raises primarily targets the core muscles, including the rectus abdominis, obliques, and transverse abdominis. It also engages the muscles of the shoulders, arms, and glutes for stability."
                    ],
                    [
                    "exercise": "Hanging Leg Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/7DoFMV1Dnow",
                    "howTo": "Hang from a pull-up bar with your arms fully extended and your shoulders relaxed. Engage your core muscles and lift your legs up by bending at the hips and knees, bringing your thighs towards your chest. Pause at the top of the movement, then slowly lower your legs back down to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Hanging Leg Raises primarily target the lower abdominal muscles (lower abs) and hip flexors. They also engage the muscles of the upper abs, obliques, and lower back for stability."
                    ]
                ],
                "chest": [
                    [
                    "exercise": "Decline Push-Ups",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/watch?v=QuaOc1mFcqs",
                    "howTo": "Assume a push-up position with your feet elevated on a bench or step, forming a decline angle. Place your hands slightly wider than shoulder-width apart on the floor. Lower your chest towards the ground by bending your elbows, keeping your body in a straight line. Push through your palms to extend your arms and return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Decline Push-Ups primarily target the chest muscles (pectoralis major and minor), specifically the lower chest. They also engage the muscles of the shoulders, triceps, and core for stability."
                    ],
                    [
                    "exercise": "Barbell Bench Press",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/0cXAp6WhSj4",
                    "howTo": "Lie flat on a bench with your feet on the ground and your eyes aligned with the barbell. Grasp the barbell with a grip slightly wider than shoulder-width apart. Lift the barbell off the rack and lower it to your chest while keeping your elbows at a 90-degree angle. Push the barbell back up to the starting position, fully extending your arms. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Bench Press primarily targets the chest muscles (pectoralis major and minor), along with the front deltoids and triceps. It also engages the muscles of the shoulders and core for stability."
                    ],
                    [
                    "exercise": "Chest Flyes",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/Jz7oEmzhnfE",
                    "howTo": "Lie on a flat bench with a dumbbell in each hand. Extend your arms straight up above your chest, palms facing each other. Keeping a slight bend in your elbows, lower the dumbbells out to the sides in a wide arc until you feel a stretch in your chest. Reverse the motion and squeeze your chest muscles as you bring the dumbbells back together. Repeat for the desired number of repetitions.",
                    "effectivePart": "Chest Flyes primarily target the chest muscles (pectoralis major and minor) and help isolate and develop the inner chest. They also engage the muscles of the shoulders and arms for stability."
                    ]
                ],
                "arm": [
                    [
                    "exercise": "Barbell Bicep Curls",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/2ZlISIiQJ4Y",
                    "howTo": "Stand with your feet shoulder-width apart, holding a barbell with an underhand grip, arms fully extended and palms facing forward. Keep your upper arms stationary and exhale as you curl the barbell upward, contracting your biceps. Pause briefly at the top of the movement, then inhale as you slowly lower the barbell back down to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Bicep Curls primarily target the biceps muscles of the upper arms. They also engage the muscles of the forearms and shoulders as stabilizers."
                    ],
                    [
                    "exercise": "Tricep Pushdowns",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/WjLJ7zIppXQ",
                    "howTo": "Stand in front of a cable machine with a high pulley attachment. Grasp the handle with an overhand grip and position your elbows close to your sides. Push the handle downward by extending your elbows until your arms are fully extended. Keep your upper arms stationary throughout the movement. Slowly release the handle back up to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Tricep Pushdowns primarily target the triceps muscles of the upper arms. They also engage the muscles of the shoulders and forearms for stability."
                    ],
                    [
                    "exercise": "Skull Crushes",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/gTrlbuuMufQ",
                    "howTo": "Lie flat on a bench with a barbell in your hands, arms fully extended and palms facing forward. Lower the barbell by bending your elbows, allowing it to come close to your forehead. Keep your upper arms stationary and only move your forearms. Pause briefly at the bottom of the movement, then extend your arms to lift the barbell back up to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Skull Crushers primarily target the triceps muscles of the upper arms. They also engage the muscles of the chest and shoulders for stability."
                    ]
                ],
                "leg": [
                    [
                    "exercise": "Barbell Squats",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/unQgFZTOfLU",
                    "howTo": "Stand with your feet slightly wider than shoulder-width apart, with a barbell resting on your upper back. Brace your core and lower your body by bending at the knees and hips, keeping your chest up and your knees tracking over your toes. Descend until your thighs are parallel to the ground, then push through your heels to return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Barbell Squats primarily target the quadriceps (front thigh muscles), hamstrings (back thigh muscles), and glutes. They also engage the muscles of the calves and core for stability."
                    ],
                    [
                    "exercise": "Romanian Deadlifts",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/d-hn_0sEpRQ",
                    "howTo": "Stand with your feet hip-width apart, holding a barbell in front of your thighs with an overhand grip. Hinge forward at the hips, pushing your hips back and lowering the barbell towards the ground while keeping your back straight. Lower the barbell until you feel a stretch in your hamstrings, then engage your glutes and hamstrings to return to the starting position. Repeat for the desired number of repetitions.",
                    "effectivePart": "Romanian Deadlifts primarily target the hamstrings, glutes, and lower back. They also engage the muscles of the upper back and core for stability."
                    ],
                    [
                    "exercise": "Calf Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/fOfPwmb5FXU",
                    "howTo": "Stand with the balls of your feet on the edge of a raised platform or step, with your heels hanging off. Rise up on your toes as high as possible, lifting your bodyweight with the calf muscles. Pause at the top of the movement, then slowly lower your heels back down below the platform. Repeat for the desired number of repetitions.",
                    "effectivePart": "Calf Raises primarily target the calf muscles (gastrocnemius and soleus). They help develop strength and definition in the calves."
                    ]
                ],
                "shoulder&back": [
                    [
                    "exercise": "Shoulder Press",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/dyv6g4xBFGU",
                    "howTo": "Stand with your feet shoulder-width apart and hold a barbell or dumbbells at shoulder level with an overhand grip. Engage your core and keep your back straight. Push the weight(s) overhead by extending your arms until they are fully extended. Avoid arching your lower back or shrugging your shoulders. Lower the weight(s) back down to shoulder level with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Shoulder Press primarily targets the deltoid muscles (shoulders), specifically the front (anterior) and middle (lateral) deltoids. It also engages the triceps and muscles of the upper back and core for stability."
                    ],
                    [
                    "exercise": "Bent-Over Rows",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/dD-jK2l_zQE",
                    "howTo": "Stand with your feet shoulder-width apart, knees slightly bent, and hold a barbell or dumbbells with an overhand grip. Bend forward at the hips while keeping your back straight and chest up. Let the weight(s) hang down in front of you. Pull the weight(s) up towards your lower chest by squeezing your shoulder blades together. Lower the weight(s) back down with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Bent-Over Rows primarily target the muscles of the upper back, including the latissimus dorsi (lats), rhomboids, and trapezius. They also engage the muscles of the lower back, biceps, and core for stability."
                    ],
                    [
                    "exercise": "Lateral Raises",
                    "reps": "16",
                    "time": "30",
                    "videoURL": "https://www.youtube.com/shorts/G-piLwLu0d4",
                    "howTo": "Stand with your feet shoulder-width apart, holding dumbbells by your sides with your palms facing inward. Engage your core and keep a slight bend in your elbows. Raise your arms out to the sides, keeping them parallel to the ground, until they reach shoulder level. Pause briefly at the top of the movement, then lower the dumbbells back down to your sides with control. Repeat for the desired number of repetitions.",
                    "effectivePart": "Lateral Raises primarily target the lateral deltoid muscles (outer shoulders). They also engage the muscles of the upper back and core for stability."
                    ]
                ]
            ]
        }
    }
    
    public func createUserSchedule(userSchedule: UserSchedule, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()

        let scheduleData: [String: Any] = [
            "workoutName": userSchedule.workoutName,
            "workoutFrequency": userSchedule.workoutFrequency
        ]

        db.collection("userSchedules")
            .document(userID)
            .setData(scheduleData, merge: true) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
    
    public func fetchUserSchedule(completion: @escaping (UserSchedule?, Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()

        db.collection("userSchedules")
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    if let snapshotData = snapshot.data(),
                       let workoutName = snapshotData["workoutName"] as? String,
                       let workoutFrequency = snapshotData["workoutFrequency"] as? String {
                        let userSchedule = UserSchedule(workoutName: workoutName, workoutFrequency: workoutFrequency)
                        completion(userSchedule, nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            }
    }
    
}
