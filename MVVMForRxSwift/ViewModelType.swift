//
//  ViewModelType.swift
//  MVVMForRxSwift
//
//  Created by Masanori Nakano on 2020/07/18.
//  Copyright © 2020 D128.work. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInputs {
    var tap: AnyObserver<()> { get }
}

protocol ViewModelOutputs {
    var errorMessage: Signal<String> { get }
    var text: Driver<String> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}
