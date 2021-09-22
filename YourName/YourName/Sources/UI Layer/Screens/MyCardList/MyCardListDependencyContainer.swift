//
//  MyCardListDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class MyCardListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        // do something
        // get state of signedInDependencyContainer
    }
    
    func createMyCardListViewController() -> MyCardListViewController {
        let viewModel = createMyCardListViewModel()
        let cardDetailViewControllerFactory: (String) -> CardDetailViewController = { cardID in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createCardDetailViewController()
        }
        return MyCardListViewController(
            viewModel: viewModel,
            cardDetailViewControllerFactory: cardDetailViewControllerFactory
        )
    }
    
    private func createMyCardListViewModel() -> MyCardListViewModel {
        #warning("⚠️ TODO: Mock객체를 추후에 구현 객체로 변경해야합니다") // Booung
        let myCardRepository = MockMyCardRepository()
        myCardRepository.stubedList = Card.dummyList
        return MyCardListViewModel(myCardRepository: myCardRepository)
    }
    
    // Child Dependency Container Factory
    private func createCardDetailDependencyContainer(cardID: String) -> CardDetailDependencyContainer {
        return CardDetailDependencyContainer(cardID: cardID, myCardListDependencyContainer: self)
    }
}