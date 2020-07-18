//
//  ViewController.swift
//  MVVMForRxSwift
//
//  Created by Masanori Nakano on 2020/07/18.
//  Copyright © 2020 D128.work. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet private weak var button: UIButton! {
        didSet {
            _ = self.button.rx.controlEvent(.touchUpInside)
                .asSignal()
                .emit(to: self.viewModel.inputs.tap)
        }
    }

    @IBOutlet private weak var label: UILabel! {
        didSet {
            _ = self.viewModel.outputs.text
                .drive(self.label.rx.text)
        }
    }

    private let viewModel: ViewModelType = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.viewModel.outputs.errorMessage
            .emit(to: self.view.rx.showError)
    }

}

private extension Reactive where Base: UIView {

    var showError: Binder<String> {
        Binder(self.base) { view, text in
            view.makeToast(text)
        }
    }
    
}
