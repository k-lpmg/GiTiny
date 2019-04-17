//
//  ViewModelType.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
