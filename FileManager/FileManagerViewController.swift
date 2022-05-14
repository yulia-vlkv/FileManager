//
//  ViewController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 13.05.2022.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    private let fileManager = FileManager.default
    
    private lazy var documentsURL = try! fileManager.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                              appropriateFor: nil,
                                                      create: false)
    var directoryContent: [URL] = []
    
    private let itemsPerRow: CGFloat = 3
    
    private let sectionInserts = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: layout)
    
    let detailsVC = DetailsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFileManager()
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Images"
        navigationController?.navigationBar.tintColor = UIColor(named: "dustyTeal")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "pastelSandy")
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setupFileManager() {
        self.directoryContent = try! fileManager.contentsOfDirectory(at: documentsURL,
                                             includingPropertiesForKeys: nil,
                                                                options: [])
    }

    private func setupCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.toAutoLayout()
        
        collectionView.backgroundColor = UIColor(named: "almostWhite")
        collectionView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

extension FileManagerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directoryContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID,
                                                      for: indexPath) as! CollectionViewCell
        
        let pictureURL = directoryContent[indexPath.item]
        cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let widthPerItem = ( view.frame.width - paddingSpace ) / itemsPerRow
        let height = widthPerItem
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pictureURL = directoryContent[indexPath.item]
        let detailsVC = DetailsViewController()
        detailsVC.imageView.image = UIImage(contentsOfFile: pictureURL.path)
        let navigationController = UINavigationController(rootViewController: detailsVC)
        self.present(navigationController, animated: true, completion: nil)
        detailsVC.deleteHandler = {
            let imagePath = self.directoryContent[indexPath.item]
            try! self.fileManager.removeItem(at: imagePath)
            self.directoryContent.remove(at: indexPath.item)
            self.collectionView.reloadData()
        }
    }
}

extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let data = image.pngData()
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        let imagePath = documentsURL.appendingPathComponent("Image:\(imageName)")
        
        fileManager.createFile(atPath: imagePath.path,
                             contents: data,
                           attributes: nil)
        directoryContent.append(imagePath)
        collectionView.reloadData()
        dismiss(animated: true)
    }
}
