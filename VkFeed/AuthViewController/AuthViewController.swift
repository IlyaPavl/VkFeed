//
//  ViewController.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.12.2023.
//

import UIKit

class AuthViewController: UIViewController {
    private var authService: AuthService!

    var loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        setupAuthVC()
    }
}

extension AuthViewController {
    func setupAuthVC() {
        view.backgroundColor = .systemGray5
        
        loginButton.backgroundColor = UIColor.systemBlue
        loginButton.setTitle("Авторизация ВКонтакте", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 15
        
        let buttonSize = loginButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let xButton = (view.frame.width - buttonSize.width - 40) / 2
        let yButton = (view.frame.height - buttonSize.height - 5) / 2
        
        loginButton.frame = CGRect(x: Int(xButton), y: Int(yButton), width: Int(buttonSize.width) + 40, height: Int(buttonSize.height) + 5)
        
        loginButton.addTarget(self, action: #selector(authantication), for: .touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    @objc func authantication() {
        authService.wakeUpSession()
    }
}
