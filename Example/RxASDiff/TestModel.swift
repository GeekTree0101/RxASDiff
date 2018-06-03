//
//  TestModel.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation

struct TestModel: Hashable {
    let title: String
    
    var hashValue: Int {
        return title.hashValue
    }
    
    init(_ num: Int) {
        title = "\(num)"
    }
}
