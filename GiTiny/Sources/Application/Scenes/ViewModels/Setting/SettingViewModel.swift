//
//  SettingViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa
import RxSwift

final class SettingViewModel {
    
    private let navigator: SettingNavigator
    private var disposeBag = DisposeBag()
    
    init(navigator: SettingNavigator) {
        self.navigator = navigator
    }
    
}

// MARK: - ViewModelType

extension SettingViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let accessTokenTrigger: Driver<AccessToken?>
        let selection: Driver<SettingSectionItem>
    }
    struct Output {
        let sections: Driver<[SettingSection]>
    }
    
    func transform(input: Input) -> Output {
        input.selection
            .drive(onNext: { [weak self] (item) in
                guard let self = self else {return}
                
                switch item {
                case .giTinyRepo:
                    let url = "https://github.com/k-lpmg/GiTiny"
                    guard UserDefaults.standard.object(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository) != nil else {
                        self.navigator.presentPanModalWeb(url)
                        return
                    }
                    guard UserDefaults.standard.bool(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository) else {
                        self.navigator.presentPanModalWeb(url)
                        return
                    }
                    self.navigator.presentPanModalWeb(url.appending("/blob/master/README.md"))
                case .openSourceLicenses:
                    self.navigator.pushOpenSourceLicenses()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        let sections = input.accessTokenTrigger
            .flatMapLatest { (accessToken) -> Driver<[SettingSection]> in
                return Observable<[SettingSection]>.create({ (observer) -> Disposable in
                    var items: [SettingSection] = [.section(items: [.darkTheme, .setREADME]),
                                                   .section(items: [.giTinyRepo, .openSourceLicenses])]
                    accessToken != nil ? items.append(.section(items: [.logout])) : ()
                    observer.onNext(items)
                    return Disposables.create()
                }).asDriverOnErrorJustNever()
        }
        
        return Output(sections: Driver.combineLatest(input.theme, sections) { $1 })
    }
    
}
