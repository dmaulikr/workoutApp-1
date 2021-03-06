//
//  DataSeeder.swift
//  workoutApp
//
//  Created by Alexander Kvamme on 25/05/2017.
//  Copyright © 2017 Alexander Kvamme. All rights reserved.
//

import Foundation
import CoreData

/*
 Used to make some example workouts, exercises, and exerciseLogs when the app is freshly installed
 */

final class DataSeeder {
    
    typealias DummyWorkout = (name: String, muscle: Muscle, type: String)
    typealias DummyExercise = (name: String, muscle: Muscle, plannedSets: Int16, type: String)
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - API
    
    public func seedCoreData() {
        seedWithExampleMuscleGroups()
        seedWithExampleWorkoutStyles()
        seedWithExampleExerciseStyles()
        seedWithExampleMeasurementStyles()
        seedWithExampleWorkoutsAndExercies()
        DatabaseController.saveContext()
    }
    
    // MARK: - Seeding
    
    private func seedWithExampleWorkoutsAndExercies() {
        
        var typeString: String = CDModels.workout.type.normal.rawValue
        var muscleString: String = CDModels.workout.type.normal.rawValue
        
        // Workouts
        
        let backMuscle = DatabaseFacade.fetchMuscleWithName("BACK")!
        let armsMuscle = DatabaseFacade.fetchMuscleWithName("ARMS")!
        
        let backWorkoutDropSet: DummyWorkout = (name: "Back", muscle: backMuscle, type: "Drop Set")
        let backWorkoutNormal: DummyWorkout = (name: "Back", muscle: backMuscle, type: "Normal")
        let bicepsTricepsWorkoutDropSet: DummyWorkout = (name: "Biceps and Triceps", muscle: armsMuscle, type: typeString)
        
        typeString = CDModels.workout.type.normal.rawValue
        muscleString = CDModels.workout.muscle.back.rawValue
        
        // Back - Drop set
        let exercisesForBackDropSet: [DummyExercise] = [
            (name: "Pullup", muscle: backMuscle, plannedSets: 4, type: typeString),
            (name: "Backflip", muscle: backMuscle, plannedSets: 3, type: typeString),
            (name: "Muscleup", muscle: backMuscle, plannedSets: 3, type: typeString),
            (name: "Bridge", muscle: backMuscle, plannedSets: 3, type: typeString),
            (name: "Back Extension", muscle: backMuscle, plannedSets: 3, type: typeString),
            (name: "Inverted Flies", muscle: backMuscle, plannedSets: 3, type: typeString),]
        
        // Back - Normal
        typeString = CDModels.workout.type.normal.rawValue
        muscleString = CDModels.workout.muscle.back.rawValue
        
        let exercisesForBackNormal: [DummyExercise] = [
            (name: "Pull ups", muscle: backMuscle, plannedSets: 2, type: typeString),
            (name: "Australian pull ups", muscle: backMuscle, plannedSets: 2, type: typeString),
            (name: "Chin ups", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Australian chin ups", muscle: backMuscle, plannedSets: 1, type: typeString),
            ]
        
        // Arms - Normal
        muscleString = CDModels.workout.muscle.arms.rawValue
        typeString = CDModels.workout.type.dropSet.rawValue
        
        let exercisesForBicepsAndTricepsDropSet: [DummyExercise] = [
            (name: "Bicep Curls", muscle: backMuscle, plannedSets: 2, type: typeString),
            (name: "Hammer Curls", muscle: backMuscle, plannedSets: 2, type: typeString),
            (name: "Fist pumps", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Bicep Pumps", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Biceps Flex", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Chin Ups", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Chin up negatives", muscle: backMuscle, plannedSets: 1, type: typeString),
            (name: "Australian chin ups", muscle: backMuscle, plannedSets: 1, type: typeString),
            ]
        
        // Seed into Core Data
        makeWorkout(backWorkoutDropSet, withExercises: exercisesForBackDropSet)
        makeWorkout(bicepsTricepsWorkoutDropSet, withExercises: exercisesForBicepsAndTricepsDropSet)
        makeWorkout(backWorkoutNormal, withExercises: exercisesForBackNormal)
        
        printWorkouts()
    }
    
    // Seed example muscles
    
    private func seedWithExampleMuscleGroups() {
        for m in Constant.exampleValues.exampleMuscles {
            makeMuscle(withName: m.uppercased())
        }
        printMuscles()
    }
    
    // Seed example WorkoutStyles
    
    private func seedWithExampleWorkoutStyles() {
        for w in Constant.exampleValues.workoutStyles {
            makeWorkoutStyle(withName: w)
        }
        printWorkoutStyles()
    }
    
    // Seed example ExerciseStyles
    
    private func seedWithExampleExerciseStyles() {
        for exerciseStyleName in Constant.exampleValues.exerciseStyles {
            makeExerciseStyle(withName: exerciseStyleName)
        }
    }
    
    // Seed example measurementStyles
    
    private func seedWithExampleMeasurementStyles() {
        for measurementStyleName in Constant.exampleValues.measurementStyles {
            makeMeasurementStyle(withName: measurementStyleName)
        }
    }
    
    // MARK: - Helper Methods
    
    // Takes a DummyWorkout (name: String, muscle: Muscle, type: String) and an array of exercises, and creates a new Workout into core data. 
    private func makeWorkout(_ dummyWorkout: DummyWorkout, withExercises exercises: [DummyExercise]) {
        
        // Make and add back exercises
        
        let workoutRecord = DatabaseController.createManagedObjectForEntity(.Workout) as! Workout
        workoutRecord.name = dummyWorkout.name
        workoutRecord.muscle = dummyWorkout.muscle.name
        workoutRecord.muscleUsed = dummyWorkout.muscle
        workoutRecord.workoutStyle = DatabaseFacade.getWorkoutStyle(named: dummyWorkout.type)
        
        for exercise in exercises {
            let exerciseRecord = DatabaseController.createManagedObjectForEntity(.Exercise) as! Exercise
            
            exerciseRecord.name = exercise.name
            exerciseRecord.muscle = exercise.muscle.name
            print("making exercise and setting muscle to ", exercise.muscle.name ?? "")
            
            exerciseRecord.musclesUsed = exercise.muscle
            print("- ended up setting value: ", exerciseRecord.musclesUsed?.name ?? "bam")
            exerciseRecord.type = exercise.type
            exerciseRecord.addToUsedInWorkouts(workoutRecord)
            
            // Simulate this exercise having been used
            
            let logItem = DatabaseController.createManagedObjectForEntity(.ExerciseLog) as! ExerciseLog
            if let randomDate = randomDate(daysBack: 10) {
                logItem.datePerformed = randomDate as NSDate
            }
            logItem.exerciseDesign = exerciseRecord
            
            // add random lifts this workout
            
            for _ in 0...Int16(arc4random_uniform(UInt32(9))) {
                let lift = DatabaseController.createManagedObjectForEntity(.Lift) as! Lift
                lift.reps = randomRepNumber()
                lift.owner = logItem
                lift.datePerformed = Date() as NSDate
            }
        }
    }
    
    // MARK: - Record making functions
    
    // Make muscle
    
    private func makeMuscle(withName name: String) {
        let muscleRecord = DatabaseController.createManagedObjectForEntity(.Muscle) as! Muscle
        muscleRecord.name = name.uppercased()
    }
    
    // Make WorkoutStyle
    
    private func makeWorkoutStyle(withName name: String) {
        print("making workoutstyle named \(name)")
        let workoutStyleRecord = DatabaseController.createManagedObjectForEntity(.WorkoutStyle) as! WorkoutStyle
        workoutStyleRecord.name = name.uppercased()
    }
    
    // Make ExerciseStyle
    
    private func makeExerciseStyle(withName name: String) {
        let exerciseStyleRecord = DatabaseController.createManagedObjectForEntity(.ExerciseStyle) as! ExerciseStyle
        exerciseStyleRecord.name = name.uppercased()
    }
    
    private func makeMeasurementStyle(withName name: String) {
        let measurementStyleRecord = DatabaseController.createManagedObjectForEntity(.MeasurementStyle) as! MeasurementStyle
        measurementStyleRecord.name = name.uppercased()
    }
    
    // MARK: - Exercise Helper Methods
    
    private func randomRepNumber() -> Int16 {
        let result = Int16(arc4random_uniform(UInt32(99)))
        return result
    }
    
    func randomDate(daysBack: Int)-> Date? {
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(UInt32(23))
        let minute = arc4random_uniform(UInt32(59))
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    // MARK: - Print methods
    
    private func printWorkouts() {

        do {
            let request = NSFetchRequest<Workout>(entityName: Entity.Workout.rawValue)
            let allWorkouts = try context.fetch(request)
            
            print("workout count: ", allWorkouts.count)
            
            for workout in allWorkouts {
                print()
                print("Name: ", workout.name ?? "")
                print("----------------------")
                print("Muscle: ", workout.muscle ?? "")
                
                if let exercises = workout.exercises?.allObjects as? [Exercise] {
                    for exercise in exercises {
                        print(" - \(exercise.name ?? "fail")")
                    }
                }
            }
        } catch {
                print("error in printing workouts")
        }
    }
    
    private func printMuscles() {
        do {
            let request = NSFetchRequest<Muscle>(entityName: Entity.Muscle.rawValue)
            let allMuscles = try context.fetch(request)
            
            print("Muscle count: ", allMuscles.count)
            print()
            
            for muscle in allMuscles {
                print("Name: ", muscle.name ?? "")
            }
            print("----------------------")
        } catch {
            print("error in printing Muscles")
        }
    }
    
    private func printWorkoutStyles() {
        do {
            let request = NSFetchRequest<WorkoutStyle>(entityName: Entity.WorkoutStyle.rawValue)
            let allWorkoutStyles = try context.fetch(request)

            print("WorkoutStyle count: ", allWorkoutStyles.count)
            for style in allWorkoutStyles {
                print("Name: ", style.name ?? "")
            }
        } catch {
            print("error in printing workoutStyles")
        }
    }
    
    private func printExercises() {
        do {
            let request = NSFetchRequest<Exercise>(entityName: Entity.Exercise.rawValue)
            let allExercises = try context.fetch(request)
            
            print("workout count: ", allExercises.count)
            for exercise in allExercises {
                print()
                print("Name: ", exercise.name ?? "")
                print("Muscle: ", exercise.muscle ?? "")
                print("Type: ", exercise.type ?? "")
            }
        } catch {
            print("error in printing exercises")
        }
    }
}

