//
//  Model.swift
//  MVVMForRxSwift
//
//  Created by Masanori Nakano on 2020/07/18.
//  Copyright © 2020 D128.work. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Action

class Model {
    private let _count = BehaviorRelay<Int>(value: 0)
    var count: Observable<Int> { self._count.asObservable() }
    
    private(set) lazy var increment = Action<Void, Int> { [weak self] in
        do {
            guard let value = try self?.incrementCount() else {
                return .empty()
            }
            
            return .just(value)
        } catch {
            return .error(error)
        }
    }
    
    private func incrementCount() throws -> Int {
        if self._count.value == 10 {
            throw NSError(
                domain: "",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "これ以上インクリメントできません"]
            )
        }
                
        self._count.accept(self._count.value + 1)
        return self._count.value
    }
}
