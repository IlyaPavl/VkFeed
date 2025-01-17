//
//  SceneDelegate.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.12.2023.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authService: AuthService?
    let authVC = AuthViewController()
    
    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) ?? SceneDelegate()

        return sceneDelegate
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        authService = AuthService()
        authService?.delegate = self
        
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

//MARK: - AuthServiceDelegate
extension SceneDelegate: AuthServiceDelegate {
    func authServiceShouldShow(viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true)
    }
    
    func authServiceSignIn() {
        print(#function)
        let newsFeedVC = NewsFeedViewController()
        let navVC = UINavigationController(rootViewController: newsFeedVC)
        window?.rootViewController = navVC
    }
    
    func authServiceSignInDidFail() {
        print(#function)

    }
    
    func authServiceDidLogout() {
        window?.rootViewController?.dismiss(animated: true, completion: {
            self.window?.rootViewController = UINavigationController(rootViewController: self.authVC)
        })
    }
}
