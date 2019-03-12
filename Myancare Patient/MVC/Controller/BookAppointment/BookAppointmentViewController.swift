//
//  BookAppointmentViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class BookAppointmentViewController: UIViewController {
    
    let cellID = "cellID"
    let cellIDCalender = "cellIDCalender"
    let dates = getComingDates(days: 30) //next 30 days
    
    let datelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Jan 2019"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
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
    
    var currentIndex = 0
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
                datelabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
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
                datelabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
                print("\(day)/\(month)/\(year) : weekday \(weekday)")
            }
        }
    }
    
    let slotLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Slots Available"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    lazy var slotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    lazy var bookBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("BOOK NOW", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(bookBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func bookBtnClick(){
        self.navigationController?.pushViewController(ReasonVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Appointment"
        slotCollectionView.register(SlotsCell.self, forCellWithReuseIdentifier: cellID)
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: cellIDCalender)
        setupViews()
        
         if dates.count > 0{
            let date = dates[0] as! NSMutableDictionary
            let month = date.object(forKey: "month") as! Int
            let year = date.object(forKey: "year") as! Int
            datelabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
            calendarView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(datelabel)
        view.addSubview(calendarView)
        view.addSubview(slotLabel)
        view.addSubview(slotCollectionView)
        view.addSubview(bookBtn)
        view.addSubview(nextBtn)
        view.addSubview(previousBtn)
        
        datelabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        calendarView.anchor(datelabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 80)
        previousBtn.anchor(calendarView.topAnchor, left: nil, bottom: nil, right: calendarView.leftAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 24, heightConstant: 24)
        nextBtn.anchor(calendarView.topAnchor, left: calendarView.rightAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        slotLabel.anchor(calendarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        bookBtn.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 8, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        slotCollectionView.anchor(slotLabel.bottomAnchor, left: view.leftAnchor, bottom: bookBtn.topAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

extension BookAppointmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarView{
            let date = dates[indexPath.row] as! NSMutableDictionary
            let day = date.object(forKey: "day") as! Int
            let month = date.object(forKey: "month") as! Int
            let year = date.object(forKey: "year") as! Int
            let weekday = date.object(forKey: "weekday") as! Int
            datelabel.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(year)"
            currentIndex = indexPath.row
            print("\(day)/\(month)/\(year) : weekday \(weekday)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = 0
        if collectionView == calendarView {
            cellCount = dates.count > 0 ? dates.count : 0
        } else {
            cellCount = 10
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == calendarView {
            let calCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDCalender, for: indexPath) as! CalendarCell
            let dateFromCalendar = dates[indexPath.row] as! NSMutableDictionary
            calCell.dayLabel.text = String(dateFromCalendar.object(forKey: "day") as! Int)
            calCell.weekdayLabel.text = getWeekdayString(weekDay: dateFromCalendar.object(forKey: "weekday") as! Int)
            cell = calCell
        } else {
            let slotCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SlotsCell
            cell = slotCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: 0, height: 0)
        if collectionView == calendarView {
            cellSize = CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.height)
        } else {
            cellSize = CGSize(width: collectionView.frame.width, height: 40)
        }
        return cellSize
    }
}



