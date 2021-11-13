//
//  ToastView.swift
//  MEETU
//
//  Created by seori on 2021/11/14.
//

import UIKit
import Then

final class ToastView: UIView {
    
    private let toastLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .white
    }
    private let meetuImage = UIImageView().then {
        $0.image = UIImage(named: "meetu_toast")!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(text: String) {
        super.init(frame: .init(x: 0, y: 0, width: 256, height: 56))
        self.toastLabel.text = text
        self.configureUI()
        self.layout()
    }
    
    private func configureUI() {
        self.backgroundColor = Palette.black1
        self.layer.cornerRadius = 8
    }
    
    private func layout() {
        self.addSubviews(meetuImage, toastLabel)
        meetuImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28)
            $0.height.equalTo(34)
        }
        toastLabel.snp.makeConstraints {
            $0.leading.equalTo(meetuImage.snp.trailing).offset(11)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11)
        }
    }
}
