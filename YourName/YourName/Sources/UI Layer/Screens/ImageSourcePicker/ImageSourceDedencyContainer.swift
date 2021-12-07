//
//  ImageSourceDedencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class ImageSourceTypePickerDependencyContainer {
    
    let imageSourceResponder: ImageSourcePickerResponder
    
    init(cardCreationDependencyContainer: CardInfoInputDependencyContainer) {
        self.imageSourceResponder = cardCreationDependencyContainer.viewModel
    }
    
    func createImageSourcePickerViewController() -> ImageSourceTypePickerViewController {
        let view = createImageSourcePickerView()
        return ImageSourceTypePickerViewController(contentView: view)
    }
    
    private func createImageSourcePickerView() -> ImageSourceTypePickerView {
        let view = ImageSourceTypePickerView()
        view.viewModel = createImageSourcePickerViewModel()
        return view
    }
    
    private func createImageSourcePickerViewModel() -> ImageSourceTypePickerViewModel {
        return ImageSourceTypePickerViewModel(imageSourceResponder: imageSourceResponder)
    }
    
}
