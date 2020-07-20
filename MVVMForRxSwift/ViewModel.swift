//
//  ViewModel.swift
//  MVVMForRxSwift
//
//  Created by Masanori Nakano on 2020/07/18.
//  Copyright © 2020 D128.work. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import Action

class ViewModel {
    private let inputsConnector = InputsConnector()
    private let outputsConnector = OutputsConnector()
    
    private let model = Model()
    
    init() {
        // inputs
        _ = self.inputsConnector.tapRelay.bind(to: self.model.increment.inputs)
        // outputs
        _ = self.model.increment.errors.compactMap {
                switch $0 {
                case .notEnabled:
                    return nil
                case let .underlyingError(error):
                    return error.localizedDescription
                }
            }.bind(to: self.outputsConnector.errorMessageRelay)
        
        _ = self.model.count.map { String($0) }
            .bind(to: self.outputsConnector.textRelay)
    }
}

extension ViewModel: ViewModelType {
    var inputs: ViewModelInputs { self.inputsConnector }
    var outputs: ViewModelOutputs { self.outputsConnector }
}

private extension ViewModel {
    class InputsConnector {
        let tapRelay: PublishRelay<()>
        let tap: AnyObserver<()>
        
        init() {
            let tapRelay = PublishRelay<()>()
            self.tap = AnyObserver { event in
                guard case .next(let value) = event else { return }
                tapRelay.accept(value)
            }
            self.tapRelay = tapRelay
        }
    }

    class OutputsConnector {
        let errorMessageRelay = PublishRelay<String>()
        let errorMessage: Signal<String>
        
        let textRelay = BehaviorRelay<String>(value: "")
        let text: Driver<String>
        
        init() {
            self.errorMessage = self.errorMessageRelay.asSignal()
            self.text = self.textRelay.asDriver()
        }
    }
}

extension ViewModel.InputsConnector: ViewModelInputs {
}

extension ViewModel.OutputsConnector: ViewModelOutputs {
}
