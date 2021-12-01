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


final class CardBookListViewController: UIViewController, Storyboarded {

    var viewModel: CardBookListViewModel!
    
    var addFriendFactory: (() -> AddFriendCardViewController)!
    var addCardBookFactory: (() -> UIViewController)!
    var cardBookDetailFactory: ((CardBookID?) -> UIViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: CardBookListViewModel) {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: CardBookListViewModel) {
        self.viewModel.didLoad()
        
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
            
        case .cardBookDetail(let cardBookID):
            return self.cardBookDetailFactory(cardBookID)
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
        return cardBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(CardBookCoverTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        guard let cardBook = self.cardBooks[safe: indexPath.row] else { return cell }
        
        cell.configure(with: cardBook)
        return cell
    }
}

extension CardBookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel.selectCardBook(at: indexPath)
    }

}
