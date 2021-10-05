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
    
    private func setupUI() {
        pageViewController.dataSource = self
        
        self.addSubview(pageViewController.view)
        if let itemsCollectionView = itemsCollectionView {
            pageViewController.view.snp.makeConstraints {
                $0.top.equalTo(itemsCollectionView.snp.top)
                $0.leading.trailing.bottom.equalTo(self)
            }
        }
        guard let firstViewController = categoryItemControllers.first else { return }
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: {_ in } )
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
                self?.updateCategoryItem(selectedIndex: selectedCategory.rawValue)
                let beforeIndex = self?.selectedCategoryIndex
                let newIndex = selectedCategory.rawValue
                self?.selectedCategoryIndex = newIndex
                self?.scroll(from: beforeIndex ?? .zero, to: newIndex)
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
        guard let selectedViewController = categoryItemControllers[safe: after] else { return }
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
    @IBOutlet private weak var itemsCollectionView: UICollectionView?
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    private let categoryItemControllers = [
        CategoryItemsViewController.instantiate(),  // 몸
        CategoryItemsViewController.instantiate(),  // 눈
        CategoryItemsViewController.instantiate(),  // 코
        CategoryItemsViewController.instantiate(),  // 입
        CategoryItemsViewController.instantiate(),  // 장식1
        CategoryItemsViewController.instantiate()   // 장식2
    ]
}
extension CharacterSettingView: PageSheetContentView {
    var title: String { "캐릭터 생성하기"}
    var isModal: Bool { true }
}

extension CharacterSettingView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        categoryItemControllers[safe: self.selectedCategoryIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        categoryItemControllers[safe: self.selectedCategoryIndex + 1]
    }
}
