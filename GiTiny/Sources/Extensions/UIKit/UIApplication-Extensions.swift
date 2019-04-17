//
//  UIApplication-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func refresh() {
        windows.forEach({ (window) in
            window.subviews.forEach({ (view) in
                view.removeFromSuperview()
                window.addSubview(view)
            })
        })
    }
    
}
