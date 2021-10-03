//
//  ImageSourceDedencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class ImageSourceTypePickerDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createImageSourcePickerPageSheetController() -> PageSheetController<ImageSourceTypePickerView> {
        let view = createImageSourcePickerView()
        return PageSheetController(contentView: view)
    }
    
    private func createImageSourcePickerView() -> ImageSourceTypePickerView {
        let view = ImageSourceTypePickerView()
        view.viewModel = createImageSourcePickerViewModel()
        return view
    }
    
    private func createImageSourcePickerViewModel() -> ImageSourceTypePickerViewModel {
        return ImageSourceTypePickerViewModel()
    }
    
}
