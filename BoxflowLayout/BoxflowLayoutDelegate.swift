//
//  BoxLayoutDelegate.swift
//  CustomCollectionViewFlow
//
//  Created by Alex on 17/12/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

enum BoxLayoutSectionFlow {
    case plain(CGFloat)                 // table view row style
    case featuredRows(CGFloat, CGFloat) // rows with featured on top
    case featuredGrid(CGFloat, CGFloat) // grid with featured on top
}

protocol BoxflowLayoutDelegate: class {
    func boxflowLayout(_: BoxflowLayout, flowInSection section: Int) -> BoxLayoutSectionFlow    // * required *
    func boxflowLayout(_: BoxflowLayout, heightForHeaderInSection section: Int) -> CGFloat      // optional
    func boxflowLayout(_: BoxflowLayout, heightForFooterInSection section: Int) -> CGFloat      // optional
}

extension BoxflowLayoutDelegate {
    func boxflowLayout(_: BoxflowLayout, heightForHeaderInSection section: Int) -> CGFloat { return 0 }
    func boxflowLayout(_: BoxflowLayout, heightForFooterInSection section: Int) -> CGFloat { return 0 }
}
