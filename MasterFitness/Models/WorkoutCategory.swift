//
//  WorkoutCategory.swift
//  MasterFitness
//
//  Created by Chamidu on 25/04/2023.
//

import Foundation

struct WorkoutCategory {
    let type : String
    let banner : String
    let workoutCount : any Numeric
    let category : Array<String>
}

let Categories = [
    WorkoutCategory(type: "Begginer", banner: "beginnerBanner", workoutCount: 5, category: ["Abs-Begginer", "Chest-Begginer", "Arm-Begginer", "Leg-bigginer", "Shoulder & Back- Begginer"]),
    WorkoutCategory(type: "Intermediate", banner: "beginnerBanner", workoutCount: 5, category: ["Abs-Intermediate", "Chest-Intermediate", "Arm-Intermediate", "Leg-Intermediate", "Shoulder & Back-Intermediate"])
]
