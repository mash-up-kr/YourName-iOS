//
//  QuestViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestViewController: ViewController, Storyboarded {
    
    var viewModel: QuestViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questsTableView?.dataSource = self
        self.bind()
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: QuestViewModel) {
        self.viewModel.didLoad()
        
        self.backButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapClose()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: QuestViewModel) {
        viewModel.isLoading.distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.quests.distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.quests = $0
                self?.questsTableView?.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    private let disposeBag = DisposeBag()
    
    private var quests: [Quest] = []
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var questProgressView: UIProgressView?
    @IBOutlet private weak var questsTableView: UITableView?
}
extension QuestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(QuestTableViewCell.self, for: indexPath) else { return .init() }
        guard let quest = self.quests[safe: indexPath.row] else { return cell }
        cell.configure(with: quest)
        return cell
    }
    
}
