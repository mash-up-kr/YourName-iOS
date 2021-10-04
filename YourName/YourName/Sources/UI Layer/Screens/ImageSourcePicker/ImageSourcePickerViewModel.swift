//
//  ImageSourcePickerViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

protocol ImageSourcePickerResponder: AnyObject {
    func selectPhoto()
    func selectCharacter()
}

final class ImageSourceTypePickerViewModel {
    
    init(imageSourceResponder: ImageSourcePickerResponder) {
        self.imageSourceResponder = imageSourceResponder
    }
    
    func tapPhotoButton() {
        imageSourceResponder.selectPhoto()
    }
    
    func tapCreateCharacterButton() {
        imageSourceResponder.selectCharacter()
    }
    
    private let imageSourceResponder: ImageSourcePickerResponder
}

