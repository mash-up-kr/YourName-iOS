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
        didSet { bind(to: viewModel) }
    }
    var displayCharacterItemsViewControllerFactory: (([ItemCategory]) -> [DisplayCharacterItemsViewController])!
    var onComplete: (() -> Void)?
    
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
        pageViewController.delegate = self
        
        guard let firstViewController = displayCategoryItemsViewControllers.first else { return }
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func bind(to viewModel: CharacterSettingViewModel) {
        dispatch(to: viewModel)
        render(viewModel: viewModel)
        onComplete = { [weak viewModel] in viewModel?.tapComplete() }
    }
    
    private func dispatch(to viewModel: CharacterSettingViewModel) {
        viewModel.didLoad()
        
        categoryStackview?.arrangedSubviews.enumerated().forEach { (index, view) in
            view.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                self?.viewModel.tapCategory(at: index)
            }).disposed(by: disposeBag)
        }
    }
    
    private func render(viewModel: CharacterSettingViewModel) {
        viewModel.categories.distinctUntilChanged()
            .subscribe(onNext: { [weak self] categories in
                self?.displayCategoryItemsViewControllers = self?.displayCharacterItemsViewControllerFactory(categories) ?? []
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedCategory.distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] selectedCategory in
                let beforeIndex = self?.selectedCategoryIndex
                let newIndex = selectedCategory.rawValue
                self?.selectedCategoryIndex = newIndex
                self?.scroll(from: beforeIndex ?? .zero, to: newIndex)
                self?.updateCategoryItem(selectedIndex: newIndex)
            }).disposed(by: disposeBag)
        
        viewModel.characterMeta.distinctUntilChanged()
            .subscribe(onNext: { [weak self] characterMeta in
                self?.bodyImageView?.image =    UIImage(named: characterMeta.bodyID)
                self?.eyeImageView?.image =     UIImage(named: characterMeta.eyeID)
                self?.noseImageView?.image =    UIImage(named: characterMeta.noseID)
                self?.mouthImageView?.image =   UIImage(named: characterMeta.mouthID)
                if let hairAccessoryID = characterMeta.hairAccessoryID {
                    self?.hairAccessoryImageView?.image = hairAccessoryID.isNotEmpty ? UIImage(named: hairAccessoryID) : nil
                }
                if let etcAccesstoryID = characterMeta.etcAccesstoryID {
                    self?.etcAccessoryImageView?.image = etcAccesstoryID.isNotEmpty ? UIImage(named: etcAccesstoryID) : nil
                }
                self?.characterImageDidChange()
            })
            .disposed(by: disposeBag)
    }
    
    private func characterImageDidChange() {
        let originalColor = Palette.lightGray2
        let captureColor = UIColor.white
        
        guard let characterFittingView = self.characterFittingView else { return }
        characterFittingView.backgroundColor = captureColor
        
        guard let data = SnapshotServiceImpl.capture(characterFittingView) else { return }
        
        viewModel.updateCharacterData(data)
        characterFittingView.backgroundColor = originalColor
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
        guard let selectedViewController = displayCategoryItemsViewControllers[safe: after] else { return }
        guard selectedViewController !== pageViewController.viewControllers?.first else { return }
        pageViewController.setViewControllers([selectedViewController], direction: before < after ? .forward : .reverse, animated: true, completion: nil)
    }
    
    private let disposeBag = DisposeBag()
    
    private var categories = [ItemCategory]()
    private var selectedCategoryIndex = 0
    private var selectedCategoryLineStart: NSLayoutConstraint?
    private var selectedCategoryLineEnd: NSLayoutConstraint?
    private var displayCategoryItemsViewControllers: [DisplayCharacterItemsViewController] = []
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: [:])
    
    @IBOutlet private weak var characterFittingView: UIView?
    @IBOutlet private weak var bodyImageView: UIImageView?
    @IBOutlet private weak var eyeImageView: UIImageView?
    @IBOutlet private weak var noseImageView: UIImageView?
    @IBOutlet private weak var mouthImageView: UIImageView?
    @IBOutlet private weak var hairAccessoryImageView: UIImageView?
    @IBOutlet private weak var etcAccessoryImageView: UIImageView?
    @IBOutlet private weak var categoryStackview: UIStackView?
    @IBOutlet private var categoryLabels: [UILabel]?
    @IBOutlet private weak var selectedCategoryUnderLine: UIView?
    @IBOutlet private weak var categoryItemFrameView: UIView?
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
extension CharacterSettingView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? DisplayCharacterItemsViewController else { return }
        guard let selectedIndex = displayCategoryItemsViewControllers.firstIndex(of: currentViewController) else { return }
        self.viewModel.tapCategory(at: selectedIndex)
    }
}
