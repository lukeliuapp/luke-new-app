//
//  ArticleListCell.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit
import Kingfisher

protocol ArticleListCellDelegate: AnyObject {
    func didTapOnSaveButton(headlineContent: ArticleCellContent)
}

class ArticleListCell: UICollectionViewCell, ReusableView {
    weak var delegate: ArticleListCellDelegate?
    
    var headlineContent: ArticleCellContent?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(content: ArticleCellContent) {
        headlineContent = content
        
        if let imageUrlString = content.urlToImage {
            articleImageView.kf.setImage(with: URL(string: imageUrlString))
        }
        
        titleLabel.text = content.title
        descriptionLabel.text = content.description ?? "Tap to see details"
        authorLabel.text = content.author ?? "Anonymous"
        
        let dateText = content.publishedAt.formatDateToReadableStyle()
        dateLabel.text = dateText ?? "Unknown Date"
        
        saveButton.isSelected = content.isSaved
    }
    
    private func setupUI() {
        contentView.addSubViews(articleImageView, titleLabel, authorLabel, descriptionLabel, dateLabel, separatorLine, saveButton)
        
        articleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(50)
            make.top.equalToSuperview().offset(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(articleImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.leading.equalTo(articleImageView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.size.equalTo(50)
        }
        
        saveButton.addTarget(self, action: #selector(tappedOnSaveButton), for: .touchUpInside)
    }
    
    @objc private func tappedOnSaveButton() {
        guard let headlineContent = headlineContent else { return }
        delegate?.didTapOnSaveButton(headlineContent: headlineContent)
    }
    
    // MARK: - Subviews
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemPink
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemPink
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemPink
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: [.selected, .highlighted])
        return button
    }()
}
