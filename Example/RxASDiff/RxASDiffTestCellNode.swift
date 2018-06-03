//
//  RxASDiffTestCellNode.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import AsyncDisplayKit

class RxASDiffTestCellNode: ASCellNode {
    typealias Node = RxASDiffTestCellNode
    
    lazy var buttonNode = ASButtonNode()

    override init() {
        super.init()
        self.selectionStyle = .none
        let screenSize = UIScreen.main.bounds
        self.buttonNode.cornerRadius = screenSize.width / 8.0
        self.automaticallyManagesSubnodes = true
    }
    
    func bindMore(_ model: TestModel) {
        let screenSize = UIScreen.main.bounds
        self.style.preferredSize = .init(width: screenSize.width,
                                         height: screenSize.width * 2 / 3 + 20.0)
        self.buttonNode.style.preferredSize = .init(width: screenSize.width * 2 / 3,
                                                  height: screenSize.width * 2 / 3)
        self.buttonNode.backgroundColor = UIColor.randomColor
        self.buttonNode.setAttributedTitle(NSAttributedString(string: "\(model.title)", attributes: Node.attr),
                                           for: .normal)
    }
    
    func loadMore(isAppend: Bool) {
        let screenSize = UIScreen.main.bounds
        self.style.preferredSize = .init(width: screenSize.width,
                                         height: screenSize.width / 3.0)
        self.buttonNode.style.preferredSize = .init(width: screenSize.width * 2 / 3,
                                                  height: screenSize.width / 4.0)
        self.buttonNode.backgroundColor = UIColor.darkGray
        self.buttonNode.setAttributedTitle(NSAttributedString(string: isAppend ? "append": "prepend",
                                                              attributes: Node.attr), for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: [], child: buttonNode)
    }
    
    static var attr: [NSAttributedStringKey: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return [.font: UIFont.systemFont(ofSize: 30, weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph]
    }
}
