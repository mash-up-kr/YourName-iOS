//
//  NibLoadable.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

protocol NibLoadable {
    func setupFromNib()
}
extension NibLoadable where Self: UIView {
    
    func setupFromNib() {
        guard let view = loadFromNib() else { return }
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: [:]).first as? UIView
    }
}

class NibLoadableView: UIView, NibLoadable {
    lazy var contentView = self.subviews.first ?? UIView()
    override var backgroundColor: UIColor? {
        get { self.subviews.first?.backgroundColor }
        set { self.subviews.first?.backgroundColor = newValue }
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}
