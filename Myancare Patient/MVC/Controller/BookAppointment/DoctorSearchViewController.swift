//
//  DoctorSearchViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

struct DoctorSearch {
    var name = ""
    var date = ""
    var isSearch = false
}

var docSearch = DoctorSearch.init(name: "", date: "", isSearch: false)

class DoctorSearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let cellIDCalendar = "cellIDCalendar"
    let dates = getComingDates(days: 30)
    var currentIndex = 0
    let buttonList:[MenuButton] = [MenuButton(title: "Vegan", icon: #imageLiteral(resourceName: "icons8-vegan_food")),
                                   MenuButton(title: "Heart", icon: #imageLiteral(resourceName: "icons8-medical_heart")),
                                   MenuButton(title: "Babay", icon: #imageLiteral(resourceName: "icons8-baby")),
                                   MenuButton(title: "Medicine", icon: #imageLiteral(resourceName: "icons8-supplement_bottle")),
                                   MenuButton(title: "Sp5", icon: UIImage()),
                                   MenuButton(title: "Sp6", icon: UIImage()),
                                   MenuButton(title: "Vegan", icon: #imageLiteral(resourceName: "icons8-vegan_food")),
                                   MenuButton(title: "Heart", icon: #imageLiteral(resourceName: "icons8-medical_heart")),
                                   MenuButton(title: "Babay", icon: #imageLiteral(resourceName: "icons8-baby")),
                                   MenuButton(title: "Medicine", icon: #imageLiteral(resourceName: "icons8-supplement_bottle")),
                                   MenuButton(title: "Sp5", icon: UIImage()),
                                   MenuButton(title: "Sp6", icon: UIImage())]
    
    let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Search by Name"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
        return tf
    }()
    
    let specialitiesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Specialities"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        //layout of collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        
        //collectionview
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        //change content inset
        cv.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 4)
        
        return cv
    }()
    
    lazy var calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icons8-forward"), for: .normal)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func nextBtnClick(){
        if currentIndex < 29 {
            currentIndex = currentIndex + 1
            if dates.count >= currentIndex{
                calendarView.selectItem(at: IndexPath(row: currentIndex, section: 0), animated: true, scrollPosition: .left)
                let date = dates[currentIndex] as! NSMutableDictionary
                let day = date.object(forKey: "day") as! Int
                let month = date.object(forKey: "month") as! Int
                let year = date.object(forKey: "year") as! Int
                let weekday = date.object(forKey: "weekday") as! Int
                dateLabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
                print("\(day)/\(month)/\(year) : weekday \(weekday)")
            }
        }
    }
    
    lazy var previousBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icons8-back"), for: .normal)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(previousBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func previousBtnClick(){
        if currentIndex > 0 {
            currentIndex = currentIndex - 1
            if dates.count >= currentIndex{
                calendarView.selectItem(at: IndexPath(row: currentIndex, section: 0), animated: true, scrollPosition: .right)
                let date = dates[currentIndex] as! NSMutableDictionary
                let day = date.object(forKey: "day") as! Int
                let month = date.object(forKey: "month") as! Int
                let year = date.object(forKey: "year") as! Int
                let weekday = date.object(forKey: "weekday") as! Int
                dateLabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
                print("\(day)/\(month)/\(year) : weekday \(weekday)")
            }
        }
    }
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimbuttonClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confrimbuttonClick(){
        docSearch.name = searchField.text!.lowercased().replacingOccurrences(of: " ", with: "-")
        docSearch.isSearch = true
        self.navigationController?.popViewController(animated: true)
        print("Search button clicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Doctor"
        self.view.backgroundColor = .white
        setupViews()
        
        if dates.count > 0{
            let date = dates[0] as! NSMutableDictionary
            let month = date.object(forKey: "month") as! Int
            let year = date.object(forKey: "year") as! Int
            dateLabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
            calendarView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func setupViews(){
        view.addSubview(searchField)
//        view.addSubview(specialitiesLabel)
//        view.addSubview(collectionView)
        view.addSubview(dateLabel)
        view.addSubview(calendarView)
        view.addSubview(confirmBtn)
        view.addSubview(nextBtn)
        view.addSubview(previousBtn)
        
        searchField.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 36)
//        specialitiesLabel.anchor(searchField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
//        collectionView.anchor(specialitiesLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 100)
        dateLabel.anchor(searchField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        calendarView.anchor(dateLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 80)
        previousBtn.anchor(calendarView.topAnchor, left: nil, bottom: nil, right: calendarView.leftAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 24, heightConstant: 24)
        nextBtn.anchor(calendarView.topAnchor, left: calendarView.rightAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        confirmBtn.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 38, bottomConstant: 50, rightConstant: 38, widthConstant: 0, heightConstant: 50)
        
        
        collectionView.register(DoctorSearchSpecializationCell.self, forCellWithReuseIdentifier: cellID)
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: cellIDCalendar)
    }
}

extension DoctorSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarView{
            let date = dates[indexPath.row] as! NSMutableDictionary
            let day = date.object(forKey: "day") as! Int
            let month = date.object(forKey: "month") as! Int
            let year = date.object(forKey: "year") as! Int
            let weekday = date.object(forKey: "weekday") as! Int
            dateLabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
            currentIndex = indexPath.row
            print("\(day)/\(month)/\(year) : weekday \(weekday)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = 0
        if collectionView == calendarView {
            cellCount = dates.count > 0 ? dates.count : 0
        } else {
            cellCount = buttonList.count
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == calendarView {
            let calCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDCalendar, for: indexPath) as! CalendarCell
            let dateFromCalendar = dates[indexPath.row] as! NSMutableDictionary
            calCell.dayLabel.text = String(dateFromCalendar.object(forKey: "day") as! Int)
            calCell.weekdayLabel.text = getWeekdayString(weekDay: dateFromCalendar.object(forKey: "weekday") as! Int)
            cell = calCell
        } else {
            let spcell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DoctorSearchSpecializationCell
            spcell.icon.image = buttonList[indexPath.row].icon
            spcell.title.text = buttonList[indexPath.row].title
            cell = spcell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: 0, height: 0)
        if collectionView == calendarView {
            cellSize = CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.height)
        } else {
            cellSize = CGSize(width: collectionView.frame.width/4 - 10, height: collectionView.frame.height)
        }
        return cellSize
    }
}



