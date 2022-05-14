//
//  GalleryFolderCell.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

class GalleryFolderCell: UITableViewCell {
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var countLabel : UILabel!
    @IBOutlet var folderImgView : UIImageView!
    
    //MARK: - Variables
    var folderDetail: FolderDetail?{
        didSet{
            self.configuringCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.folderImgView.image = UIImage(named: "Folder_blue")
    }
    
    private func configuringCell(){
        self.nameLabel.text = self.folderDetail?.name
        self.countLabel.text = "(\(self.folderDetail!.count) video)"
    }
    
}
