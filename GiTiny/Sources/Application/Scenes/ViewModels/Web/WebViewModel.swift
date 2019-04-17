//
//  WebViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 04/04/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa
import RxSwift

final class WebViewModel {
    
}

// MARK: - ViewModelType

extension WebViewModel: ViewModelType {
    
    struct Input {
        let request: Driver<String>
    }
    struct Output {
        let url: Driver<URL>
    }
    
    func transform(input: Input) -> Output {
        let url: Driver<URL> = input.request
            .filter { URL(string: $0) != nil }
            .map { URL(string: $0)! }
        return Output(url: url)
    }
    
}
