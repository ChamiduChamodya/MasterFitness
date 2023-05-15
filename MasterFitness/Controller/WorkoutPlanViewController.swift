//
//  WorkoutPlanViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 11/05/2023.
//

import UIKit

class WorkoutPlanViewController: UIViewController {
    
    var planTitle: String = ""
    var workoutPlan: [String: [[String: Any]]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let planTitle = planTitle as? String {
//            print("planTitle \(planTitle)")
//        }
//
//        if let workoutPlan = workoutPlan as? [String: [Any]] {
//            print("Data loaded \(workoutPlan)")
//        }
        
        setupUI()
    }
    
    private func setupUI() {
        // Create a label for plan title
        let titleLabel = UILabel()
        titleLabel.text = planTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        // Create a button with play icon
        let playButton = UIButton(type: .system)
        playButton.setTitle("Play", for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)

        // Create a table view to display workout plan data
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Configure constraints for UI elements
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            playButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        // Reload table view to display data
        tableView.reloadData()
    }
    
    @objc private func playButtonTapped() {
        let exerciseViewController = ExcerciseViewController()
        exerciseViewController.exercises = workoutPlan.flatMap { $0.value }
        navigationController?.pushViewController(exerciseViewController, animated: true)
    }
    
}

extension WorkoutPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutPlan.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categories = Array(workoutPlan.keys)
        let category = categories[section]
        return workoutPlan[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let categories = Array(workoutPlan.keys)
        let category = categories[indexPath.section]
        let exercises = workoutPlan[category]
        let exercise = exercises?[indexPath.row]
        
        print("exercises \(String(describing: exercises))")
        print("exercise \(String(describing: exercise))")
        
        print("exerciseName \(String(describing: exercise!["exercise"] as? String))")
        print("reps \(String(describing: exercise!["reps"] as? String))")
        print("time \(String(describing: exercise!["time"] as? String))")
        
        if let exercise = exercise,
           let exerciseName = exercise["exercise"] as? String,
           let repsString = exercise["reps"] as? String,
           let reps = Int(repsString),
           let timeString = exercise["time"] as? String,
           let time = Int(timeString) {
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = "\(exerciseName) - Reps: \(reps) - Time: \(time)s"
        }else {
            print("Exercise data is invalid or missing.")
        }
        
//        if let exercise = exercise,
//           let exerciseName = exercise["exercise"] as? String,
//           let reps = exercise["reps"] as? Int,
//           let time = exercise["time"] as? Int {
//            print("exerciseName \(exerciseName)")
//            print("reps \(reps)")
//            print("time \(time)")
//            cell.textLabel?.text = "\(exerciseName) - Reps: \(reps), Time: \(time)s"
//        }else {
//            print("Exercise data is invalid or missing.")
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let categories = Array(workoutPlan.keys)
        return categories[section]
    }
}
