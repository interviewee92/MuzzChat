//
//  ImageTitleView.swift
//  MuzzChat
//
//  Created by Barlomiej Wojdan on 08/10/2024.
//

import UIKit

final class ImageTitleView: UIView {
    
    private(set) weak var imageView: UIImageView!
    private(set) weak var titleLabel: UILabel!
    
    private let preferredHeight: CGFloat = 30.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: preferredHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageTitleView {
    func setUp() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = .padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: preferredHeight, height: preferredHeight))
        imageView.image = .icProfilePhotoPlaceholderFemale
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = preferredHeight * 0.5
        imageView.layer.masksToBounds = true
        
        stackView.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: preferredHeight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: preferredHeight).isActive = true
        self.imageView = imageView
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .leading
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.textColor = .muzzDarkGrayText
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
    }
}
