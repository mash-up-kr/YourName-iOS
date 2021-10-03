//
//  ImageSourceDedencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class ImageSourceDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createImageSourcePickerViewController() -> PageSheetController<ImageSourcePickerView> {
        let view = ImageSourcePickerView()
        view.viewModel = ImageSourcePickerViewModel()
        return PageSheetController(title: "대표 이미지 추가하기", contentView: view)
    }
}
