//
//  AddCardBookDependencyContainer.swift
//  MEETU
//
//  Created by Seori on 2022/02/08.
//

import Foundation
import UIKit

final class AddCardBookDependencyContainer {
    init() {
        
    }
    
    func createAddCardBookViewController() -> UIViewController {
        let viewController = AddCardBookViewController.instantiate()
        let viewModel = AddCardBookViewModel()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
