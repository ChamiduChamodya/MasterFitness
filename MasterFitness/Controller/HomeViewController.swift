//
//  HomeViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var userWorkoutPlan: [String: [[String: Any]]] = [:]
    
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
                print(user.userWorkoutPlan)
                self.userWorkoutPlan = user.userWorkoutPlan
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
        
        for i in 0..<cardTitles.count {
            let cardView = createCardView(title: cardTitles[i])
            cardStackView.addArrangedSubview(cardView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard(_:)))
            cardView.addGestureRecognizer(tapGesture)
            
            if i < cardTitles.count - 1 {
                let spacingView = UIView()
                spacingView.translatesAutoresizingMaskIntoConstraints = false
                spacingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                cardStackView.addArrangedSubview(spacingView)
            }
        }
    }
    
    private func createCardView(title: String) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 20
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let backgroundImage: UIImage?
        if title == "MyPlan" {
            backgroundImage = UIImage(named: "01")
        } else if title == "Beginner" {
            backgroundImage = UIImage(named: "04")
        } else if title == "Intermediate" {
            backgroundImage = UIImage(named: "03")
        } else if title == "Advanced" {
            backgroundImage = UIImage(named: "02")
        } else {
            backgroundImage = nil
        }
        
        if let backgroundImage = backgroundImage {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.alpha = 0.5
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(backgroundImageView)
        
            NSLayoutConstraint.activate([
                backgroundImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                backgroundImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
            ])
        }
               
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        let optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 15
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(optionsStackView)

        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 200),
            
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
    
    @objc private func didTapCard(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view else { return }
        
        // Get the index of the tapped card view
        if let index = cardStackView.arrangedSubviews.firstIndex(of: cardView) {
            let cardTitles = ["MyPlan", "Beginner", "Intermediate", "Advanced"]
            let selectedCard = cardTitles[index]
            
            // Perform navigation based on the selected card
            switch selectedCard {
            case "MyPlan":
                // Navigate to MyPlanViewController
                let myPlanVC = WorkoutPlanViewController()
                myPlanVC.planTitle = "My Plan"
                myPlanVC.workoutPlan = self.userWorkoutPlan
                navigationController?.pushViewController(myPlanVC, animated: true)
            case "Beginner": break
                // Navigate to BeginnerViewController
//                let beginnerVC = BeginnerViewController()
//                navigationController?.pushViewController(beginnerVC, animated: true)
            case "Intermediate": break
                // Navigate to IntermediateViewController
//                let intermediateVC = IntermediateViewController()
//                navigationController?.pushViewController(intermediateVC, animated: true)
            case "Advanced": break
                // Navigate to AdvancedViewController
//                let advancedVC = AdvancedViewController()
//                navigationController?.pushViewController(advancedVC, animated: true)
            default:
                break
            }
        }
    }
}
