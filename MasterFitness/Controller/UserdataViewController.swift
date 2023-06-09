//
//  UserdataViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 08/05/2023.
//

import UIKit

class UserdataViewController: UIViewController {
    
    var data: [String: Any] = [:]
    
    private let bmiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var username: String = ""
    private var email: String = ""
    private var password: String = ""
    
    private let headerView = AuthHeaderView(title: "User Details", subTitle: "Please Input Your Details")

    private let height = CustomTextField(authFieldType: .text, placeholder: "Height in Cm")
    private let weight = CustomTextField(authFieldType: .text, placeholder: "Weight in Kg")
    private let goal = CustomTextField(authFieldType: .text, placeholder: "Weight Goal in Kg")
    private let age = CustomTextField(authFieldType: .text, placeholder: "Age")

    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true ,fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if let dataArray = data["data"] as? [[String: Any]] {
            for element in dataArray {
                
                
                if let username = element["username"] as? String {
                            self.username = username
                        } else {
                            print("No value for 'username' key or value is not a String.")
                        }
                        
                        if let email = element["email"] as? String {
                            self.email = email
                        } else {
                            print("No value for 'email' key or value is not a String.")
                        }
                        
                        if let password = element["password"] as? String {
                            self.password = password
                        } else {
                            print("No value for 'password' key or value is not a String.")
                        }
            }
        }
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)

    }
    
    private func calculateBMI() -> Double? {
        guard let heightText = height.text, let heightValue = Double(heightText),
              let weightText = weight.text, let weightValue = Double(weightText) else {
            return nil
        }
        
        // Convert height from cm to meters
        let heightInMeters = heightValue / 100
        
        // Calculate BMI
        let bmi = weightValue / (heightInMeters * heightInMeters)
        
        return bmi
    }
    
    @objc func didTapSignUp(){
        
        // Calculate BMI
        guard let bmi = calculateBMI() else {
            AlertManager.showInvalidInputNumberAlert(on: self)
            return
        }
        
        let registerUserRequest = RegisterUserDetailRequest (
            username: self.username,
            email: self.email,
            password: self.password,
            height: self.height.text ?? "",
            weight: self.weight.text ?? "",
            fitnessGoal: self.goal.text ?? "",
            age: self.age.text ?? "",
            bmi: String(bmi)
            )

                if !Validator.isValidUsername(for: registerUserRequest.username) {
                    AlertManager.showInvalidUsernameAlert(on: self)
                    return
                }

                if !Validator.isValidEmail(for: registerUserRequest.email) {
                    AlertManager.showInvalidEmailAlert(on: self)
                    return
                }

                if !Validator.isValidPassword(for: registerUserRequest.password) {
                    AlertManager.showInvalidPasswordAlert(on: self)
                    return
                }
        
                if !Validator.isValidNumber(for: registerUserRequest.height) {
                    AlertManager.showInvalidInputNumberAlert(on: self)
                    return
                }
        
                if !Validator.isValidNumber(for: registerUserRequest.weight) {
                    AlertManager.showInvalidInputNumberAlert(on: self)
                    return
                }
                
                if !Validator.isValidNumber(for: registerUserRequest.age) {
                    AlertManager.showInvalidInputNumberAlert(on: self)
                    return
                }

                AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in

                    guard let self = self else { return }

                    if let error = error {
                        AlertManager.showRegistrationErrorAlert(on: self, with: error)
                        return
                    }

                    if wasRegistered {
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    } else {
                        AlertManager.showRegistrationErrorAlert(on: self)
                    }

                }
    }
    
    private func setupUI(){
        self.view.backgroundColor = .black

        self.view.addSubview(headerView)
        self.view.addSubview(height)
        self.view.addSubview(weight)
        self.view.addSubview(goal)
        self.view.addSubview(age)
        self.view.addSubview(signUpButton)
        self.view.addSubview(bmiLabel)
        
        self.bmiLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.height.translatesAutoresizingMaskIntoConstraints = false
        self.weight.translatesAutoresizingMaskIntoConstraints = false
        self.goal.translatesAutoresizingMaskIntoConstraints = false
        self.age.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),

            self.height.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.height.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.height.heightAnchor.constraint(equalToConstant: 55),
            self.height.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.weight.topAnchor.constraint(equalTo: height.bottomAnchor, constant: 22),
            self.weight.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.weight.heightAnchor.constraint(equalToConstant: 55),
            self.weight.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.goal.topAnchor.constraint(equalTo: weight.bottomAnchor, constant: 22),
            self.goal.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.goal.heightAnchor.constraint(equalToConstant: 55),
            self.goal.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.age.topAnchor.constraint(equalTo: goal.bottomAnchor, constant: 22),
            self.age.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.age.heightAnchor.constraint(equalToConstant: 55),
            self.age.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.bmiLabel.topAnchor.constraint(equalTo: age.bottomAnchor, constant: 22),
            self.bmiLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.bmiLabel.heightAnchor.constraint(equalToConstant: 55),
            self.bmiLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.signUpButton.topAnchor.constraint(equalTo: bmiLabel.bottomAnchor, constant: 10),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
        
        height.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        weight.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Calculate and update BMI label
        guard let bmi = calculateBMI() else {
            bmiLabel.text = ""
            return
        }
        
        bmiLabel.text = String(format: "BMI: %.2f", bmi)
    }

}
