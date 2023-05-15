//
//  ExcerciseViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 15/05/2023.
//

import UIKit

class ExcerciseViewController: UIViewController {
    var exercises: [[String: Any]] = []
    var currentIndex: Int = 0
    var timer: Timer?
    var timeRemaining: Int = 0
    
    private let exerciseLabel = UILabel()
    private let repsLabel = UILabel()
    private let timerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()

        startExercise(index: currentIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the timer when leaving the view
        stopTimer()
    }
    
    private func setupUI() {
        // Exercise label
        exerciseLabel.font = UIFont.boldSystemFont(ofSize: 24)
        exerciseLabel.textAlignment = .center
        exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exerciseLabel)
        
        // Reps label
        repsLabel.font = UIFont.systemFont(ofSize: 18)
        repsLabel.textAlignment = .center
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repsLabel)
        
        // Timer label
        timerLabel.font = UIFont.systemFont(ofSize: 32)
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            exerciseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exerciseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            repsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repsLabel.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 20),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func startExercise(index: Int) {
        guard index < exercises.count else {
            // All exercises are done, navigate back to the previous view controller
            navigationController?.popViewController(animated: true)
            return
        }
        
        let exercise = exercises[index]
        
        if let exerciseName = exercise["exercise"] as? String,
           let repsString = exercise["reps"] as? String,
           let reps = Int(repsString),
           let timeString = exercise["time"] as? String,
           let time = Int(timeString) {
            exerciseLabel.text = exerciseName
            repsLabel.text = "Reps: \(reps)"
            timeRemaining = time
            
            // Start the timer
            startTimer()
        } else {
            print("Exercise data is invalid or missing.")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        // Update the timer label
        timerLabel.text = "\(timeRemaining)"
        
        // Start the countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.timeRemaining -= 1
            
            if let timeRemaining = self?.timeRemaining {
                if timeRemaining > 0 {
                    // Update the timer label
                    self?.timerLabel.text = "\(timeRemaining)"
                } else {
                    // Move to the next exercise
                    self?.currentIndex += 1
                    self?.startExercise(index: self?.currentIndex ?? 0)
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}
