//
//  Rx-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 29/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    
    func not() -> Observable<Bool> {
        return map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
}

extension ObservableType {
    
    func catchErrorJustNever() -> Observable<E> {
        return catchError { _ in
            return Observable.never()
        }
    }
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustNever() -> Driver<E> {
        return asDriver(onErrorDriveWith: .never())
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}

extension PrimitiveSequence {
    
    func asDriverOnErrorJustNever() -> Driver<E> {
        return asDriver(onErrorDriveWith: .never())
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
}
