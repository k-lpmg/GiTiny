//
//  UINavigationBar-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 07/04/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) {
        let key = "hidesShadow"
        guard value else {
            setValue(false, forKey: key)
            return
        }
        
        setValue(true, forKey: key)
    }
    
}
