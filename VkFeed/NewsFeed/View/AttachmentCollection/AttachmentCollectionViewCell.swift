//
//  AttachmentCollectionViewCell.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.01.2025.
//

import UIKit

final class AttachmentCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AttachmentCollectionViewCell"
    
    let imageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupAttachmentCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = Constants.commonCornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func set(imageURL: String?) {
        imageView.set(imageURL: imageURL)
    }
    
    private func setupAttachmentCell() {
        contentView.addSubview(imageView)
        imageView.fillSuperview()
    }
}
