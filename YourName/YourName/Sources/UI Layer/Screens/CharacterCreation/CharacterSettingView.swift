//
//  CharacterCreationView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit
import SnapKit

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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.categoryItemFrameView?.addSubview(pageViewController.view)
        pageViewController.view.frame = categoryItemFrameView?.bounds ?? .zero
    }
    
    private func setupUI() {
        pageViewController.dataSource = self
        
        guard let firstViewController = displayCategoryItemsViewControllers.first else { return }
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func bind(to viewModel: CharacterSettingViewModel) {
        dispatch(to: viewModel)
        render(viewModel: viewModel)
    }
    
    private func dispatch(to viewModel: CharacterSettingViewModel) {
        viewModel.didLoad()
        
        categoryStackview?.arrangedSubviews.enumerated().forEach { (index, view) in
            view.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                self?.viewModel.tapCategory(at: index)
            }).disposed(by: disposeBag)
        }
    }
    
    private func render(viewModel: CharacterSettingViewModel) {
        viewModel.selectedCategory.distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedCategory in
                let beforeIndex = self?.selectedCategoryIndex
                let newIndex = selectedCategory.rawValue
                self?.selectedCategoryIndex = newIndex
                self?.scroll(from: beforeIndex ?? .zero, to: newIndex)
                self?.updateCategoryItem(selectedIndex: newIndex)
            }).disposed(by: disposeBag)
        
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
    
    private func updateCategoryItem(selectedIndex: Int) {
        self.categoryLabels?.enumerated().forEach { index, label in
            let isSelected = index == selectedIndex
            label.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
            label.textColor = isSelected ? Palette.black1 : Palette.gray2
        }
        print(selectedIndex)
        guard let selectedCategoryView = self.categoryStackview?.arrangedSubviews[safe: selectedIndex] else { return }
        selectedCategoryLineStart?.isActive = false
        selectedCategoryLineEnd?.isActive = false
        selectedCategoryLineStart = nil
        selectedCategoryLineEnd = nil
        selectedCategoryLineStart = selectedCategoryUnderLine?.leadingAnchor.constraint(equalTo: selectedCategoryView.leadingAnchor, constant: 3)
        selectedCategoryLineEnd = selectedCategoryUnderLine?.trailingAnchor.constraint(equalTo: selectedCategoryView.trailingAnchor, constant: -3)
        selectedCategoryLineStart?.isActive = true
        selectedCategoryLineEnd?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    private func scroll(from before: Int, to after: Int) {
        guard let selectedViewController = displayCategoryItemsViewControllers[safe: after] else { return }
        pageViewController.setViewControllers([selectedViewController], direction: before < after ? .forward : .forward, animated: true, completion: nil)
    }
    
    private let disposeBag = DisposeBag()
    private var categories = [ItemCategory]()
    private var selectedCategoryIndex = 0
    
    @IBOutlet private weak var bodyImageView: UIImageView?
    @IBOutlet private weak var eyeImageView: UIImageView?
    @IBOutlet private weak var noseImageView: UIImageView?
    @IBOutlet private weak var mouthImageView: UIImageView?
    @IBOutlet private weak var hairAccessoryImageView: UIImageView?
    @IBOutlet private weak var etcAccessoryImageView: UIImageView?
    @IBOutlet private weak var categoryStackview: UIStackView?
    @IBOutlet var categoryLabels: [UILabel]?
    @IBOutlet private weak var selectedCategoryUnderLine: UIView?
    private var selectedCategoryLineStart: NSLayoutConstraint?
    private var selectedCategoryLineEnd: NSLayoutConstraint?
    @IBOutlet weak var categoryItemFrameView: UIView?
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    private let displayCategoryItemsViewControllers = [
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .red },  // 몸
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .orange },  // 눈
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .yellow },  // 코
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .green },  // 입
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .blue },  // 장식1
        DisplayCharacterItemsViewController.instantiate().then { $0.view.backgroundColor = .purple }   // 장식2
    ]
}
extension CharacterSettingView: PageSheetContentView {
    var title: String { "캐릭터 생성하기" }
    var isModal: Bool { true }
}

extension CharacterSettingView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let previousViewController = displayCategoryItemsViewControllers[safe: self.selectedCategoryIndex - 1] else { return nil }
        return previousViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nextViewController = displayCategoryItemsViewControllers[safe: self.selectedCategoryIndex + 1] else { return nil }
        return nextViewController
    }
}
