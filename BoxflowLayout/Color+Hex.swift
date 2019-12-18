//
//  Color+Hex.swift
//  CustomCollectionViewFlow
//
//  Created by Alex on 17/12/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let chars = Array(hex.dropFirst())
        self.init(
            red:    .init(strtoul(String(chars[0...1]), nil, 16))/255,
            green:  .init(strtoul(String(chars[2...3]), nil, 16))/255,
            blue:   .init(strtoul(String(chars[4...5]), nil, 16))/255,
            alpha:  1.0
        )
    }
}
