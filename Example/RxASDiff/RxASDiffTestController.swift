//
//  RxASDiffTestController.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import AsyncDisplayKit
import RxASDiff
import RxSwift

class RxASDiffTestController: ASViewController<ASDisplayNode> {
    
    enum Section: Int {
        case prepend
        case item
        case append
    }
    
    let diffRelay = ASDiffRelay<TestModel>([6 ,7 ,8 ,9 ,10].map { TestModel($0) }, skip: 0)
    var count: Int = 0
    
    var prependItemList: [TestModel] = [1, 2, 3, 4, 5].map { TestModel($0) }
    var appendItemList: [TestModel] = [11, 12, 13, 14, 15].map { TestModel($0) }

    struct Const {
        static let section: Int = 3
    }
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.delegate = self
        node.dataSource = self
        return node
    }()
    
    let bag = DisposeBag()
    
    init() {
        super.init(node: ASDisplayNode())
        node.layoutSpecBlock = { [weak self] (_, size) -> ASLayoutSpec in
            return self?.layoutSpecThatFits(size) ?? ASLayoutSpec()
        }
        node.onDidLoad({ [weak self] _ in
            self?.didLoad()
        })
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diffRelay
            .rxDiff(section: Section.item.rawValue)
            .subscribe(onNext: { [weak self] diff, totalCount in
                guard let `self` = self else { return }
                self.count = totalCount
                self.tableNode.applyDiff(diff, completion: nil)
            }).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: tableNode)
    }
    
    func didLoad() {
        self.tableNode.view.showsHorizontalScrollIndicator = false
        self.tableNode.view.showsVerticalScrollIndicator = false
        self.tableNode.view.separatorStyle = .none
    }
}

extension RxASDiffTestController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return Const.section
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.prepend.rawValue:
            return 1
        case Section.item.rawValue:
            return count
        case Section.append.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = RxASDiffTestCellNode()
            switch indexPath.section {
            case Section.prepend.rawValue:
                node.loadMore(isAppend: false)
            case Section.item.rawValue:
                guard indexPath.row < self.diffRelay.value.count else {
                    return ASCellNode()
                }
                let model = self.diffRelay.value[indexPath.row]
                node.bindMore(model)
            case Section.append.rawValue:
                node.loadMore(isAppend: true)
            default:
                return ASCellNode()
            }
            return node
        }
    }
}

extension RxASDiffTestController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.prepend.rawValue:
            guard !self.prependItemList.isEmpty else { return }
            self.diffRelay.prepend(self.prependItemList)
            self.prependItemList.removeAll()
        case Section.append.rawValue:
            guard !self.appendItemList.isEmpty else { return }
            self.diffRelay.append(self.appendItemList)
            self.appendItemList.removeAll()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard Section.item.rawValue == indexPath.section else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Remove", handler: { action, indexPath in
            guard indexPath.row < self.diffRelay.value.count else { return }
            let model = self.diffRelay.value[indexPath.row]
            self.diffRelay.remove(model)
        })
        
        return [deleteAction]
    }
}
