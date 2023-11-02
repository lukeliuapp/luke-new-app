//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class HeadlinesViewController: LKLoadingViewController {
    enum DecorationType {
        static let sectionBackground = "sectionBackground"
    }
    
    enum Section: Hashable {
        case main
    }

    enum CellType: Hashable {
        case article(ArticleCellContent)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CellType>!
    private let disposeBag = DisposeBag()
    private let viewModel: HeadlinesViewModel

    init(viewModel: HeadlinesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBarAppearence()
        setupCollectionView()
        setupBindings()
    }

    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = refreshButtonItem
    }
    
    private func setupBindings() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoadingView() : self?.dismissLoadingView()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .asDriver()
            .drive(onNext: { [weak self] errorText in
                guard let errorText = errorText else { return }
                self?.presentLKAlertOnMainThread(title: "Something went wrong", message: errorText, buttonTitle: "OK")
            })
            .disposed(by: disposeBag)
        
        viewModel.content
            .asDriver()
            .drive(onNext: { content in
                var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
                snapshot.appendSections([.main])
                snapshot.appendItems(content?.headlineContents.map {CellType.article($0)} ?? [])
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        snapshot.appendSections([.main])
    }
    
    private func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, CellType>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, cellType in
                switch cellType {
                case let .article(content):
                    let cell: ArticleListCell = collectionView.dequeueCell(indexPath: indexPath)
                    cell.delegate = self
                    cell.configure(content: content)
                    return cell
                }
            }
        )
        
        collectionView.dataSource = dataSource
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionInt, _ -> NSCollectionLayoutSection? in
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[sectionInt]
            
            switch section {
            case .main:
                return self.createListSectionLayout()
            }
        }
        
        layout.register(SectionBackground.self, forDecorationViewOfKind: DecorationType.sectionBackground)
        return layout
    }
    
    private func createListSectionLayout() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection.createFullWidthLayout(estimatedHeight: 82)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: DecorationType.sectionBackground)
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16)
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func configureNavBarAppearence() {
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .clear
        navigationBarAppearence.backgroundColor = view.backgroundColor
        navigationBarAppearence.backgroundEffect = nil
        navigationItem.standardAppearance = navigationBarAppearence
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnRefreshButton() {
        viewModel.loadData()
    }
    
    // MARK: - Subviews
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ArticleListCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var refreshButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapOnRefreshButton))
        item.tintColor = .systemPink
        return item
    }()
}

extension HeadlinesViewController {
    final class SectionBackground: UICollectionReusableView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            backgroundColor = .systemBackground
            layer.cornerRadius = 12
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HeadlinesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellType = dataSource.itemIdentifier(for: indexPath) else { return }

        switch cellType {
        case .article(let articleContent):
            if let url = URL(string: articleContent.url) {
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.preferredControlTintColor = .systemPink
                present(safariViewController, animated: true)
            }
        }
    }
}

// MARK: - ArticleListCellDelegate

extension HeadlinesViewController: ArticleListCellDelegate {
    func didTapOnSaveButton(headlineContent: ArticleCellContent) {
        viewModel.saveOrRemoveArticle(with: headlineContent)
    }
}
