//
//  GalleryVideoViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos

public protocol AlbumViewDelegate: NSObjectProtocol {
    func albumview(_ albumName:String, newVideoCount count:String)
}


class GalleryVideoViewController: UIViewController
{
    @IBOutlet var topNaviView : UIView!
    @IBOutlet var backButton : UIButton!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var collectionView : UICollectionView!
    
    
    weak var delegate: AlbumViewDelegate!

    var videoPhAsset = PHFetchResult<PHAsset>()
    var albumName : String  = ""
    
    var userselected_videoindex = 0
    var selectedVideoCell = [Int]()
    var bottomMenu = Bundle.main.loadNibNamed("BottomMenuView", owner: nil, options: nil)![0] as! BottomMenuView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background()
        topNaviView.setTopNavigation()
        collectionView.frame.origin.y = topNaviView.frame.height
        backButton.tintColor = .themecolor()

        //
        editButton.tintColor = .themecolor()
        editButton.setTitleColor(.themecolor(), for: .normal)

        setBottomMenuView()
        self.setUpCollectionview()
        
        self.perform(#selector(GetvideoFromGallery), with: self, afterDelay: 0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    
    @objc func GetvideoFromGallery() {
        
        AssestManager().fetchVideoPHFetchResult(albumName: albumName) { fetchResult in
            guard fetchResult != nil else {
                return
            }
            
            self.videoPhAsset = fetchResult!
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func btnBackPressed (_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    
    @IBAction func editbuttonClick() {
        isEditVideoCell = !isEditVideoCell
    }
    
    internal var isEditVideoCell = false {
        didSet {
            
            if isEditVideoCell {
                
                editButton.setTitle("Done", for: .normal)
                editButton.setImage(nil, for: .normal)
            } else {
                
                editButton.setTitle(nil, for: .normal)
                editButton.setImage(UIImage(named: "menu_edit"), for: .normal)
                selectedVideoCell.removeAll()
            }
            
            bottomMenu.isHidden = !isEditVideoCell
            backButton.isHidden = isEditVideoCell
            
            collectionView.reloadData()
        }
    }
    
    
    private func openVideoPlayer() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VLCVideoPlayerVC") as? VLCVideoPlayerVC
        vc?.videoAssetArray = videoPhAsset
        vc?.indexOfURL = userselected_videoindex
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension GalleryVideoViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setUpCollectionview(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: CollectionViewCellIdentifiers.galleryVideoCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIdentifiers.galleryVideoCollectionViewCell.rawValue)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoPhAsset.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inline_cell:CGFloat = isPad ? 4 : 2
        let cellwidth = (self.view.frame.width - 43)/inline_cell
        let cellheight = (cellwidth*60/100) + 40
        return CGSize(width: cellwidth, height: cellheight)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 60, right: 10)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.galleryVideoCollectionViewCell.rawValue, for: indexPath) as? GalleryVideoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.asset = videoPhAsset[indexPath.row]
        cell.reloadContents()
        cell.thumbImageView.layer.cornerRadius = 2
        
        //
        cell.selectedView.isHidden = !isEditVideoCell
        cell.isSelectedVideo(selectedVideoCell.contains(indexPath.row))
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // open video player
        guard isEditVideoCell else {
            
            userselected_videoindex = indexPath.row
            openVideoPlayer()
            return
        }
        
        //
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryVideoCollectionViewCell
        if selectedVideoCell.contains(indexPath.row) {
            selectedVideoCell.remove(at: selectedVideoCell.firstIndex(of: indexPath.row)!)
            cell.isSelectedVideo(false)
        } else {
            selectedVideoCell.append(indexPath.row)
            cell.isSelectedVideo(true)
        }
    }
    

}


extension GalleryVideoViewController:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
