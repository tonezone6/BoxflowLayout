//
//  CustomDelegate.swift
//  BoxFlowLayout
//
//  Created by Alex on 17/12/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class CustomDelegate: NSObject {
    private var sections: [Section] = []
    
    init(sections: [Section]) {
        self.sections = sections
    }
}

extension CustomDelegate: BoxflowLayoutDelegate {
    func boxFlowLayout(_: BoxflowLayout, flowInSection section: Int) -> BoxLayoutSectionFlow {
        switch sections[section] {
        case .plain:
            // return .plain(CGFloat((60...200).randomElement() ?? 40))
            return .plain(50)
        case .featured:
            return .featuredRows(200, 50)
        case .grid:
            return .featuredGrid(200, 150)
        }
    }
    
    func boxFlowLayout(_: BoxflowLayout, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func boxFlowLayout(_: BoxflowLayout, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
