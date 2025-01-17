//
//  CustomTextField.swift
//  VkFeed
//
//  Created by Илья Павлов on 13.01.2025.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomTextFieldView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    private func setupCustomTextFieldView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        placeholder = "Поиск..."
        font = Constants.searchBarFont
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = Constants.commonCornerRadius
        layer.masksToBounds = true
        
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        leftView = UIImageView(image: image)
        leftView?.tintColor = .systemGray4
        leftViewMode = .always
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
    }
}
