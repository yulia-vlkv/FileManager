//
//  DetailsViewController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 13.05.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var deleteHandler: (() -> Void)?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "almostWhite")
        view.toAutoLayout()
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.layer.cornerRadius = 15
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private var sideInset: CGFloat { return 20 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: "almostWhite")
        self.navigationItem.title = "Details"
        setNavigationBar()
        setupViews()
    }
    
    private func setNavigationBar(){
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "dustyTeal")
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "pastelSandy")
        self.navigationItem.title = "Details"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(showAlert))
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func showAlert() {
        let alertController = UIAlertController(title: "Delete Image", message: "You Sure?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let confirm = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction) in
            self.deleteImage()
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func deleteImage() {
        self.deleteHandler?()
        cancel()
    }
    
    private func setupViews() {
        
        view.addSubview(contentView)
        contentView.addSubview(imageView)

        let constraints = [
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
}
