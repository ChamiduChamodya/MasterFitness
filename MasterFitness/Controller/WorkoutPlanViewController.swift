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
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let titleLabel = UILabel()
        titleLabel.text = planTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        let playButton = UIButton(type: .system)
        playButton.setTitle("Play", for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = .white
        view.addSubview(playButton)

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutPlanCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        tableView.separatorColor = .white
        view.addSubview(tableView)

        // Configure constraints for UI elements
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            playButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
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
        let category = Array(workoutPlan.keys)[section]
        return workoutPlan[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkoutPlanCell
        
        let category = Array(workoutPlan.keys)[indexPath.section]
        let exercises = workoutPlan[category]
        let exercise = exercises?[indexPath.row]
        
        if let exercise = exercise,
           let exerciseName = exercise["exercise"] as? String,
           let repsString = exercise["reps"] as? String,
           let reps = Int(repsString),
           let timeString = exercise["time"] as? String,
           let time = Int(timeString) {
            cell.configure(with: exerciseName, reps: reps, time: time)
        }else {
            print("Exercise data is invalid or missing.")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Array(workoutPlan.keys)[section]
        let capitalizedCategory = category.uppercased()
        
        let headerLabel = UILabel()
        headerLabel.text = capitalizedCategory
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.textColor = .white
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
