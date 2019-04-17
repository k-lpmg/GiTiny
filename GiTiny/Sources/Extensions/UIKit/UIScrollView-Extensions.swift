//
//  UIScrollView-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 01/04/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
}
