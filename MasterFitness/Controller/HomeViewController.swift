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
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        setupUI()
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

    @objc private func didTapLogOut(){}
}
