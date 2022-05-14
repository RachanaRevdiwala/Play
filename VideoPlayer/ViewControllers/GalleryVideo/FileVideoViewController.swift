//
//  FileVideoViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit
import Photos




class FileVideoViewController: UIViewController {
    
    @IBOutlet var topNaviView : UIView!
    @IBOutlet var addButton : UIButton!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var sortButton : UIButton!

    
    @IBOutlet var collectionView : UICollectionView!
    
    @IBOutlet var infoDialogView : UIView!
    @IBOutlet var descLabel : UILabel!
    @IBOutlet var moreButton : UIButton!
        
    var videoDetailArray = [Videofile]()
    var selectedVideoCell = [Int]()
    let sortlistview = Bundle.main.loadNibNamed("SortByView", owner: nil, options: nil)![0] as? SortByView
    


    // MARK: -
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.setUpUI()
        self.setUpCollectionview()
        self.setNotificationtObserver()
        
        self.GetVideoDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setUpUI(){
        
        self.view.backgroundColor = .background()
        topNaviView.setTopNavigation()
        
        addButton.tintColor = .themecolor()
        editButton.tintColor = .themecolor()
        sortButton.tintColor = .themecolor()
        
        descLabel.text = StringManager.syncText
        moreButton.layer.cornerRadius = 3
        moreButton.backgroundColor = UIColor.themecolor().withAlphaComponent(0.90)
    }
    
    private func setNotificationtObserver() {

        NotificationCenter.default.addObserver(self, selector: #selector(GetVideoDetails), name: .refreshLocalScreen, object: nil)
    }
    

    @objc func GetVideoDetails() {
        infoDialogView.isHidden = false
        collectionView.isHidden = true
    }
    
    
    @IBAction func addVideos() {
        let controller = UIDocumentPickerViewController(documentTypes: ["public.movie","public.video","public.audiovisual-content","public.srt"], in: .import)
        controller.delegate = self
        controller.allowsMultipleSelection = true
        self.present(controller,animated: true,completion: nil)
    }
    
    
    @IBAction func learnMoreClick(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SyncViewController") as! SyncViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    

    
    
    @IBAction func editbuttonClick() {
        
        guard videoDetailArray.count != 0 else {
            return
        }
        
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
            
            self.tabBarController?.tabBar.isHidden = isEditVideoCell
            addButton.isHidden = isEditVideoCell
            sortButton.isHidden = isEditVideoCell
            
            collectionView.reloadData()
        }
    }
    

    private func openVideoPlayer(_ currentVideoIndex:Int) {
         
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VLCVideoPlayerVC") as? VLCVideoPlayerVC
         vc?.videoUrlArray = videoDetailArray
         vc?.indexOfURL = currentVideoIndex
         self.navigationController?.pushViewController(vc!, animated: true)
     }
}



extension FileVideoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    private func setUpCollectionview(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.frame.origin.y = self.topNaviView.frame.height
        self.collectionView.frame.size.height = screenSize.height - self.topNaviView.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoDetailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inline_cell:CGFloat = isPad ? 4 : 2
        let cellwidth = (self.view.frame.width - 43)/inline_cell
        let cellheight = (cellwidth*60/100) + 55
        return CGSize(width: cellwidth, height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}

extension FileVideoViewController: UIDocumentPickerDelegate {
    
        
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}




extension FileVideoViewController: SortByViewDelegate {
        
    @IBAction func sortingButtonPressed() {
        
        sortlistview?.setupView()
        sortlistview?.delegate = self
        sortlistview?.showView(sender: self.view)
        self.tabBarController?.tabBar.alpha = 0
    }
    
    func sortByViewHide() {
        self.tabBarController?.tabBar.alpha = 1
    }
    
    func sortByViewChangeSorting() {
                
        guard videoDetailArray.count != 0 else {
            return
        }
        
        ArraySortingManager.sortedList(sender: videoDetailArray) { sortArray in
            self.videoDetailArray = sortArray
            self.collectionView.reloadData()
        }
    }
    
}
