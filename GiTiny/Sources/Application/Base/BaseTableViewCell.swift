//
//  BaseTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var cellDisposeBag = DisposeBag()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func configure(title: String) {
        let theme = AppAppearance.shared.theme.value
        
        fh.enable(normalColor: theme.fluidNormalColor2, highlightedColor: theme.fluidHighlightColor)
        textLabel?.text = title
        textLabel?.textColor = theme.textColor
    }
    
    // MARK: - Overridden: UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellDisposeBag = DisposeBag()
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        selectionStyle = .none
    }
    
}
