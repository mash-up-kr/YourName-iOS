//
//  NameCardDetailDependencyContainer.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import Foundation

// TODO: 고칠게 너무 많다~ ㅎㅅㅎ 과거의 무지했던 나..
final class NameCardDetailDependencyContainer {
    
    typealias CardType = NameCardDetailViewModel.CardType
    
    private let uniqueCode: UniqueCode
    private let cardType: CardType
    private var cardId: Identifier? = nil
    private var cardBookID: CardBookID?
    
    init(uniqueCode: UniqueCode, myCardListDependencyContainer: MyCardListDependencyContainer) {
        self.uniqueCode = uniqueCode
        self.cardType = .myCard
    }
    
    // card book detail에서 진입
    init(cardId: Identifier, uniqueCode: UniqueCode, cardBookDetailDependencyContainer: CardBookDetailDependencyContainer, cardBookID: CardBookID?) {
        self.uniqueCode = uniqueCode
        self.cardId = cardId
        self.cardBookID = cardBookID
        self.cardType = .friendCard
    }
    
    func createNameCardDetailViewController() -> NameCardDetailViewController {
        let viewController = NameCardDetailViewController.instantiate()
        let viewModel = createNameCardDetailViewModel()
        viewController.viewModel = viewModel
        
        viewController.cardDetailMoreViewFactory = { uniqueCode -> CardDetailMoreViewController in
            let moreViewModel = CardDetailMoreViewModel(uniqueCode: uniqueCode,
                                                        delegate: viewModel)
            let moreView = CardDetailMoreView(viewModel: moreViewModel, parent: viewController)
            let pageSheetController = PageSheetController(contentView: moreView)
            return pageSheetController
        }
        
        viewController.cardEditViewControllerFactory = { uniqueCode -> CardInfoInputViewController in
            let dependencyContainer = CardInfoInputDependencyContainer(uniqueCode: uniqueCode)
            return dependencyContainer.createCardInfoInputViewController()
        }
        return viewController
    }
    
    private func createNameCardDetailViewModel() -> NameCardDetailViewModel {
        let cardRepository = self.createCardRepository()
        let clipboardService = self.createClipboardService()
        
        return NameCardDetailViewModel(cardId: self.cardId,
                                       uniqueCode: uniqueCode,
                                       cardRepository: cardRepository,
                                       myCardRepository: self.createMyCardRepository(),
                                       clipboardService: clipboardService,
                                       questRepository: YourNameQuestRepository(),
                                       cardType: self.cardType,
                                       cardBookID: self.cardBookID ?? "all")
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
    
    private func createClipboardService() -> ClipboardService {
        return YourNameClipboardService()
    }
    
    private func createMyCardRepository() -> MyCardRepository {
        return YourNameMyCardRepository()
    }
}
