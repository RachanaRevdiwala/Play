//
//  SubtitleListViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit

public protocol SubtitleListDelegate: NSObjectProtocol {
    func subtitleListViewAddNewFile()
    func subtitleListView(didAddSubtitleTrack sender:URL)
}

class SubtitleListViewController: UIViewController {
    
    @IBOutlet var topNaviView : UIView!
    @IBOutlet var syncButton : UIButton!
    @IBOutlet var doneButton : UIButton!
    @IBOutlet var addButton : UIButton!
    @IBOutlet var tableView : UITableView!
    
    var subtitle_array = [URL]()
    
    weak var delegate: SubtitleListDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()

        topNaviView.setTopNavigation()
        tableView.frame.origin.y = topNaviView.frame.height
        tableView.frame.size.height = self.view.frame.height - topNaviView.frame.height
        
        doneButton.tintColor = .themecolor()
        addButton.tintColor = .themecolor()
        syncButton.tintColor = .themecolor()
        
        getSubtitleList()
    }
    
    func getSubtitleList() {
        
        VideoFileManager().GetSubtitleList { subtitle_url_list in
            
            guard subtitle_url_list != nil else {
                return
            }
            
            self.subtitle_array = subtitle_url_list!
            self.tableView.reloadData()
        }
    }
    
    @IBAction func syncInfoClick(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SyncViewController") as! SyncViewController
        self.present(vc, animated: true, completion: nil)
    }
    

    
    @IBAction func doneClick(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewSubtitleClick(_ sender : UIButton) {
        let controller = UIDocumentPickerViewController(documentTypes: ["public.srt"], in: .import)
        controller.delegate = self
        controller.allowsMultipleSelection = true
        self.present(controller,animated: true,completion: nil)
    }
}

extension SubtitleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtitle_array.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Choose Subtitle File"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let fullpath = subtitle_array[indexPath.row]
        cell.textLabel?.text = fullpath.lastPathComponent
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.subtitleListView(didAddSubtitleTrack: subtitle_array[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension SubtitleListViewController: UIDocumentPickerDelegate {
    
        
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        //
        DispatchQueue.global(qos: .background).async {
            
            VideoFileManager().copyVideoFile(urls)
            
            DispatchQueue.main.async {
                
                self.getSubtitleList()
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}
