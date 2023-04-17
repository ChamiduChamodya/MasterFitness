//
//  SceneDelegate.swift
//  MasterFitness
//
//  Created by Chamidu on 17/04/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let scene = scene as? UIWindowScene else { return }
        let myWindow = UIWindow(windowScene: scene)
        let view = UINavigationController(rootViewController: ViewController())
        myWindow.rootViewController = view
        self.window = myWindow
        myWindow.makeKeyAndVisible()
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

