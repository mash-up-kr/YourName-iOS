//
//  CharacterCreationView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit

typealias CharacterSettingViewController = PageSheetController<CharacterSettingView>
final class CharacterSettingView: UIView, NibLoadable {
    var viewModel: CharacterSettingViewModel!
}
extension CharacterSettingView: PageSheetContentView {
    var title: String { "캐릭터 생성하기"}
    var isModal: Bool { true }
}
