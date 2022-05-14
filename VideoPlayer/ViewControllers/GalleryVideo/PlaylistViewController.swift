//
//  PlaylistViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit



class PlaylistViewController: UIViewController {
    
    @IBOutlet private var topNaviView : UIView!
    @IBOutlet private var titleLabel : UILabel!
    @IBOutlet private var addButton : UIButton!
    @IBOutlet private var editButton : UIButton!
    
    @IBOutlet private var cancelButton : UIButton!
    @IBOutlet private var collectionView : UICollectionView!
    
    private var bottomMenu = Bundle.main.loadNibNamed("BottomMenuView", owner: nil, options: nil)![0] as! BottomMenuView
    private var selectedVideoCell = [Int]()
    private var playListAlbums = [PlaylistAlbum]()
    
    enum PlaylistType {
        case tabview, listview
        
        func cellIdentifier() -> String {
            return CollectionViewCellIdentifiers.playlistCollectionViewCell.rawValue
        }
        
        func titleName() -> String {
            return "Playlist"
        }
    }
    
    internal var playlistType:PlaylistType = .tabview
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.setUpUI()
        self.setUpCollectionview()
        self.updatePlayList()
        

        if playlistType == .tabview {
            
            self.setUpBottomMenuView()
            self.setNotificationtObserver()
        }
    }
    
    private func setUpUI(){
        
        self.view.backgroundColor = .background()
        titleLabel.text = playlistType.titleName()
        
        //
        if playlistType == .tabview {
            topNaviView.setTopNavigation()
        } else {
            topNaviView.frame.size.height = 55
            topNaviView.backgroundColor = .tableRow()
            
            editButton.isHidden = true
            cancelButton.isHidden = false
        }
        
        
        addButton.tintColor = .themecolor()
        editButton.tintColor = .themecolor()
        cancelButton.tintColor = .themecolor()
    }
    
    private func setNotificationtObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayList), name: .refreshPlaylistScreen, object: nil)

    }
    
    
 
    @objc private func updatePlayList() {
        self.collectionView.reloadData()

    }
    

    @IBAction private func addNewPlayAlbum(){

        let alert = UIAlertController(title: "New Playlist", message: "Choose a title for your new playlist", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Playlist title"
            textfield.autocorrectionType = .default
            textfield.delegate = self
        })
                

        let action = UIAlertAction(title: "Save", style: .default, handler: { _ in
            let newname = (alert.textFields![0].text ?? "NewPlaylist").trimWhiteSpaec()
            self.addNewPlaylist(name: newname)
        })
        
        action.isEnabled = false
        alert.addAction(action)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addNewPlaylist(name:String) {
        
        let new:PlaylistAlbum = PlaylistAlbum(id: 2, name: name, count: 0)
        playListAlbums.append(new)
        updatePlayList()
    }
    
    @IBAction private func cancelButtonEvent(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }


    //MARK:-
    @IBAction private func editPlayAlbum(_ sender : Any) {
        
        guard playListAlbums.count != 0 else {
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
            bottomMenu.isHidden = !isEditVideoCell
            addButton.isHidden = isEditVideoCell
//            sortButton.isHidden = isEditVideoCell
            
            collectionView.reloadData()
        }
    }
}


extension PlaylistViewController: UITextFieldDelegate {
    
    // playlist name - empty name - disble save button
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard (self.presentedViewController?.isKind(of: UIAlertController.self))! else {
            return
        }
        
        let newname = textField.text!.trimWhiteSpaec()
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController
        let addAction: UIAlertAction = alertController.actions[0]
        addAction.isEnabled = newname.count > 0
    }
}



extension PlaylistViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    private func setUpCollectionview() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.frame.origin.y = topNaviView.frame.height
        if playlistType == .listview {
            self.collectionView.frame.size.height = self.view.frame.height - topNaviView.frame.height
            self.collectionView.frame.size.width = self.view.frame.width - 25
            self.collectionView.frame.origin.x = 10
        } else {
            self.collectionView.frame.size.height = (self.tabBarController?.tabBar.frame.origin.y)! - topNaviView.frame.height
        }
        
        
        let collectionlayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionlayout.minimumLineSpacing = 12
        collectionlayout.minimumInteritemSpacing = 15
        collectionlayout.sectionInset = UIEdgeInsets(top:12, left: 12, bottom: 18, right: 12)
        
        //cell size
        let inline_cell:CGFloat = isPad ? 4 : 2
        var cellwidth = (self.view.frame.width - 43)/inline_cell
        var cellheight = (cellwidth*60/100) + 55
        
        if playlistType == .listview {
            cellwidth = collectionView.frame.width
            cellheight = 65
        }
        collectionlayout.itemSize = CGSize(width: cellwidth, height: cellheight)
        collectionView.collectionViewLayout = collectionlayout
        
        self.collectionView.register(UINib(nibName: playlistType.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: playlistType.cellIdentifier())

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListAlbums.count
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: playlistType.cellIdentifier(), for: indexPath) as? PlaylistCollectionViewCell else { return UICollectionViewCell() }

        cell.playlistAlbum = playListAlbums[indexPath.row]
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //
        guard playlistType == .tabview else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // 1
        guard isEditVideoCell else {
            openAlbumVideoList(indexPath.row)
            return
        }

        // 2
        let cell = collectionView.cellForItem(at: indexPath) as! PlaylistCollectionViewCell
        if selectedVideoCell.contains(indexPath.row) {
            selectedVideoCell.remove(at: selectedVideoCell.firstIndex(of: indexPath.row)!)
            cell.isSelectedVideo(false)
        } else {
            selectedVideoCell.append(indexPath.row)
            cell.isSelectedVideo(true)
        }
    }
    
    private func openAlbumVideoList(_ index:Int) {

    }

}


extension PlaylistViewController : BottomMenuDelegate {
 
    func setUpBottomMenuView() {
        
        bottomMenu.frame.size.height = self.tabBarController?.tabBar.frame.height ?? 50
        bottomMenu.frame.size.width = screenSize.width
        bottomMenu.frame.origin.y = screenSize.height - bottomMenu.bounds.height
        bottomMenu.frame.origin.x = 0
        bottomMenu.backgroundColor = .tableRow()
        bottomMenu.isHidden = true

        bottomMenu.delegete = self
        bottomMenu.menuItems = [MenuItem(imgName: "menu_rename", menuName: "Rename"),
                                MenuItem(imgName: "menu_delete", menuName: "Delete")]
        
        
        self.view.addSubview(bottomMenu)
    }
    
    func bottomMenu(didSelectItemAt index: Int) {
   
        //
        guard selectedVideoCell.count > 0 else {
            return
        }
        
        //
        switch index {
        case 0: renamePlayListName(0)
        case 1: deleteVideoFile()
        default: break
        }
    }
    
    private func renamePlayListName(_ index:Int) {
        
        //
        guard index < selectedVideoCell.count else {
            isEditVideoCell = false
            return
        }
        
        let playList_index = selectedVideoCell[index]
        
        var playlistalbum = playListAlbums[playList_index]
        let currentName = playlistalbum.name
        
        
        //
        let alert = UIAlertController(title: "Enter new name for " + currentName, message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {textfield in
            textfield.text = currentName
            textfield.delegate = self
            textfield.autocorrectionType = .default
        })
                

        let action = UIAlertAction(title: "Rename", style: .default, handler: { [self]_ in
            
            let newname = (alert.textFields![0].text ?? "").trimWhiteSpaec()
            
            // oldname == newname
            guard newname.count != 0 && currentName != newname else {
                renamePlayListName(index+1)
                return
            }

            // Update
            playlistalbum.name = newname
            playListAlbums[playList_index] = playlistalbum
            collectionView.reloadData()
            
            renamePlayListName(index+1)
        })
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteVideoFile() {
        
        let alert = UIAlertController(title: "Delete", message: "Confirm remove the Playlists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { [self]_ in
            
            // detele video
            for playlist_index in selectedVideoCell {
                let playlistalbum = playListAlbums[playlist_index]
            }
        
            updatePlayList()
            isEditVideoCell = false
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

