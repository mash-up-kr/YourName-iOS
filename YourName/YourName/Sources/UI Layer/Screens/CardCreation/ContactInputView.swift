//
//  ContactInputView.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import RxSwift
import RxCocoa
import UIKit

enum ContactType: Int, CaseIterable {
    case phone
    case email
    case sns
}
extension ContactType: CustomStringConvertible {
    var description: String {
        switch self {
        case .phone: return "전화번호"
        case .email: return "이메일"
        case .sns: return "SNS"
        }
    }
}

struct ContactInfo {
    var type: ContactType
    var value: String
}

final class ContactInputView: UIView {
    @IBOutlet fileprivate weak var contactTypeView: UIView?
    @IBOutlet fileprivate weak var contactTypeLabel: UILabel?
    @IBOutlet fileprivate weak var contactValueField: UITextField?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with model: ContactInfo) {
        contactTypeLabel?.text = model.type.description
        contactValueField?.text = model.value
    }
}

extension Reactive where Base: ContactInputView {
    
    var tapContactType: Observable<Void> {
        guard let contactTypeView = base.contactTypeView else { return .empty() }
        return contactTypeView.rx.tapGesture().when(.recognized).map { _ in Void() }
    }
    
    var contactType: BehaviorRelay<ContactType> {
        let contactTypeRelay = BehaviorRelay<ContactType>(value: .phone)
        return contactTypeRelay
    }
    
    var contactValue: Observable<String> {
        guard let contactValueField = base.contactValueField else { return .empty() }
        return contactValueField.rx.text.filterNil()
    }
}
