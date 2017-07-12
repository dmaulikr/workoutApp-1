//
//  EntityEnums.swift
//  workoutApp
//
//  Created by Alexander Kvamme on 26/05/2017.
//  Copyright © 2017 Alexander Kvamme. All rights reserved.
//

import Foundation

enum Entity: String {
    case Workout = "Workout"
    case Exercise = "Exercise"
    case ExerciseLog = "ExerciseLog"
    case Lift = "Lift"
    case Muscle = "Muscle"
}

enum CDModels {
    enum workout {
        enum type: String {
            case dropSet = "Drop Set"
            case normal = "Normal"
        }
        
        enum muscle: String {
            case arms = "Arms"
            case back = "Back"
            case legs = "Legs"
            case core = "Core"
            case chest = "Chest"
            case shoulders = "Shoulders"
        }
    }
}
