//
//  AlertManager.swift
//  MasterFitness
//
//  Created by Chamidu on 18/04/2023.
//

import UIKit

class AlertManager {
    private static func showBasicalert(on vc: UIViewController, title : String, message : String?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// Validation Messages
extension AlertManager {
    public static func showInvalidEmailAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Invalid Email", message: "Please Enter a Valid Email!")
    }

    public static func showInvalidPasswordAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Invalid Password", message: "Please Enter a Valid Password!")
    }

    public static func showInvalidUsernameAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Invalid Username", message: "Please Enter a Valid Username!")
    }
    
    public static func showInvalidInputAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Invalid Input", message: "Please Enter a Valid Input!")
    }
    
    public static func showInvalidInputNumberAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Invalid Input", message: "Please Enter a Valid Numeric Input!")
    }
}

// Registration Messages
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Unknown Registration Error", message: nil)
    }

    public static func showRegistrationErrorAlert(on vc : UIViewController, with error : Error){
        self.showBasicalert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
}


// SignIn Messages
extension AlertManager {
    public static func showSignInErrorAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Unknown SignIn Error", message: nil)
    }

    public static func showSignInErrorAlert(on vc : UIViewController, with error : Error){
        self.showBasicalert(on: vc, title: "SignIn Error", message: "\(error.localizedDescription)")
    }
}

// LogOut Messages
extension AlertManager {
    public static func showLogOutErrorAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Unknown LogOut Error", message: nil)
    }

    public static func showLogOutErrorAlert(on vc : UIViewController, with error : Error){
        self.showBasicalert(on: vc, title: "LogOut Error", message: "\(error.localizedDescription)")
    }
}

// Forgot Password Messages
extension AlertManager {

    public static func showForgotPasswordResentSentAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Password Reset Sent!", message: nil)
    }

    public static func showForgotPasswordErrorAlert(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Unknown Password Reset Error", message: nil)
    }

    public static func showForgotPasswordErrorAlert(on vc : UIViewController, with error : Error){
        self.showBasicalert(on: vc, title: "Password Reset Error", message: "\(error.localizedDescription)")
    }
}

// User Messages
extension AlertManager {

    public static func showUnknownFetchingUserError(on vc : UIViewController){
        self.showBasicalert(on: vc, title: "Unknown Error Fetching User", message: nil)
    }

    public static func showFetchinguserErrorAlert(on vc : UIViewController, with error : Error){
        self.showBasicalert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
}
