//
//  SearchRepositoryCollectionViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxGesture

final class SearchRepositoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    var itemSelected: PublishRelay<SearchRepository> = .init()
    
    private let view: SearchRepositoryView = {
        let view = SearchRepositoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setProperties()
        contentView.addSubview(view)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseCollectionViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view.reset()
    }
    
    // MARK: - Internal methods
    
    func configure(with model: SearchRepository, isHiddenLineView: Bool? = nil) {
        view.configure(with: model, isHiddenLineView: isHiddenLineView)
        
        rx.tapGesture()
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.itemSelected.accept(model)
            }
            .disposed(by: cellDisposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        backgroundColor = .clear
    }
    
}

// MARK: - Layout

extension SearchRepositoryCollectionViewCell {
    
    private func layout() {
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
