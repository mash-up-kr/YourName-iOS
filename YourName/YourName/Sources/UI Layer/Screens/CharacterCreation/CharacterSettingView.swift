//
//  CharacterCreationView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import RxCocoa
import RxSwift
import UIKit

typealias CharacterSettingViewController = PageSheetController<CharacterSettingView>

final class CharacterSettingView: UIView, NibLoadable {
    
    var viewModel: CharacterSettingViewModel! {
        didSet {
            bind(to: viewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func bind(to viewModel: CharacterSettingViewModel) {
        dispatch(to: viewModel)
        render(viewModel: viewModel)
    }
    
    private func dispatch(to viewModel: CharacterSettingViewModel) {
        
    }
    
    private func render(viewModel: CharacterSettingViewModel) {
        viewModel.characterMeta.distinctUntilChanged()
            .subscribe(onNext: { [weak self] characterMeta in
                self?.bodyImageView?.image = UIImage(named: characterMeta.bodyID)
                self?.eyeImageView?.image = UIImage(named: characterMeta.eyeID)
                self?.noseImageView?.image = UIImage(named: characterMeta.noseID)
                self?.mouthImageView?.image = UIImage(named: characterMeta.mouthID)
                self?.hairAccessoryImageView?.image = UIImage(named: characterMeta.hairAccessoryID ?? .empty)
                self?.etcAccessoryImageView?.image = UIImage(named: characterMeta.etcAccesstoryID ?? .empty)
            }).disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var bodyImageView: UIImageView?
    @IBOutlet private weak var eyeImageView: UIImageView?
    @IBOutlet private weak var noseImageView: UIImageView?
    @IBOutlet private weak var mouthImageView: UIImageView?
    @IBOutlet private weak var hairAccessoryImageView: UIImageView?
    @IBOutlet private weak var etcAccessoryImageView: UIImageView?
}
extension CharacterSettingView: PageSheetContentView {
    var title: String { "캐릭터 생성하기"}
    var isModal: Bool { true }
}

struct CharacterMeta: Equatable {
    let bodyID: String
    let eyeID: String
    let noseID: String
    let mouthID: String
    let hairAccessoryID: String?
    let etcAccesstoryID: String?
}
extension CharacterMeta {
    static let `default` = CharacterMeta(
        bodyID: "body_3",
        eyeID: "eye_5",
        noseID: "nose_5",
        mouthID: "mouth_6",
        hairAccessoryID: "hairAccessory_8",
        etcAccesstoryID: "accessory_3"
    )
}
