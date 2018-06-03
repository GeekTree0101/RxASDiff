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
