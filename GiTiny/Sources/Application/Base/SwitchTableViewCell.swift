//
//  SwitchTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Components
    
    let uiSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        contentView.addSubview(uiSwitch)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseTableViewCell
    
    func configure(title: String, isOn: Bool) {
        super.configure(title: title)
        
        uiSwitch.isOn = isOn
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension SwitchTableViewCell {
    
    private func layout() {
        uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        uiSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}
