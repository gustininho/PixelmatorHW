//
//  PhotosCollectionViewController.swift
//  PixelmatorHW
//
//  Created by Gustas Dersonas on 2022-01-21.
//

import Foundation
import UIKit
import Photos

class PhotosCollectionViewContoller: UICollectionViewController, PHPhotoLibraryChangeObserver {
    private var images = [PHAsset]()
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLayout()
        loadPictures()
        PHPhotoLibrary.shared().register(self)
    }
    
    private func setLayout () {
        layout.itemSize = CGSize(width: (view.frame.width/3)-3, height: (view.frame.width/3)-3)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        images = []
        loadPictures()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in

            cell.photoImageView.image = image
        }
        
        if (PHAssetResource.assetResources(for: asset).contains(where: { $0.type == .adjustmentData })) {
            showModified(cell: cell)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                identifier: nil,
                discoverabilityTitle: nil,
                state: .off) { _ in
              //  PHAssetChangeRequest.deleteAssets( self.images[indexPath.row])
                
            }
            
            return UIMenu(
                title: "Actions",
                image: nil,
                identifier: nil,
                options: UIMenu.Options.displayInline,
                children: [delete]
            )
        }
        return config
    }
    
    private func showModified(cell: PhotoCollectionViewCell) {
        let overlayView = UIImageView()
        overlayView.image = UIImage(named: "edit-icon")
        
        overlayView.frame = CGRect(x: 0 , y: 0, width: cell.photoImageView.bounds.width * 0.2, height: cell.photoImageView.bounds.height * 0.2)
        cell.photoImageView.addSubview(overlayView)
    }
    
    private func loadPictures() {
        PHPhotoLibrary.requestAuthorization{ [weak self] status in
            
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (pic,_,_) in
                    self?.images.append(pic)
                }
            }
            
            DispatchQueue.main.async {
                self?.images.reverse()
                self?.collectionView.reloadData()
            }
        }
    }
}
