//
//  SearchUserViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa

final class SearchUserViewModel {
    
    private let useCase: SearchUserTableViewCellUseCase
    
    init(useCase: SearchUserTableViewCellUseCase) {
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension SearchUserViewModel: ViewModelType {
    
    struct Input {
        let username: Driver<String>
    }
    struct Output {
        let user: Driver<User>
    }
    
    func transform(input: Input) -> Output {
        let user: Driver<User> = input.username
            .flatMapLatest { [weak self] (username) in
                guard let self = self else {return Driver.empty()}
                return self.useCase.getUser(username: username)
            }
        return Output(user: user)
    }
    
}
