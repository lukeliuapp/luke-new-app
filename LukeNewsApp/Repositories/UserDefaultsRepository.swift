//
//  UserDefaultsRepository.swift
//  NewsApp
//
//  Created by Luke Liu on 2/11/2023.
//

import RxSwift

protocol UserDefaultsRepository {
    var savedArticles: UserDefault<[Data]> { get set }
    var selectedSourceIDs: UserDefault<[String]> { get set }
}

class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    lazy var savedArticles = UserDefault<[Data]>(userDefaults: userDefaults, key: .savedArticles, defaultValue: [])
    lazy var selectedSourceIDs = UserDefault<[String]>(userDefaults: userDefaults, key: .selectedSourceIDs, defaultValue: ["abc-news"])
}

enum UserDefaultKey: String {
    case savedArticles
    case selectedSourceIDs
}

struct UserDefault<T> {
    private let userDefaults: UserDefaults
    private let key: UserDefaultKey
    private let defaultValue: T
    
    init(
        userDefaults: UserDefaults,
        key: UserDefaultKey,
        defaultValue: T
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var value: T {
        get { return userDefaults.object(forKey: key.rawValue) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key.rawValue) }
    }
    
    var observable: Observable<T> {
        userDefaults.rx
            .observe(T.self, key.rawValue)
            .compactMap { $0 ?? defaultValue }
    }
    
    func clear() {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
