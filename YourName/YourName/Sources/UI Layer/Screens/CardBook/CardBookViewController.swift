//
//  CardBookViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class CardBookViewController: ViewController, Storyboarded {
    @IBOutlet private weak var cardBookTitleLabel: UILabel!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var cardBookCollectionView: UICollectionView!

    
    var dummyDataNumber = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureCollectionView() {
        cardBookCollectionView.register(UINib(nibName: "CardBookEmptyCollectionViewCell",
                                              bundle: Bundle(path: "CardBookEmptyCollectionViewCell")),
                                        forCellWithReuseIdentifier: "CardBookEmptyCollectionViewCell")
        
    }
}

extension CardBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyDataNumber
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(CardBookEmptyCollectionViewCell.self, for: indexPath)
        else { return .init() }
        
        return cell
    }
}
extension CardBookViewController: UICollectionViewDelegate {
}
extension CardBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width 154 height 241
        let width = UIScreen.main.bounds.width - (24 * 2) - 19
        return CGSize(width: width / 2, height: (241 * (width / 2)) / 154)
    }
}
