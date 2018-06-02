//
//  ASCollectionNode+RxASDiff.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import DeepDiff

public extension Reactive where Base: ASCollectionNode {
    public func applyDiff<T: Hashable>(_ relay: ASDiffRelay<T>,
                                       section: Int,
                                       completion: ((Bool) -> Void)?) -> Disposable {
        return relay.rxDiff()
            .map { IndexPathConverter().convert(changes: $0, section: section) }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { iter in
                self.base.applyDiff(iter, completion: completion)
            })
    }
}

public extension ASCollectionNode {
    public func applyDiff(_ iter: ChangeWithIndexPath,
                          completion: ((Bool) -> Void)?) {
        self.performBatchUpdates({
            iter.deletes.executeIfPresent({
                self.deleteItems(at: $0)
            })
            
            iter.inserts.executeIfPresent({
                self.insertItems(at: $0)
            })
            
            iter.moves.executeIfPresent({
                for item in $0 {
                    self.moveItem(at: item.from, to: item.to)
                }
            })
            
            iter.replaces.executeIfPresent({
                self.reloadItems(at: $0)
            })
        }, completion: completion)
    }
}
