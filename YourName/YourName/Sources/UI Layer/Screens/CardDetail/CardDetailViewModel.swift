////
////  CardDetailViewModel.swift
////  YourName
////
////  Created by Booung on 2021/09/21.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//enum CardDetailDestination: Equatable {
//    case cardDetailMore(uniqueCode: UniqueCode)
//    case cardEdit(uniqueCode: UniqueCode)
//}
//
//typealias CardDetailNavigation = Navigation<CardDetailDestination>
//
//final class CardDetailViewModel {
//
//    let isLoading = PublishRelay<Bool>()
//    let navigation = PublishRelay<CardDetailNavigation>()
//    let navigationPop = PublishRelay<Void>()
//    let alertController = PublishRelay<AlertViewController>()
//    private let disposeBag = DisposeBag()
//    private let cardID: Identifier
//    private let myCardRepository: MyCardRepository!
//
//    // MARK: - LifeCycle
//    init(cardID: Identifier,
//         repository: MyCardRepository) {
//        self.cardID = cardID
//        self.myCardRepository = repository
//    }
//
//    deinit {
//        print(" π \(String(describing: self)) deinit")
//    }
//
//    // MARK: - Methods
//
//    func didTapMore() {
//        navigation.accept(.show(.cardDetailMore(uniqueCode: self.cardID)))
//    }
//}
//
//// MARK: - CardDetailMore delegate
//extension CardDetailViewModel: CardDetailMoreViewDelegate {
//    func didTapRemoveCard(uniqueCode: Identifier) {
//
//        let alertController = AlertViewController.instantiate()
//        let deleteAction = { [weak self] in
//            guard let self = self else { return }
//            alertController.dismiss(animated: true)
//            self.removeCard(id: uniqueCode)
//        }
//        let deleteCancelAction = {
//            alertController.dismiss(animated: true)
//        }
//        alertController.configure(item: AlertItem(title: "μ λ§ μ­μ νμκ² μΈ?",
//                                                  messages: "μ­μ ν λ―ΈμΈμ λκ°μ λ³΅κ΅¬ν  μ μμ΄μ.",
//                                                  image: UIImage(named: "meetu_delete")!,
//                                                  emphasisAction: .init(title: "μ­μ νκΈ°", action: deleteAction),
//                                                  defaultAction: .init(title: "μ­μ  μν λμ", action: deleteCancelAction)))
//        self.alertController.accept(alertController)
//    }
//
//    func didTapEditCard(uniqueCode: Identifier) {
//        self.navigation.accept(.push(.cardEdit(uniqueCode: uniqueCode)))
//    }
//
//    func didTapSaveImage() {
//
//    }
//
//    private func removeCard(id: Identifier) {
//        self.isLoading.accept(true)
//        self.myCardRepository.removeMyCard(uniqueCode: id)
//            .do { [weak self] in
//                self?.isLoading.accept(false)
//            }
//            .catchError { error in
//                print(error)
//                return .empty()
//            }
//            .mapToVoid()
//            .bind(onNext: { [weak self] in
//                NotificationCenter.default.post(name: .myCardDidDelete, object: nil)
//                self?.navigationPop.accept(())
//            })
//            .disposed(by: self.disposeBag)
//    }
//}
