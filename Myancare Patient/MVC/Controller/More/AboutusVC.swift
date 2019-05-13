//
//  AboutusVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/27/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

struct AboutUsList {
    var title = ""
    var subTitles = [String]()
}

class AboutusVC: UITableViewController {
    
    let cellID = "cellID"
    
    let sectionAndList = [AboutUsList.init(title: "About", subTitles: ["Visit to our website"]),
                          AboutUsList.init(title: "Policies", subTitles: ["Term of Use", "Privacy Policy", "Cancellation Policy", "Payment Policy"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "About".localized()
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionAndList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAndList[section].subTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionAndList[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = sectionAndList[indexPath.section].subTitles[indexPath.row].localized()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.MyanCareFont.type2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let openUrl = URL(string: "https://www.myancare.org/about"){
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                print("Redirect to myancare website...")
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                if let openUrl = URL(string: "https://www.myancare.org/terms-conditions"){
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                    print("Redirect to myancare website...")
                }
            } else if indexPath.row == 1 {
                if let openUrl = URL(string: "https://www.myancare.org/privacy-policy"){
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                    print("Redirect to myancare website...")
                }
            } else if indexPath.row == 2 {
                if let openUrl = URL(string: "https://www.myancare.org/cancellation-policy"){
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                    print("Redirect to myancare website...")
                }
            } else if indexPath.row == 3 {
                if let openUrl = URL(string: "https://www.myancare.org/complaint-policy"){
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                    print("Redirect to myancare website...")
                }
            }
            
        }
//        if let openUrl = URL(string: "https://www.myancare.org/"){
//            UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
//            print("Redirect to myancare website...")
//        }
    }
}
