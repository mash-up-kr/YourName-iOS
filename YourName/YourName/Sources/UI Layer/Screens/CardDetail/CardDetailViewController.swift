//
//  CardDetailViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit
import Toast_Swift


final class CardDetailViewController: ViewController, Storyboarded {
    

    @IBOutlet weak var bubbleBottom: UIView!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var frontButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var speechBubble: UIView!
    @IBAction func settingButton(_ sender: Any) {
        //붙여야 되는 부분

    }
    
    @IBOutlet weak var mySkillProgressView1: MySkillProgressView!
    @IBOutlet weak var mySkillProgressView2: MySkillProgressView!
    @IBOutlet weak var mySkillProgressView3: MySkillProgressView!
    
    @IBOutlet weak var cardDetailFrontView: UIStackView!
    
    @IBOutlet weak var cardDetailBackView: UIStackView!
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    @IBAction private func frontButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            
            self.underlineCenterX?.isActive = false
            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
            self.underlineCenterX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    var underlineCenterX: NSLayoutConstraint?
    
    @IBAction private func backButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            
            self.underlineCenterX?.isActive = false
            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.backButton.centerXAnchor)
            self.underlineCenterX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.underlineCenterX?.isActive = false
        self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
        self.underlineCenterX?.isActive = true
        bubbleBottom.transform = CGAffineTransform(rotationAngle: 45/360 * Double.pi)
        addGesture()
    }
    
    
    func addGesture() {
        speechBubble.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGetstureDetected))
         
         speechBubble.addGestureRecognizer(tapGesture)
         
     }

    @objc func tapGetstureDetected() {
        print("Touch/Tap Gesture detected!!")
        self.navigationController?.view.showToast(ToastView(text: "코드명이 복사되었츄!"), position: .top)
    }
    
    var viewModel: CardDetailViewModel!
    
    @IBOutlet private weak var mainView: UIView!

}

