//
//  UIImageView-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func changePngColorTo(color: UIColor) {
        guard let image =  self.image else {return}
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}
