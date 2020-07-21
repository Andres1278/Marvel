//
//  UIImageView+AlamofireImage.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(with url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        af.setImage(withURL: url, completion: { [weak self] response in
            guard response.error == nil else {
                self?.image = placeholder
                return
            }
        })
    }
}
