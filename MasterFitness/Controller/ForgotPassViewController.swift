//
//  ForgotPassViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class ForgotPassViewController: UIViewController {

    private let headerView = AuthHeaderView(title: "Forgot Password", subTitle: "Reset Your Password!")

    private let emailTextField = CustomTextField(authFieldType: .email)

    private let resetPasswordButton = CustomButton(title: "Change Password",hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        setupUI()

        self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    @objc private func didTapForgotPassword() {
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
    }

    private func setupUI () {

        self.view.addSubview(headerView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(resetPasswordButton)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 230),

            self.emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 11),
            self.emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 55),
            self.emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.resetPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])

    }

}
