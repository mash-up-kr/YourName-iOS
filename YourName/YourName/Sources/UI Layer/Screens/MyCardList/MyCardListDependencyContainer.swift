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
        return MyCardListViewController(viewModel: viewModel)
    }
    
    private func createMyCardListViewModel() -> MyCardListViewModel {
        #warning("⚠️ TODO: Mock객체를 추후에 구현 객체로 변경해야합니다") // Booung
        let myCardRepository = MockMyCardRepository()
        return MyCardListViewModel(myCardRepository: myCardRepository)
    }
    
    // Child Dependency Container Factory
    private func createCardDetailDependencyContainer() -> CardDetailDependencyContainer {
        return CardDetailDependencyContainer(myCardListDependencyContainer: self)
    }
}
