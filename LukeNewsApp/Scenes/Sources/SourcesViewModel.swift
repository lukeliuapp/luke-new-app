//
//  SourcesViewModel.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import RxCocoa
import RxSwift

class SourcesViewModel {
    let title: Driver<String> = .just("News Source List")
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let content: BehaviorRelay<Content?> = .init(value: nil)
    let errorMessage: BehaviorRelay<String?> = .init(value: nil)
    
    private let articleSourceRepository: SourcesRepository
    private let articleSourceManager: ArticleSourceManager
    private var disposeBag = DisposeBag()
    
    init(
        articleSourceRepository: SourcesRepository = SourcesRepositoryImpl(),
        articleSourceManager: ArticleSourceManager
    ) {
        self.articleSourceRepository = articleSourceRepository
        self.articleSourceManager = articleSourceManager
        loadData()
    }
    
    func loadData() {
        disposeBag = DisposeBag()
        
        isLoading.accept(true)
        
        Observable
            .combineLatest(articleSourceRepository.fetchSources(), articleSourceManager.getObservableSelectedSourceIds())
            .subscribe(onNext: { [weak self] (sources, selectedSourceIds) in
                let sourceContents = sources.map { source in
                    SourceCellContent(
                        id: source.id,
                        name: source.name,
                        description: source.description,
                        category: source.category,
                        language: source.language,
                        showCheckmark: selectedSourceIds.contains(where: { $0 == source.id })
                    )}
                self?.content.accept(Content(sourceContents: sourceContents))
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                if let error = error as? LKNetworkError {
                    self?.errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func addOrRemoveSelectedSourceId(with id: String) {
        let ids = articleSourceManager.getSelectedSourceIds()
        let isIdExisting = ids.contains(where: { $0 == id })
        
        if ids.count == 1 && isIdExisting {
            errorMessage.accept("At least one source must be selected")
            return
        }
        
        isIdExisting ? articleSourceManager.removeSourceId(with: id) : articleSourceManager.addSourceId(with: id)
    }
}

extension SourcesViewModel {
    struct Content: Hashable {
        let sourceContents: [SourceCellContent]
    }
}
