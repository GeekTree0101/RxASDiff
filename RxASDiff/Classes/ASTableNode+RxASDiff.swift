//
//  ASTableNode+RxASDiff.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import DeepDiff

public struct ASRxDiffAnimate {
    public let delete: UITableViewRowAnimation
    public let insert: UITableViewRowAnimation
    public let reload: UITableViewRowAnimation
    
    public init(delete: UITableViewRowAnimation?,
                insert: UITableViewRowAnimation?,
                reload: UITableViewRowAnimation?) {
        self.delete = delete ?? .automatic
        self.insert = insert ?? .automatic
        self.reload = reload ?? .automatic
    }
    
    public init() {
        self.init(delete: .automatic,
                  insert: .automatic,
                  reload: .automatic)
    }
}

public extension Reactive where Base: ASTableNode {
    public func applyDiff<T: Hashable>(_ observer: Observable<[Change<T>]>,
                                       section: Int,
                                       completion: ((Bool) -> Void)?,
                                       animate: ASRxDiffAnimate = .init()) -> Disposable {
        return observer
            .map { IndexPathConverter().convert(changes: $0, section: section) }
            .subscribe(onNext: { iter in
                self.base.applyDiff(iter, animate: animate, completion: completion)
            })
    }
}

public extension ASTableNode {
    public func applyDiff(_ iter: ChangeWithIndexPath,
                          animate: ASRxDiffAnimate = .init(),
                          completion: ((Bool) -> Void)?) {
        self.performBatchUpdates({
            iter.deletes.executeIfPresent({
                self.deleteRows(at: $0, with: animate.delete)
            })
            
            iter.inserts.executeIfPresent({
                self.insertRows(at: $0, with: animate.insert)
            })
            
            iter.moves.executeIfPresent({
                for item in $0 {
                    self.moveRow(at: item.from, to: item.to)
                }
            })
            
            iter.replaces.executeIfPresent({
                self.reloadRows(at: $0, with: animate.reload)
            })
        }, completion: completion)
    }
}
