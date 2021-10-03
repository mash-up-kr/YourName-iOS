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
    
    func createImageSourcePickerPageSheetController() -> PageSheetController<ImageSourcePickerView> {
        let view = createImageSourcePickerView()
        return PageSheetController(contentView: view)
    }
    
    private func createImageSourcePickerView() -> ImageSourcePickerView {
        let view = ImageSourcePickerView()
        view.viewModel = createImageSourcePickerViewModel()
        return view
    }
    
    private func createImageSourcePickerViewModel() -> ImageSourcePickerViewModel {
        return ImageSourcePickerViewModel()
    }
    
}
