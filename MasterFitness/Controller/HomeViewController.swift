//
//  HomeViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class HomeViewController: UIViewController {

    private let label :  UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Loading..."
        label.numberOfLines = 3
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        setupUI()
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else {return}

            if let error = error {
                AlertManager.showFetchinguserErrorAlert(on: self, with: error)
                return
            }

            if let user = user {
                self.label.text = "\(user.username)\n\(user.email)\n\(user.isOnBoardingDone)"
            }
        }
    }

    private func setupUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogOut))

                self.view.addSubview(label)

                self.label.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])

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
