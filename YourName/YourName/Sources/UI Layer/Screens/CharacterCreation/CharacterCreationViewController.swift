//
//  CharacterCreationViewController.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import UIKit

final class CharacterCreationViewController: ViewController, Storyboarded {

    var viewModel: CharacterCreationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: CharacterCreationViewModel) {
        
    }
    
    private func render(_ viewModel: CharacterCreationViewModel) {
        
    }

}

