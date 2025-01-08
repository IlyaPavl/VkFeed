//
//  NewsFeedTableViewCell.swift
//  VkFeed
//
//  Created by Илья Павлов on 12.05.2024.
//

import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomView: CGRect { get }
    var totalHeight: CGFloat { get }
}

class NewsFeedTableViewCell: UITableViewCell {
    static let cellIdentifier = "postIdentifier"
    
    // Первый слой
    private let cardView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Второй слой
    private let topView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Constants.postLabelFont
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Третий слой на topView
    let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = Constants.profileImageViewHeight / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // Третий слой на bottomView
    let likesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Constants.bottomViewHeight / 2
        view.clipsToBounds = true
        return view
    }()
    
    let commentsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Constants.bottomViewHeight / 2
        view.clipsToBounds = true
        return view
    }()
    
    let sharesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Constants.bottomViewHeight / 2
        view.clipsToBounds = true
        return view
    }()
    
    let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Четвертый слой на bottomView
    let likesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "heart")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let commentsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "message")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let sharesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrowshape.turn.up.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "eye")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        
        if viewModel.likes != "0" {
            likesLabel.text = viewModel.likes
        }
        
        if viewModel.comments != "0" {
            commentsLabel.text = viewModel.comments
        }
        
        if viewModel.shares != "0" {
            sharesLabel.text = viewModel.shares
        }
        
        viewsLabel.text = viewModel.views
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachmentFrame
        bottomView.frame = viewModel.sizes.bottomView
        
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}


// MARK: - Setup Constraints
extension NewsFeedTableViewCell {
    private func setupConstraints() {
        setupFirstLayerConstraints()
        setupSecondLayerConstraints()
        setupThirdLayerTopConstraints()
        setupBottomViewItemsConstraints()
        setupForthLayerBottomConstraints()
    }
    
    private func setupFirstLayerConstraints() {
        addSubview(cardView)
        cardView.fillSuperview(padding: Constants.cardInsets)
    }
    
    private func setupSecondLayerConstraints() {
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(postImageView)
        cardView.addSubview(bottomView)
        
        // topView Constraints
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.commonPadding).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.commonPadding).isActive = true
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.commonPadding).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
    }
    
    private func setupThirdLayerTopConstraints() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        // iconImageView Constraints
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.profileImageViewHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.profileImageViewHeight).isActive = true
        
        // nameLabel Constraints
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.commonPadding).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -Constants.commonPadding).isActive = true
        nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Constants.groupNameLabelHeight).isActive = true
        
        // dateLabel Constraints
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.commonPadding).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -Constants.commonPadding).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
    }
    
    private func setupBottomViewItemsConstraints() {
        
        bottomView.addSubview(likesContainer)
        bottomView.addSubview(commentsContainer)
        bottomView.addSubview(sharesContainer)
        bottomView.addSubview(viewContainer)

        let leftContainers = [likesContainer, commentsContainer, sharesContainer]

        for (index, container) in leftContainers.enumerated() {
            container.anchor(top: bottomView.topAnchor,
                             leading: nil,
                             bottom: bottomView.bottomAnchor,
                             trailing: nil,
                             padding: Constants.bottomViewItemInset)

            if index == 0 {
                container.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.bottomViewItemInset.left).isActive = true
            } else {
                container.leadingAnchor.constraint(equalTo: leftContainers[index - 1].trailingAnchor, constant: Constants.bottomViewItemInset.left).isActive = true
            }
        }

        viewContainer.anchor(top: bottomView.topAnchor,
                             leading: nil,
                             bottom: bottomView.bottomAnchor,
                             trailing: bottomView.trailingAnchor,
                             padding: Constants.bottomViewItemInset)


        // Ограничения минимальной ширины
        NSLayoutConstraint.activate(
            leftContainers.map { $0.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.bottomViewItemMinWidth) }
        )
        viewContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.bottomViewItemMinWidth).isActive = true
    }
    
    private func setupForthLayerBottomConstraints() {
        likesContainer.addSubview(likesImage)
        likesContainer.addSubview(likesLabel)
        
        commentsContainer.addSubview(commentsImage)
        commentsContainer.addSubview(commentsLabel)
        
        sharesContainer.addSubview(sharesImage)
        sharesContainer.addSubview(sharesLabel)
        
        viewContainer.addSubview(viewsImage)
        viewContainer.addSubview(viewsLabel)
        
        fourthLayerBuilder(view: likesContainer, imageView: likesImage, label: likesLabel)
        fourthLayerBuilder(view: commentsContainer, imageView: commentsImage, label: commentsLabel)
        fourthLayerBuilder(view: sharesContainer, imageView: sharesImage, label: sharesLabel)
        fourthLayerBuilder(view: viewContainer, imageView: viewsImage, label: viewsLabel)
    }
    
    private func fourthLayerBuilder(view: UIView, imageView: UIImageView, label: UILabel) {
        // imageView constraints
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewItemIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.bottomViewItemIconSize).isActive = true
        
        // label constraints
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -4).isActive = true
    }
}
