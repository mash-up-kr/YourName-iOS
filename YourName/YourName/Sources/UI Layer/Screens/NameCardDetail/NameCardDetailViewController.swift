//
//  NameCardDetailViewController.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

final class NameCardDetailViewController: ViewController {
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var moreButton: UIButton?
    
    @IBOutlet private weak var backCardButton: UIButton?
    @IBOutlet private weak var frontCardButton: UIButton?
    @IBOutlet private weak var underLineView: UIView?
    
    @IBOutlet private weak var frontCardDetailView: FrontCardDetailView?
    @IBOutlet private weak var backCardDetailView: BarkCardDetailView?
}
