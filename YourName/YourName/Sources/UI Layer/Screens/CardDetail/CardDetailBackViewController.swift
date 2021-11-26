//
//  CardDetailBackViewController.swift
//  YourName
//
//  Created by KimKyungHoon on 2021/11/13.
//

import UIKit

final class CardDetailBackViewController: ViewController, Storyboarded {
 
    var cellIdentifier = "TMICollectionViewCell"
    var numberOfCell = 6

    @IBOutlet weak var contactDetailStackView: UIStackView!
    
    @IBOutlet weak var personalityDetailStackView: UIStackView!
    
    @IBOutlet weak var TMICollectionView: UICollectionView!
    
    @IBOutlet weak var moreAboutMeDetailStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactDetailStackView.layoutMargins = UIEdgeInsets(top: 21, left: 14, bottom: 18, right: 17)
        personalityDetailStackView.layoutMargins = UIEdgeInsets(top: 21, left: 14, bottom: 18, right: 17)
        
    
        moreAboutMeDetailStackView.layoutMargins = UIEdgeInsets(top: 21, left: 14, bottom: 18, right: 17)
        TMICollectionView.dataSource = self
        TMICollectionView.delegate = self
    }
    
}

extension CardDetailBackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        return cell
    }

}

extension CardDetailBackViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numberOfCell += 1
        collectionView.reloadData()
    }
}


// 전체 Stack뷰하고 헤더 포함을 뷰로 하고 그 속의 내용 내부를 스택뷰로 하면 된다.. 그 속에 이제 컬렉션뷰나 테이블뷰 같은걸로 만들면 된다.
