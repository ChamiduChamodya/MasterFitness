//
//  RegisterViewController.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class RegisterViewController: UIViewController {

    private let headerView = AuthHeaderView(title: "Sign Up", subTitle: "Create Your Account!")

    private let usernameTextField = CustomTextField(authFieldType: .username, placeholder: "")
    private let emailTextField = CustomTextField(authFieldType: .email, placeholder: "")
    private let passwordTextField = CustomTextField(authFieldType: .password, placeholder: "")

    private let signUpButton = CustomButton(title: "Confirm and Proceed", hasBackground: true ,fontSize: .big)
    private let signInButton = CustomButton(title: "Already Have an Account? Sign In" ,fontSize: .med)

    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowlwdge that you have read out Privacy Policy.")

        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .white
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.termsTextView.delegate = self

        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func didTapSignUp(){
        
        let registerUserRequest = RegisterUserRequest(
                    username: self.usernameTextField.text ?? "",
                    email: self.emailTextField.text ?? "",
                    password: self.passwordTextField.text ?? ""
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
        
        let values = [
            ["username": registerUserRequest.username],
            ["email": registerUserRequest.email],
            ["password": registerUserRequest.password],
        ]
        
        let data = ["data": values]
        
        let vc = UserdataViewController()
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @objc private func didTapSignIn(){
        self.navigationController?.popToRootViewController(animated: true)
    }

    private func setupUI(){
        self.view.backgroundColor = .black

        self.view.addSubview(headerView)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(termsTextView)
        self.view.addSubview(signInButton)

        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),

            self.usernameTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameTextField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 22),
            self.emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 55),
            self.emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            self.passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 44),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }

}


extension RegisterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://www.apple.com/legal/internet-services/terms/site.html")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://www.apple.com/legal/privacy/en-ww/")
        }

        return true
    }

    private func showWebViewerController(with urlString: String){
        let vc = WebViewController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
