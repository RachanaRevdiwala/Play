//
//  GalleryFolderViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//



import UIKit
import Photos


class GalleryFolderViewController: UIViewController {
    
    @IBOutlet private var topNaviView : UIView!
    @IBOutlet private var tableViewGallery : UITableView!
    @IBOutlet private var permissionLabel: UILabel!
    
    var folderlist = [FolderDetail]()
    var allVideoCount : Int = 0

        
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpTableview()
        self.setNotificationtObserver()
    }

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    
    private func setUpUI(){
        
        self.view.backgroundColor = .background()
        self.tabBarController?.tabBar.tintColor = .themecolor()

        self.topNaviView.setTopNavigation()
        self.tableViewGallery.frame.origin.y = topNaviView.frame.height
        self.tableViewGallery.isHidden = true
        lunchAd()

    }
    
    private func setNotificationtObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(lockScreenAfterFullScreen(_:)), name: .didCloseLockScreen, object: nil)

    }
    
    
    
    @objc private func CameraPermissionCheck() {
        
        AssestManager().checkPhotosPermission { (authorized, limited) in
            DispatchQueue.main.async { [self] in

                if authorized || limited {
                    RefershFolderScreen()
                } else {
                    loaderManager.stop()
                }
                
                tableViewGallery.isHidden = !authorized
            }
        }
    }

    

    
    
    @objc private func RefershFolderScreen() {
        
        AssestManager().fetchAlbumlist { (folderdetaillist, totalvideocount) in
            DispatchQueue.main.async {
                self.folderlist = folderdetaillist
                self.allVideoCount = totalvideocount
                self.tableViewGallery.reloadData()
                loaderManager.stop()
            }
        }
    }
    

    
    
    @IBAction private func btnAllowPermissionPressed (_ sender : UIButton) {
        let settingkey = UIApplication.openSettingsURLString
        let settingurl = URL(string: settingkey)
        UIApplication.shared.open(settingurl!, completionHandler:nil)
    }

}

extension GalleryFolderViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    private func setUpTableview(){
        self.tableViewGallery.dataSource = self
        self.tableViewGallery.delegate = self
        self.tableViewGallery.register(UINib(nibName: TableViewCellIdentifiers.galleryFolderCell.rawValue, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifiers.galleryFolderCell.rawValue)
        self.tableViewGallery.contentInsetAdjustmentBehavior = .never
        self.tableViewGallery.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : folderlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.galleryFolderCell.rawValue) as? GalleryFolderCell else { return UITableViewCell() }
        
                
        guard indexPath.section != 0 else {
            cell.nameLabel.text = "All Videos"
            cell.countLabel.text = "(\(allVideoCount) video)"
            return cell
        }
        
        cell.folderDetail = folderlist[indexPath.row]
        
        let folderdetail = folderlist[indexPath.row]
        cell.nameLabel.text = folderdetail.name
        cell.countLabel.text = "(\(folderdetail.count) video)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        openAlbumView(indexPath)
    }
}


extension GalleryFolderViewController: AlbumViewDelegate {
    
    func openAlbumView(_ indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GalleryVideoViewController") as! GalleryVideoViewController
        vc.delegate = self
        
        if indexPath.section == 0 {
            vc.albumName = "All Videos"
        } else {
            let folderdetail = folderlist[indexPath.row]
            vc.albumName = folderdetail.name
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func albumview(_ albumName: String, newVideoCount count: String) {
        RefershFolderScreen()
    }
}




extension GalleryFolderViewController {

    
    
    @objc func lockScreenAfterFullScreen(_ notification: Notification) {
        
        if let data = notification.userInfo as? [String: Bool]
        {
            lunchAd(showfullscreen: data["fullScreenAd"]!)
        }
    }
    
    @objc func lunchAd(showfullscreen:Bool = true) {
        
        NotificationCenter.default.removeObserver(self, name: .didCloseLockScreen, object: nil)
        loaderManager.start(parentView: self.view)
        self.perform(#selector(CameraPermissionCheck), with: self, afterDelay: 0.8)
    }

}

