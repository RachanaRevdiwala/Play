//
//  SettingViewController.swift
//  VideoPlayer
//
//  Created by Devkrushna on 21/10/21.
//  Copyright © 2021 Devkrushna. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {
    
    @IBOutlet private var topNaviView : UIView!
    @IBOutlet private var tableview : UITableView!
    
    private var settingMenu = [[String]]()
    private var detailList = [["Secure access to your content", "Theme"],
                              ["Remove Ads!"],
                              ["iTunes file sync", "Download files directly to your device"]]

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background()
        topNaviView.setTopNavigation()
        tableview.frame.origin.y = topNaviView.frame.height+10
        
        settingMenu = [["App Lock", "Appearance"],
                       ["Remove Ads!"],
                       ["Sync With Your Computer", "Downloads"],
                       ["FeedBack and Bug Report"],
                       ["Give support and Rate us","Share the App","About Us"]]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    private func shareapp(senderrect:CGRect) {
        
        let shareText = "Video Player & Manager (Supported All type Videos), download now"
        let textToShare = "\(shareText) \nIOS\nitms-apps://itunes.apple.com/app/id"
        
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        if isPad {
            let senderrect = CGRect(x: self.view.frame.width/2-100, y: senderrect.origin.y, width: 250, height: 250)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = senderrect
        }
        
        activityVC.modalPresentationStyle = .fullScreen
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func openRemoveAdView(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SyncViewController") as! SyncViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    private func clickSection0(index:Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SyncViewController") as! SyncViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    private func clickSection2(index:Int){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SyncViewController") as! SyncViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    private func clickSection3(index:Int){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSViewController") as! ContactUSViewController
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SettingViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenu[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.backgroundColor = .tableRow()
        
        //
        if indexPath.section == 0 || indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
            cell.detailTextLabel?.text = detailList[indexPath.section][indexPath.row]
        }
        
        cell.textLabel?.text = settingMenu[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //
        if indexPath.section == 0 {
            self.clickSection0(index: indexPath.row)
            return
        }
        
        if indexPath.section == 1 {
            self.openRemoveAdView()
            return
        }
        
        //
        if indexPath.section == 2 {
            self.clickSection2(index: indexPath.row)
            return
        }
        
        //
        if indexPath.section == 3 {
            self.clickSection3(index: indexPath.row)
            return
        }
        
        
        //
        switch indexPath.row {
     
        case 1:
            let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
            shareapp(senderrect: rectOfCellInTableView)
            break

        case 2: UIApplication.shared.open(URL(string: "www.google.com")!, options: [:], completionHandler: nil)
        
        default: break
        }
    }
}
