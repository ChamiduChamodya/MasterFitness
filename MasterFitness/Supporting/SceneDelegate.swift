//
//  SceneDelegate.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let scene = scene as? UIWindowScene else { return }
        let myWindow = UIWindow(windowScene: scene)
        self.window = myWindow
        self.window?.makeKeyAndVisible()
    }

    public func  checkAuthentication(){
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginViewController())
        } else {
            self.goToController(with: HomeViewController())
        }
    }

    private func goToController(with viewController: UIViewController){
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in

                let view = UINavigationController(rootViewController: viewController)
                self?.window?.rootViewController = view

                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }

            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

