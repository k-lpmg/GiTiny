//
//  BaseCollectionViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var cellDisposeBag = DisposeBag()
    
    // MARK: - Overridden: UICollectionViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellDisposeBag = DisposeBag()
    }
    
}
