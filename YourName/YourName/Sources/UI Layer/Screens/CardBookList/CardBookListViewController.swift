//
//  CardBookViewController.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import RxCocoa
import RxSwift
import UIKit

enum CardBookSection: Int, CaseIterable {
    case all
    case custom
    case empty
}


final class CardBookListViewController: ViewController, Storyboarded {

    var viewModel: CardBookListViewModel!
    
    var addFriendFactory: (() -> AddFriendCardViewController)!
    var addCardBookFactory: (() -> UIViewController)!
    var cardBookDetailFactory: ((CardBookID?, String?) -> UIViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: CardBookListViewModel) {
        dispatch(to: viewModel)
        render(viewModel)
        
        Observable.merge(NotificationCenter.default.rx.notification(.addFriendCard),
                         NotificationCenter.default.rx.notification(.friendCardDidDelete))
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didLoad()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func dispatch(to viewModel: CardBookListViewModel) {
        self.viewModel.didLoad()
        
        NotificationCenter.default.rx.notification(.cardBookDidChange)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.refreshCardBooks()
            })
            .disposed(by: self.disposeBag)
        
        self.addFriendButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.tapAddFriend()
        }).disposed(by: self.disposeBag)
        
        self.addCardBookButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.tapAddCardBook()
        }).disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: CardBookListViewModel) {
        viewModel.cardBooks.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cardBooks in
                self?.cardBooks = cardBooks
                self?.cardBookTableView?.reloadData()
            }).disposed(by: self.disposeBag)
        
        viewModel.isLoading.bind(to: self.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] navigation in
                self?.navigate(navigation)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: CardBookListNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: CardBookListDestination) -> UIViewController {
        switch next {
        case .addFriend:
            return self.addFriendFactory()
            
        case .addCardBook:
            return self.addCardBookFactory()
            
        case .cardBookDetail(let cardBookID, let cardBookTitle):
            return self.cardBookDetailFactory(cardBookID, cardBookTitle)
        }
    }
    
    private func setupUI() {
        self.cardBookTableView?.delegate    = self
        self.cardBookTableView?.dataSource  = self
    }
    
    private let disposeBag = DisposeBag()
    
    private var cardBooks: [CardBook] = []
    
    @IBOutlet private weak var addFriendButton: UIButton?
    @IBOutlet private weak var addCardBookButton: UIButton?
    @IBOutlet private weak var cardBookTableView: UITableView?
    
}

extension CardBookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardBooks.isEmpty ? 1 : self.cardBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cardBooks.isEmpty ? self.emptyCell(at: indexPath) : self.cardBookCell(at: indexPath)
    }
    
    private func cardBookCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.cardBookTableView?.dequeueReusableCell(CardBookCoverTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        guard let cardBook = self.cardBooks[safe: indexPath.row] else { return cell }
        
        cell.configure(with: cardBook)
        return cell
    }
    
    private func emptyCell(at indexPath: IndexPath) -> UITableViewCell {
        return self.cardBookTableView?.dequeueReusableCell(withIdentifier: "CardBookEmptyTableViewCell", for: indexPath) ?? UITableViewCell()
    }
}

extension CardBookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel.selectCardBook(at: indexPath)
    }

}
