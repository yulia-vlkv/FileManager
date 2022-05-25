//
//  PasswordViewController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 21.05.2022.
//

import Foundation
import UIKit

class PasswordViewController: UIViewController {
    
    var model = KeyChainModel()
    
    private let defaults = UserDefaults.standard
    private var passwordEntered: String?
    
    var credentials = KeyChainModel.credentials
    public var initialState: State?
    var currentState: State = .enterPassword

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .blue
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.textColor = CustomColors.setColor(style: .dustyTeal)
        textField.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        textField.returnKeyType = UIReturnKeyType.done
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.keyboardType = .decimalPad
        textField.isSecureTextEntry = true
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(updateEnterButtonState), for: .editingChanged)
        textField.toAutoLayout()
        return textField
    } ()
    
    private let enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        button.setTitleColor(CustomColors.setColor(style: .dustyTeal), for: .normal)
        button.setTitleColor(CustomColors.setColor(style: .lightGray), for: .disabled)
        button.tintColor = CustomColors.setColor(style: .dustyTeal)
        button.isEnabled = false
        button.isUserInteractionEnabled = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonIsTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    } ()
    
    private func setButtonTitle(){
        let password = model.retrievePassword(with: credentials)
        if password == nil {
            updateToCreate()
        } else {
            updateToEnter()
        }
    }
    
    private func updateToCreate(){
        enterButton.setTitle(ButtonTitle.createPassword.rawValue, for: .normal)
        navigationItem.title = ButtonTitle.createPassword.rawValue
        currentState = .createPassword
    }
    
    private func updateToConfirm(){
        enterButton.setTitle(ButtonTitle.confirmPassword.rawValue, for: .normal)
        navigationItem.title = ButtonTitle.confirmPassword.rawValue
        currentState = .confirmPassword
    }
    
    private func updateToEnter(){
        enterButton.setTitle(ButtonTitle.enterPassword.rawValue, for: .normal)
        navigationItem.title = ButtonTitle.enterPassword.rawValue
        currentState = .enterPassword
    }
    
    func updateToUpdate(){
        enterButton.setTitle(ButtonTitle.updatePassword.rawValue, for: .normal)
//        model.deletePassword(with: credentials)
        currentState = .updatePassword
    }
    
//    public var initialState: State?
//    var currentState: State = .enterPassword
    
//    private func configureWithState(newState: State){
//        switch (currentState, newState) {
//        case (.enterPassword, .updatePassword):
//            print("update state")
//
//        default:
//            print("incorrect state")
//        }
//    }
    
    private func configureWithState(newState: State) {
        switch newState {
        case .enterPassword:
            updateToEnter()
        case .createPassword:
            updateToCreate()
        case .confirmPassword:
            updateToConfirm()
        case .updatePassword:
            updateToUpdate()
        case .wrongPassword:
            showAlert(title: "Wrong password", message: "Try again", action: "OK")
            passwordTextField.text?.removeAll()
        case .login:
            puchTabBar()
        }
    }
    
    @objc func buttonIsTapped() {
        switch currentState {
        case .enterPassword:
            let currentPassword = model.retrievePassword(with: credentials)
            if currentPassword == passwordTextField.text {
                configureWithState(newState: .login)
            }  else {
                configureWithState(newState: .wrongPassword)
            }
        case .createPassword:
            passwordEntered = passwordTextField.text!
            passwordTextField.text?.removeAll()
            configureWithState(newState: .confirmPassword)
        case .confirmPassword:
            let secondPasswordEntered = passwordTextField.text!
            if passwordEntered == secondPasswordEntered {
                credentials.password = passwordTextField.text!
                model.setPassword(with: credentials)
                configureWithState(newState: .login)
            } else {
                configureWithState(newState: .wrongPassword)
            }
        case .updatePassword:
            credentials.password = passwordTextField.text!
            model.updatePassword(with: credentials)
            self.dismiss(animated: true, completion: nil)
        default:
            showAlert(title: "Error", message: "Something went wrong", action: "OK")
        }

    }
    
    private func puchTabBar(){
        let tabBarVC = TabBarController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    private func showAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func updateEnterButtonState() {
        if let text = passwordTextField.text {
            if text.count < 4 || text.isEmpty {
                self.enterButton.isEnabled = false
                self.enterButton.isUserInteractionEnabled = false
                print(text)
            } else {
                self.enterButton.isEnabled = true
                self.enterButton.isUserInteractionEnabled = true
                print(text)
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = CustomColors.setColor(style: .almostWhite)
        setupViews()
        setupNavigationBar()
        if let initialState = initialState {
            configureWithState(newState: initialState)
        } else {
            let password = model.retrievePassword(with: credentials)
            if password == nil {
                configureWithState(newState: .createPassword)
            } else {
                configureWithState(newState: .enterPassword)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = CustomColors.setColor(style: .dustyTeal)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViews() {
        
        view.addSubview(passwordTextField)
        view.addSubview(enterButton)
        
        let constraints = [
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -baseInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: baseInset / 2),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -baseInset),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private var baseInset: CGFloat { return 66 }
}


extension PasswordViewController {
    enum State {
        case enterPassword
        case createPassword
        case confirmPassword
        case updatePassword
        case wrongPassword
        case login
    }
}

