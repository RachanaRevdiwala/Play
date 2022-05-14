//
//  SortByView.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

protocol SortByViewDelegate {
    func sortByViewHide()
    func sortByViewChangeSorting()
}

class SortByView: UIView {
    
    @IBOutlet weak var listbackView: UIView!
    @IBOutlet weak var acendingswitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var sortbylist:[ArraySortingType] = [.alpha,.duration,.created, .modified, .size]
    var current_sorttype = ArraySortingManager.getCurrentSortType()
    
    var delegate: SortByViewDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView()  {
        
        //
        self.frame = CGRect(origin: .zero, size: screenSize.size)
        self.backgroundColor = .black.withAlphaComponent(0)
        acendingswitch.isOn = ArraySortingManager.getAescendingOrder()
        
        //
        listbackView.backgroundColor = .tableRow()
        listbackView.layer.cornerRadius = 20
        listbackView.frame.size.height = 110 + 50*5 + MYdevice.bottomAnchor
        listbackView.frame.origin.y = screenSize.height - listbackView.frame.height + 10
        
        tableView.register(UINib(nibName: "SortByTableCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func showView(sender:UIView) {
        
        listbackView.frame.origin.y = screenSize.height
        sender.addSubview(self)
      
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .black.withAlphaComponent(0.6)
            self.listbackView.frame.origin.y = screenSize.height - self.listbackView.frame.height + 10
        }
    }
    
    func hideView() {
        
        self.delegate.sortByViewHide()

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .black.withAlphaComponent(0)
            self.listbackView.frame.origin.y = screenSize.height
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func backbuttonclick(){
        hideView()
    }
    
    @IBAction func acendingSwicthOnOff() {
        
        self.delegate.sortByViewChangeSorting()
        hideView()
    }
}


extension SortByView: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortbylist.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SortByTableCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.settintColor()
        
        cell.textLabel?.text = sortbylist[indexPath.row].title
        cell.textLabel?.textColor = (current_sorttype == sortbylist[indexPath.row]) ? .themecolor() : .label
        cell.accessoryType = (current_sorttype == sortbylist[indexPath.row]) ?  .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (current_sorttype != sortbylist[indexPath.row]) else {
            return
        }
        
        //
        current_sorttype = sortbylist[indexPath.row]
        tableView.reloadData()
        
        self.delegate.sortByViewChangeSorting()
        hideView()
    }
}


class SortByTableCell: UITableViewCell {
    
    func settintColor() {
        SortByTableCell.appearance().tintColor = .themecolor()
    }
    
}
