//
//  ReminderListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import EMAlertController

enum ReminderType {
    case today
    case all
}

class ReminderListVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var reminderList = [MedicalReminderModel]()
    var isPaging = true
    var type = ReminderType.today
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
        return cv
    }()
    
    lazy var typeSegment:UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Today","All"])
        //        sg.setImage( #imageLiteral(resourceName: "icons8-magazine"), forSegmentAt: 0)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-more_filled"), forSegmentAt: 1)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-appointment_reminders"), forSegmentAt: 2)
        sg.tintColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1)
        sg.backgroundColor = .clear
        sg.selectedSegmentIndex = 0
        sg.layer.cornerRadius = 17
        sg.clipsToBounds = true
        sg.layer.borderWidth = 2
        sg.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        sg.layer.borderColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1).cgColor
        sg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        sg.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sg
    }()
    
    @objc func handleSegment(){
        if typeSegment.selectedSegmentIndex == 0{
            type = .today
        } else {
            type = .all
        }
        refreshData()
    }
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 28 //56
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func addBtnClick(){
        self.navigationController?.pushViewController(AddReminderVC(), animated: true)
    }
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshData() {
        isPaging = true
        reminderList.removeAll()
        self.getReminders()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getReminders()
    }
    
    func setupViews(){
        self.title = "Medication Reminder"
        view.backgroundColor = .white
        
        view.addSubview(typeSegment)
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        
        let v = view.safeAreaLayoutGuide
        typeSegment.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        collectionView.anchor(typeSegment.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
        
        collectionView.register(ReminderListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.refreshControl = refreshControl1
    }
}

extension ReminderListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reminderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReminderListCell
        cell.reminderListVC = self
        if reminderList.count > 0{
            cell.reminderData = reminderList[indexPath.row]
        }
        
        if isPaging && indexPath.row == reminderList.count - 1{
            self.getReminders()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reminderVC = ReminderVC()
        reminderVC.reminderData = reminderList[indexPath.row]
        self.navigationController?.pushViewController(reminderVC, animated: true)
    }
}

extension ReminderListVC{
    func getReminders(){
        
        if reminderList.count == 0{
            self.startAnimating()
        }
        
        let skip = reminderList.count > 0 ? reminderList.count : 0
        let limit = 10
        let url = type == .all ? EndPoints.getReminders(skip, limit).path : EndPoints.getRemindersToday(skip, limit).path
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 200{
                    if let responseDataArr = response.result.value as? NSArray{
                        self.assignData(responseDataArr)
                    }
                }
                else {
                    print("\(responseStatus ?? 0) Failed to get reminder list...")
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func assignData(_ dataArr:NSArray){
        self.isPaging = dataArr.count == 0 ? false : true
        
        for data in dataArr{
            if let dataDict = data as? [String:Any]{
                let reminder = MedicalReminderModel()
                reminder.updateModelUsingDict(dataDict)
                
                reminderList.append(reminder)
            }
        }
        self.collectionView.reloadData()
    }
    
    func confirmDelete(_ id:String){
        let actionController = UIAlertController(title: "Warning", message: "Please confirm to delete this reminder!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
            self.deleteReminderFromServer(id)
        }
        actionController.addAction(cancel)
        actionController.addAction(confirm)
        self.present(actionController, animated: true, completion: nil)
    }
    
    func deleteReminderFromServer(_ id:String){
        if id != ""{
            let url = EndPoints.deleteReminderByID(id).path
            let heads = ["Authorization":"\(jwtTkn)"]
            
            Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                switch response.result{
                case .success:
                    print("reminder deleted")
                    self.refreshData()
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}

