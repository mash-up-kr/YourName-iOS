//
//  ObservableType+.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import RxSwift
import RxRelay

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func catchErrorToAlert(
        _ handler: PublishRelay<AlertViewController>,
        retryHandler: PublishRelay<Void>? = nil
    ) -> Observable<Element> {
        guard let errorImage = UIImage(named: "img_modal_error") else { return Observable.empty() }

        let alertController = AlertViewController.instantiate()
        let alertItem = AlertItem(
            title: "Error가 발생했츄!",
            messages: "서비스 처리 과정에서 에러가 발생했츄..",
            image: errorImage,
            emphasisAction: .init(title: "재시도", action: {
                alertController.dismiss()
                retryHandler?.accept(())
            }),
            defaultAction: .init(title: "취소", action: {})
        )
        
        alertController.configure(item: alertItem)
        handler.accept(alertController)
        
        return .empty()
    }
}
