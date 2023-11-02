//
//  SourceListCell.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

class SourceListCell: UICollectionViewCell, ReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(content: SourceCellContent) {
        nameLabel.text = content.name
        descriptionLabel.text = content.description
        categoryLabel.text = "Category: \(content.category.capitalized)"
        languageLabel.text = "Language: \(content.language.uppercased())"
        checkmarkImageView.isHidden = !content.showCheckmark
    }
    
    private func setupUI() {
        contentView.addSubViews(nameLabel, descriptionLabel, categoryLabel, languageLabel, separatorLine, checkmarkImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(20)
        }
    }
    
    // MARK: - Subviews
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemPink
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        imageView.tintColor = .systemPink
        return imageView
    }()
}

