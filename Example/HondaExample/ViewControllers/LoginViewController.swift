//  FCALoginViewController.swift
//  FCAExample
//
//  Created by Selma Suvalija on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.

import UIKit

class FCALoginViewController: UIViewController {
    
    // - View
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showMainScreen", sender: self)
    }
}


fileprivate let lightGray =   UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
fileprivate let primaryColor = UIColor(red: 226.0/255.0, green: 61.0/255.0, blue: 15.0/255.0, alpha: 1.00)
fileprivate let highlightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)

// MARK: - Helper
extension FCALoginViewController {
    private func setupUI() {
        self.username.textColor = UIColor.white
        self.username.attributedPlaceholder = NSAttributedString(string: "enter_email".localized(), attributes: [NSAttributedString.Key.foregroundColor : highlightColor])
        self.username.addBottomBorderWithColor(color: lightGray, width: 1.0)
        
        self.password.textColor = UIColor.white
        self.password.attributedPlaceholder = NSAttributedString(string: "enter_password".localized(), attributes: [NSAttributedString.Key.foregroundColor : highlightColor])
        self.password.addBottomBorderWithColor(color: lightGray, width: 1.0)
        
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.layer.borderColor = highlightColor.cgColor
        self.loginBtn.titleLabel?.textColor = highlightColor
        self.loginBtn.layer.borderWidth = 1.0
        
        self.username.text = "test@example.com"
        self.password.text = "Testing123+-"
    }
}
