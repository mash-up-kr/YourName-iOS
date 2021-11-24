//
//  QuestViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit

final class QuestViewController: ViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questsTableView?.dataSource = self
    }
    
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var questProgressView: UIProgressView?
    @IBOutlet private weak var questsTableView: UITableView?
}
extension QuestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(QuestTableViewCell.self, for: indexPath) else { return .init() }
        return cell
    }
    
}
