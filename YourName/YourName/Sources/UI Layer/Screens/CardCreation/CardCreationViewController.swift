//
//  CreateCardViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

final class CardCreationViewController: ViewController, Storyboarded {

    var viewModel: CardCreationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        guard let viewModel = self.viewModel else { return }
        
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: CardCreationViewModel) {}
    
    private func render(_ viewModel: CardCreationViewModel) {}
    
    @IBOutlet private weak var profileClearButton: UIButton?
    @IBOutlet private weak var profilePlaceholderView: UIView?
    @IBOutlet private weak var backgroundSettingButton: UIButton?
    @IBOutlet private weak var nameField: UITextField?
    @IBOutlet private weak var roleField: UITextField?
    @IBOutlet private weak var mySkillSettingButton: UIButton?
    @IBOutlet private weak var personalityTitleField: UITextField?
    @IBOutlet private weak var personalityKeywordField: UITextField?
    @IBOutlet private weak var myTMISettingButton: UIButton?
    @IBOutlet private weak var aboutMeTextView: UITextView?
    @IBOutlet private weak var completeButton: UIButton?
}
