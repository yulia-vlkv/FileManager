//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 21.05.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
//    var credentials = KeyChainModel.credentials
//    var model = KeyChainModel()
    
//    var completionHandler: ((Int) -> Void)?
//    public var sortSettings: SortType = .ascending
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        button.setTitleColor(CustomColors.setColor(style: .dustyTeal), for: .normal)
        button.tintColor = CustomColors.setColor(style: .dustyTeal)
        button.setTitle("Change password", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonIsTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    } ()
    
    let sortingLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorting"
        label.textAlignment = .center
        label.toAutoLayout()
        return label
    }()
    
    let sortSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["ascend", "descend"])
        segmented.selectedSegmentTintColor = CustomColors.setColor(style: .dustyTeal)
        segmented.backgroundColor = CustomColors.setColor(style: .pastelSandy)
        let selectedSegment = UserDefaults.standard.string(forKey: "sortType")
        if selectedSegment == "descending" {
            segmented.selectedSegmentIndex = 1
        } else {
            segmented.selectedSegmentIndex = 0
        }
        segmented.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        segmented.toAutoLayout()
        return segmented
    }()
    
    
    let sortingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.toAutoLayout()
        return stackView
    }()
    
    let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 35
        stackView.alignment = .fill
        stackView.toAutoLayout()
        return stackView
    }()
    
    @objc private func buttonIsTapped(){
        let passwordVC = PasswordViewController()
        passwordVC.initialState = .updatePassword
        present(passwordVC, animated: true)
        print("tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.setColor(style: .almostWhite)
        setupViews()
    }
    
    private func setupViews(){
        view.addSubview(contentStack)
        
        contentStack.addArrangedSubview(changePasswordButton)
        contentStack.addArrangedSubview(sortingStack)
        sortingStack.addArrangedSubview(sortingLabel)
        sortingStack.addArrangedSubview(sortSegmented)
        
        let constraints = [
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseInset),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -baseInset)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private var baseInset: CGFloat { return 33 }
    
    @objc func segmentedValueChanged(sender: UISegmentedControl){
//        let fileManager = FileManagerViewController()
//        fileManager.sortType = .descending
//        present(passwordVC, animated: true)
        print("tapped")
        switch sender.selectedSegmentIndex {
        case 0:
            KeyChainModel.sortSettings = .ascending
            print(KeyChainModel.sortSettings.rawValue)
//            fileManager.sortType = .ascending
//            sortSettings = .ascending
            print("asc")
        case 1:
            KeyChainModel.sortSettings = .descending
            print(KeyChainModel.sortSettings.rawValue)
//            fileManager.sortType = .descending
//            sortSettings = .descending
            print("dec")
        default:
            print("default")
        }
        UserDefaults.standard.set(KeyChainModel.sortSettings.rawValue, forKey: "sortType")
        print(UserDefaults.standard.string(forKey: "sortType") ?? "error")
    }
    

//    @objc func changepassword(){
//        model.passwordMode = .createPassword
//        let loginVC = LoginViewController(model: model)
//
//        present(loginVC, animated: true)
//    }
//
//    @objc func changeSort(sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            model.sortType = .asc
//        case 1:
//            model.sortType = .dec
//        default :
//            print("default")
//        }
//
//        UserDefaults.standard.set(model.sortType.rawValue, forKey: "sortType")
//    }
}

