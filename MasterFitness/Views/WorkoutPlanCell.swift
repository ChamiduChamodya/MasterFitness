//
//  WorkoutPlanCell.swift
//  MasterFitness
//
//  Created by Chamidu on 17/05/2023.
//

import UIKit

class WorkoutPlanCell: UITableViewCell {
    
    private let exerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let repsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(exerciseLabel)
        contentView.addSubview(repsLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            exerciseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            repsLabel.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 4),
            repsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            timeLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with exerciseName: String, reps: Int, time: Int) {
        exerciseLabel.text = exerciseName
        repsLabel.text = "Reps: \(reps)"
        timeLabel.text = "Time: \(time)s"
    }

}
