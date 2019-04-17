//
//  SearchRepositoryTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

final class SearchRepositoryTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Components
    
    private let view: SearchRepositoryView = {
        let view = SearchRepositoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(view)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseTableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view.reset()
    }
    
    // MARK: - Internal methods
    
    func configure(with model: SearchRepository) {
        view.configure(with: model)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension SearchRepositoryTableViewCell {
    
    private func layout() {
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
