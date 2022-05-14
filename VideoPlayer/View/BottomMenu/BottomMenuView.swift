//
//  BottomMenuCell.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

protocol BottomMenuDelegate {
    func bottomMenu(didSelectItemAt index:Int)
}

struct MenuItem {
    var imgName = ""
    var menuName = ""
    var isEnable = true
}

class BottomMenuView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!

    var delegete:BottomMenuDelegate!
    
   internal var menuItems:[MenuItem]? {
        didSet {
            setupCollection()
            collectionView.reloadData()
        }
    }

    private func setupCollection() {
        collectionView.register(UINib(nibName: "BottomMenuCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.frame.size.height = self.frame.height - MYdevice.bottomAnchor
    }

    
    @objc private func pressed(_ sender:UIButton) {
        delegete.bottomMenu(didSelectItemAt: sender.tag)
    }
    
}

extension BottomMenuView:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (menuItems?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BottomMenuCell
        cell.imageButton.tag = indexPath.row
        cell.imageButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        cell.menuitem = menuItems![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let extraspace = isPad ? 10 : MYdevice.bottomAnchor
        return CGSize(width: collectionView.frame.size.width/CGFloat(menuItems!.count),
                      height: collectionView.frame.size.height-extraspace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let bottomextra = isPad ? 5 : MYdevice.bottomAnchor
        let topextra = isPad ? 5 : 0
        return UIEdgeInsets(top: CGFloat(topextra), left: 0, bottom:bottomextra, right: 0)
    }

}
