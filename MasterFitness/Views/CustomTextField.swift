//
//  CustomTextField.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class CustomTextField: UITextField {

    enum CustomTextFieldType {
        case username
        case email
        case password
        case text
    }

    private let authFieldType: CustomTextFieldType

    init(authFieldType: CustomTextFieldType) {
        self.authFieldType = authFieldType
        super.init(frame: .zero)

        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 10
        self.textColor = .white

        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))

        switch authFieldType {
        case .username:
            self.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            )
        case .email:
            self.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            )
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            )
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .text:
            self.placeholder = "Text"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

