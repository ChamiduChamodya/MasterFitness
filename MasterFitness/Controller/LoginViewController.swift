//
//  LoginViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class LoginViewController: UIViewController {

    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign into Your Account!")

    private let emailTextField = CustomTextField(authFieldType: .email)
    private let passwordTextField = CustomTextField(authFieldType: .password)

    private let signInButton = CustomButton(title: "Sign In", hasBackground: true ,fontSize: .big)
    private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
    private let forgotPassButton = CustomButton(title: "Forgot Password?", fontSize: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPassButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc private func didTapSignIn(){
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }

    @objc private func didTapNewUser(){
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapForgotPassword(){
        let vc = ForgotPassViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setupUI(){
        self.view.backgroundColor = .black

        self.view.addSubview(headerView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPassButton)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPassButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),

            self.emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 55),
            self.emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            self.passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.forgotPassButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
            self.forgotPassButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.forgotPassButton.heightAnchor.constraint(equalToConstant: 44),
            self.forgotPassButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }

}
