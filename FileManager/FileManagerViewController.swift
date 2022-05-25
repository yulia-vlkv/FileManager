//
//  ViewController.swift
//  FileManager
//
//  Created by Iuliia Volkova on 13.05.2022.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    private let fileManager = FileManager.default
//    var model = KeyChainModel()
    
    private lazy var documentsURL = try! fileManager.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                              appropriateFor: nil,
                                                      create: false)
    var directoryContent: [URL] = []
//    var directoryContentToSort: [URL] = []
    
    private let itemsPerRow: CGFloat = 3
    
    private let sectionInserts = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: layout)
    
    let detailsVC = DetailsViewController()
//    let settingVC = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFileManager()
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Images"
        navigationController?.navigationBar.tintColor = CustomColors.setColor(style: .dustyTeal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CustomColors.setColor(style: .pastelSandy)
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
    
//    func sorting() {
//        let directoryContentToSort = directoryContent.enumerated()
//        var currentSortingType = KeyChainModel.sortSettings
//        switch currentSortingType {
//        case .ascending:
//            let sorted = directoryContentToSort.sorted { $0.offset < $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            //            directoryContent = directoryContent.sorted { $0.path < $1.path }
//            print(sortedDirectoryContent)
//            print("ascending")
//            print(currentSortingType)
//        case .descending:
//            let sorted = directoryContentToSort.sorted { $0.offset > $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            print(sortedDirectoryContent)
//            print("descending")
//            print(currentSortingType)
////        default:
////            print ("default")
////        case .none:
////            print ("default")
//        }
//
//        if settingVC.sortSegmented.selectedSegmentIndex == 0 {
//            let sorted = directoryContentToSort.sorted { $0.offset < $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            //            directoryContent = directoryContent.sorted { $0.path < $1.path }
//            print(sortedDirectoryContent)
//            print("ascending")
//            print(sortSettings)
//        } else if settingVC.sortSegmented.selectedSegmentIndex == 1 {
//            let sorted = directoryContentToSort.sorted { $0.offset > $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            print(sortedDirectoryContent)
//            print("descending")
//            print(sortSettings)
//        }
//        else {
//            print ("default")
//        }
//    }

    private func setupCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.toAutoLayout()
        
        collectionView.backgroundColor = CustomColors.setColor(style: .almostWhite)
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
        var currentSortingType = KeyChainModel.sortSettings
        switch currentSortingType {
        case .ascending:
            let directoryContentToSort = directoryContent.enumerated()
            let sorted = directoryContentToSort.sorted { $0.offset < $1.offset }
            let sortedDirectoryContent = sorted.map{$0.element}
            let pictureURL = sortedDirectoryContent[indexPath.item]
            cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
            print("asc")
//            collectionView.reloadData()
            return cell
        case .descending:
            let directoryContentToSort = directoryContent.enumerated()
            let sorted = directoryContentToSort.sorted { $0.offset > $1.offset }
            let sortedDirectoryContent = sorted.map{$0.element}
            let pictureURL = sortedDirectoryContent[indexPath.item]
            cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
            print("des")
//            collectionView.reloadData()
            return cell
        }
//        switch(sortSettings.sortSegmented.selectedSegmentIndex) {
//        case 0:
//            let directoryContentToSort = directoryContent.enumerated()
//            let sorted = directoryContentToSort.sorted { $0.offset < $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            let pictureURL = sortedDirectoryContent[indexPath.item]
//            cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
////            print(sortedDirectoryContent)
//            print("asc")
//            print(sortSettings.sortSegmented.selectedSegmentIndex)
//            return cell
//        case 1:
//            let directoryContentToSort = directoryContent.enumerated()
//            let sorted = directoryContentToSort.sorted { $0.offset > $1.offset }
//            let sortedDirectoryContent = sorted.map{$0.element}
//            collectionView.reloadData()
//            let pictureURL = sortedDirectoryContent[indexPath.item]
//            cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
//            print("des")
//            collectionView.reloadData()
//            return cell
//        default:
//            let pictureURL = directoryContent[indexPath.item]
//            cell.pictureImageView.image = UIImage(contentsOfFile: pictureURL.path)
//            print("default")
//            collectionView.reloadData()
//            return cell
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
