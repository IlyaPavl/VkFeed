//
//  TitleView.swift
//  VkFeed
//
//  Created by Илья Павлов on 13.01.2025.
//

import UIKit

protocol TitleViewModel {
    var profileImageURL: String? { get }
}

protocol TitleViewDelegate: AnyObject {
    func showLogoutAlert(with alert: UIAlertController)
    func didTapLogout()
}

final class TitleView: UIView {

    weak var delegate: TitleViewDelegate?
    private var searchTextField = CustomTextField()
    
    private var profileAvatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleView()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileAvatarView.layer.masksToBounds = true
        profileAvatarView.layer.cornerRadius = profileAvatarView.frame.width / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    func set(userViewModel: TitleViewModel) {
        profileAvatarView.set(imageURL: userViewModel.profileImageURL)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnProfileAvatar))
        profileAvatarView.addGestureRecognizer(tapGesture)
        profileAvatarView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTapOnProfileAvatar() {
        let alertController = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.delegate?.didTapLogout()
        }
        alertController.addAction(logoutAction)
        delegate?.showLogoutAlert(with: alertController)
    }
    
    private func setupTitleView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchTextField)
        addSubview(profileAvatarView)
        setupTitleViewConstraints()
    }
    
    private func setupTitleViewConstraints() {
        profileAvatarView.anchor(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: trailingAnchor,
            padding: Constants.profileAvatarInsets
        )
        
        profileAvatarView.heightAnchor.constraint(equalTo: searchTextField.heightAnchor, multiplier: 1).isActive = true
        profileAvatarView.widthAnchor.constraint(equalTo: searchTextField.heightAnchor, multiplier: 1).isActive = true
        
        searchTextField.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: profileAvatarView.leadingAnchor,
            padding: Constants.profileAvatarInsets
        )
    }
}
