//
//  FooterView.swift
//  VkFeed
//
//  Created by Илья Павлов on 17.01.2025.
//

import UIKit

final class FooterView: UIView {
    
    private let descriptionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = Constants.footerDescriptionFont
        return label
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFooterView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func setDescription(_ text: String) {
        descriptionlabel.text = text
    }
    
    private func setupFooterView() {
        addSubview(descriptionlabel)
        addSubview(loader)
        descriptionlabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: Constants.footerDescriptionInsets
        )
        loader.centerXAnchor
            .constraint(equalTo: centerXAnchor).isActive = true
        loader.topAnchor
            .constraint(equalTo: descriptionlabel.bottomAnchor, constant: Constants.commonPadding).isActive = true
    }
}
