//
//  AudioTrackView.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

public protocol AudioTrackViewDelegate: NSObjectProtocol {
    
    func audioTrackViewCancel()
    func audioTrackViewAddSubtitlefile()
    
    func audioTrackView(didChangeAudioTrack index:Int)
    func audioTrackView(didChangeSubtitleTrack index:Int)
}


class AudioTrackView: UIView {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var cancelView:UIView!
    
    var headerArray = [String]()
    var selectedArray = [Int]()
    var itemArray = [[String]]()
    
    weak var delegate: AudioTrackViewDelegate!

    func openTrackWithData(audiolist:[String], selectedaudio:Int, subtitlelist:[String], selectedsubtitle:Int) {
        
        self.backgroundColor = .tableRow()
        
        var row_count = 0
        headerArray = [String]()
        selectedArray = [Int]()
        itemArray = [[String]]()
        
        //
        if audiolist.count > 2 {
            headerArray.append("Choose Audio Track")
            selectedArray.append(selectedaudio)
            itemArray.append(audiolist)
            row_count += audiolist.count
        }
        
        //
        var subtitle_array = subtitlelist
        subtitle_array.append("Add Subtitle")
        itemArray.append(subtitle_array)
        row_count += subtitle_array.count

        headerArray.append("Choose Subtitle Track")
        selectedArray.append(selectedsubtitle)

        
        //
        cancelView.frame.size.height = MYdevice.bottomAnchor + 50
        cancelView.backgroundColor = .navigationLine()
        
        
        //
        let tableHeight = CGFloat(row_count * 50) + CGFloat(headerArray.count * 28)
        var viewHeight = tableHeight + cancelView.frame.size.height
        viewHeight = min(viewHeight, UIScreen.main.bounds.height-50)
        self.frame.origin.y = UIScreen.main.bounds.height - viewHeight
        self.frame.size.height = viewHeight
        self.frame.size.width = UIScreen.main.bounds.width

        
        //
        cancelView.frame.origin.y = viewHeight - cancelView.frame.size.height
        self.tableView.frame.origin.y = 0
        self.tableView.frame.size.height = viewHeight - cancelView.frame.size.height
        self.setUpTableview()
    }
    
    private func setUpTableview(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: TableViewCellIdentifiers.audioTrackTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifiers.audioTrackTableViewCell.rawValue)
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnCancelPressed(_ sender : UIButton) {
        self.delegate.audioTrackViewCancel()
    }
    
}
 

extension AudioTrackView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.audioTrackTableViewCell.rawValue) as? AudioTrackTableViewCell else { return UITableViewCell() }

        //
        cell.titleLabel.text = itemArray[indexPath.section][indexPath.row]
        
        //
        let selected_row = selectedArray[indexPath.section]
        cell.selectedArrow.isHidden = (selected_row == indexPath.row) ? false : true
        cell.selectedArrow.tintColor = .themecolor()
        
        //
        if cell.titleLabel.text == "Add Subtitle" {
            cell.selectedArrow.isHidden = true
        }
        
        cell.selectionStyle = .none
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        let header_title = headerArray[indexPath.section]
        let row_title_text = itemArray[indexPath.section][indexPath.row]
        
        
        // add new subtitle track
        if row_title_text == "Add Subtitle" {
            self.delegate.audioTrackViewAddSubtitlefile()
            return
        }
        
        
        // subtitle track
        if header_title == "Choose Subtitle Track" {
            self.delegate.audioTrackView(didChangeSubtitleTrack: indexPath.row)
            return
        }
        
        // audio track
        self.delegate.audioTrackView(didChangeAudioTrack: indexPath.row)
    }
}
