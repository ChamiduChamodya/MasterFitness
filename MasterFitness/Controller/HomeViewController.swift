//
//  HomeViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let welcomeLabel :  UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        setupLogoutUI()
        setupScrollView()
        setupWelcomeLabel()
        setupCards()
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else {return}

            if let error = error {
                AlertManager.showFetchinguserErrorAlert(on: self, with: error)
                return
            }

            if let user = user {
                self.welcomeLabel.text = "Welcome \(user.username)"
            }
        }
    }

    private func setupLogoutUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))
    }
    
    private func setupWelcomeLabel() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: welcomeLabel)
        welcomeLabel.text = "Loading.."
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(cardStackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cardStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            cardStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            cardStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            cardStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupCards() {
        let cardTitles = ["MyPlan", "Beginner", "Intermediate", "Advanced"]
        let cardOptions = [
            ["Abs", "Chest", "Arm", "Leg", "Shoulder & Back"],
            ["Abs", "Chest", "Arm", "Leg", "Shoulder & Back"],
            ["Abs", "Chest", "Arm", "Leg", "Shoulder & Back"],
            ["Abs", "Chest", "Arm", "Leg", "Shoulder & Back"]
        ]
        
        for i in 0..<cardTitles.count {
            let cardView = createCardView(title: cardTitles[i], options: cardOptions[i])
            cardStackView.addArrangedSubview(cardView)
        }
    }
    
    private func createCardView(title: String, options: [String]) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        let optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 8
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(optionsStackView)
        
        for option in options {
            let optionLabel = UILabel()
            optionLabel.text = option
            optionLabel.textColor = .black
            optionLabel.font = .systemFont(ofSize: 16)
            optionLabel.translatesAutoresizingMaskIntoConstraints = false
            optionsStackView.addArrangedSubview(optionLabel)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            optionsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    @objc private func didTapLogOut(){
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return  }
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }

            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
