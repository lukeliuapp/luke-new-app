//
//  LKAlertViewController.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit

class LKAlertViewController: UIViewController {
    let alertTitle: String
    let message: String
    let buttonTitle: String
        
    init(title: String, message: String, buttonTitle: String) {
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.addSubViews(containerView, titleLabel, actionButton, messageLabel)
        
        let padding: CGFloat = 20
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(220)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(padding)
            make.leading.trailing.equalTo(containerView).inset(padding)
            make.height.equalTo(28)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(containerView).inset(padding)
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-padding)
            make.leading.trailing.equalTo(containerView).inset(padding)
            make.height.equalTo(44)
        }
        
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func configure() {
        titleLabel.text = alertTitle
        messageLabel.text = message
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: - Subviews
    
    private let containerView = LKAlertContainerView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
}

class LKAlertContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
