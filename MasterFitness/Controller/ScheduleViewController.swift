//
//  ScheduleViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/05/2023.
//

import UIKit

class ScheduleViewController: UIViewController {

    private let workoutNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Workout Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let frequencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let frequencyOptions = ["Every Other Day", "Every Day", "2 Days Per Week", "3 Days Per Week", "4 Days Per Week", "5 Days Per Week", "6 Days Per Week"]
    
    //lazy: initialized only when the property is accessed
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Create Schedule"
        
        // Set navigation bar title color to white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Set text color for text fields and labels
        workoutNameTextField.textColor = .black
        
        // Set text color for picker view
        frequencyPicker.setValue(UIColor.white, forKey: "textColor")
        
        setupUI()
        
        AuthService.shared.fetchUserSchedule { [weak self] UserSchedule, error in
            guard let self = self else {return}
            
            if let error = error {
                AlertManager.showFetchinguserErrorAlert(on: self, with: error)
                return
            }
            if let userSchedule = UserSchedule {
                self.displayWorkoutSchedule(userSchedule.workoutName, userSchedule.workoutFrequency)
            }else {
                self.displayNoScheduleMessage()
            }
            
        }
        
    }
    
    @objc private func saveButtonTapped() {
        guard let workoutName = workoutNameTextField.text, !workoutName.isEmpty else {
            showAlert(message: "Workout name is required.")
            return
        }
        
        let selectedFrequencyIndex = frequencyPicker.selectedRow(inComponent: 0)
        let selectedFrequency = frequencyOptions[selectedFrequencyIndex]
        
        let userSchedule = UserSchedule(workoutName: workoutName, workoutFrequency: selectedFrequency)

        AuthService.shared.createUserSchedule(userSchedule: userSchedule) { error in
            if let error = error {
                print("Error saving workout schedule: \(error)")
                self.showAlert(message: "Failed to save workout schedule. Please try again.")
            } else {
                print("Workout schedule saved successfully.")
                self.showAlert(message: "Workout schedule saved successfully.")
                self.displayWorkoutSchedule(workoutName, selectedFrequency)
            }
        }
    }
    
    private func displayWorkoutSchedule(_ workoutName: String, _ workoutFrequency: String) {
        let workoutLabel = UILabel()
        workoutLabel.text = "Workout Schedule: \(workoutName) (\(workoutFrequency))"
        workoutLabel.textColor = .white
        workoutLabel.textAlignment = .center
        workoutLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(workoutLabel)
        
        NSLayoutConstraint.activate([
            workoutLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            workoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func displayNoScheduleMessage() {
        let noScheduleLabel = UILabel()
        noScheduleLabel.text = "Workout Schedule Not Set"
        noScheduleLabel.textColor = .white
        noScheduleLabel.textAlignment = .center
        noScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noScheduleLabel)
        
        NSLayoutConstraint.activate([
            noScheduleLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            noScheduleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noScheduleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupUI() {
        view.addSubview(workoutNameTextField)
        view.addSubview(frequencyPicker)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            workoutNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            workoutNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            frequencyPicker.topAnchor.constraint(equalTo: workoutNameTextField.bottomAnchor, constant: 16),
            frequencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            frequencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: frequencyPicker.bottomAnchor, constant: 24),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyOptions[row]
    }
}
