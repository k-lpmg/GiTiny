//
//  UIStoryboard+Reusable.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

extension UIViewController: Reusable {}
extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError()
        }
        return viewController
    }
}
