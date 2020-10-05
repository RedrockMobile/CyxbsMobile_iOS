//
//  LoginViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/10/5.
//  Copyright © 2020 Redrock. All rights reserved.
//

import UIKit

private enum LoginState {
    case lackAccount
    case lackPassword
    case lackAccountAndPassword
    case didNotAcceptProtocol
    case OK
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var stuNumTextField: UITextField!
    
    @IBOutlet private weak var idNumTextField: UITextField!
    
    @IBOutlet private weak var protocolCheckButton: UIButton!
    
    @IBOutlet private weak var loginTitleLabel: UILabel!
    
    @IBOutlet private weak var loginSubTitleLabel: UILabel!

    private weak var loginHud: MBProgressHUD!
    
    private var loginCheck: LoginState {
        
        if idNumTextField.text == nil || idNumTextField.text == "" {
            return .lackPassword
        }
        else if stuNumTextField.text == nil || idNumTextField.text == "" {
            return .lackAccount
        }
        else if (idNumTextField.text == nil || idNumTextField.text == "") && (stuNumTextField.text == nil || idNumTextField.text == "") {
            return .lackAccountAndPassword
        }
        else if (!protocolCheckButton.isSelected) {
            return .didNotAcceptProtocol
        }
        else {
            return .OK
        }
        
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction private func loginButtonClicked(_ sender: UIButton) {
        switch loginCheck {
            case .OK:
                break
            
            case .lackAccount:
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = "请输入账号"
                hud?.hide(true, afterDelay: 1)
                
            case .lackPassword:
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = "请输入密码"
                hud?.hide(true, afterDelay: 1)
                
            case .lackAccountAndPassword:
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = "请输入账号和密码"
                hud?.hide(true, afterDelay: 1)
                
            case .didNotAcceptProtocol:
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = "请阅读并同意《掌上重邮用户协议》"
                hud?.hide(true, afterDelay: 1)
        }
    }
    
    @IBAction private func protocolButtonClicked(_ sender: UIButton) {

    }
    
    @IBAction private func protocolCheckButtonClicked(_ sender: UIButton) {
        
    }
    
}
