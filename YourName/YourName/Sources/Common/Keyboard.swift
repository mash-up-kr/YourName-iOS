//
//  Keyboard.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation
import RxSwift
import RxRelay

protocol Keyboard {
    var isHidden: BehaviorRelay<Bool> { get }
    var height: BehaviorRelay<CGFloat> { get }
    var animationDuration: BehaviorRelay<TimeInterval> { get }
}

final class KeyboardImpl: NSObject, Keyboard {
    static let shared = KeyboardImpl()
    
    let isHidden = BehaviorRelay(value: false)
    let height = BehaviorRelay<CGFloat>(value: .zero)
    let animationDuration = BehaviorRelay(value: 0.25)
    
    override init() {
        super.init()
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 336
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                self?.height.accept(keyboardHeight)
                self?.animationDuration.accept(duration)
                self?.isHidden.accept(false)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {  [weak self] notification in
                let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 336
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                self?.height.accept(keyboardHeight)
                self?.animationDuration.accept(duration)
                self?.isHidden.accept(true)
            }).disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}
