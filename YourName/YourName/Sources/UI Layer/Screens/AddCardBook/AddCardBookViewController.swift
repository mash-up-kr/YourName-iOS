//
//  AddCardBookViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa

final class AddCardBookViewController: ViewController, Storyboarded {
    
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var cardBookCoverColorCollectionView: UICollectionView!
    @IBOutlet private weak var cardBookDescriptionTextField: UITextField!
    @IBOutlet private weak var cardBookNameTextField: UITextField!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: AddCardBookViewModel!
    private let disposeBag = DisposeBag()
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configure(self.cardBookNameTextField, self.cardBookDescriptionTextField)
    }
    
    private func bind() {
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configure(_ textFields: UITextField...) {
        textFields.forEach { textField in
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.borderWidth = 1
            textField.borderColor = .lightGray
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.bounds.height))
            textField.leftViewMode = .always
        }
    }
}
