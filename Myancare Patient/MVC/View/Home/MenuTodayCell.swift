//
//  MenuTodayCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/27/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class MenuTodayCell: UICollectionViewCell {
    
    var homeViewController:HomeViewController?
    let cellID = "cellID"
    var appointmentList = [AppointmentModel]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.MyanCareColor.green
        pc.numberOfPages = 3
        return pc
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Today".localized()
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1) //black
        return lbl
    }()
    
    lazy var viewmoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Show All".localized()+" >  "
        lbl.font = UIFont.mmFontRegular(ofSize: 11)
        lbl.textColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1) //black
        lbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(viewAllClick)))
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    @objc func viewAllClick(){
        homeViewController?.navigationController?.pushViewController(AppointmentListViewController(), animated: true)
    }
    
    func setupViews(){
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(viewmoreLabel)
        addSubview(collectionView)
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 4, bottomConstant: 30, rightConstant: 4, widthConstant: 0, heightConstant: 120)
        viewmoreLabel.anchor(collectionView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(TodayAppointmentCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuTodayCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TodayAppointmentCell
        if appointmentList.count > 0 {
            cell.appointmentData = appointmentList[indexPath.row]
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appointmentDetail = AppointmentDetailVC()
        appointmentDetail.appointmentData = appointmentList[indexPath.row]
        homeViewController?.navigationController?.pushViewController(appointmentDetail, animated: true)
    }
}

class TodayAppointmentCell: UICollectionViewCell {
    
    var appointmentData: AppointmentModel?{
        didSet{
            if let data = appointmentData{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                if let date = formatter.date(from: data.date_of_issue!){
                    let fm1 = DateFormatter()
                    fm1.dateFormat = "dd MMM"
                    let dateString = fm1.string(from: date)
                    let dateRes = dateString.replacingOccurrences(of: " ", with: "\n")
                    dateLabel.text = dateRes
                }
                
                
                if let patientName = data.doctor?.object(forKey: "name") as? String{
                    //set doctor name
                    patientnameLabel.text = patientName
                }
                
                if let doctorImageUrl = data.doctor?.object(forKey: "image_url") as? String{
                    UIImage.loadImage(doctorImageUrl) { (image) in
                        self.patientImage.image = image
                    }
                }
                
                let startTime : UnixTime = data.slotStartTime! / 1000
                timeLabel.text = startTime.to12Hour
                
                reasonLabel.text = " | \(data.reason!)"
            }
        }
    }
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.green
        return view
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "20\nMAR"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let patientnameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Honey Nway Oo"
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "7:00 PM"
        lbl.font = UIFont.mmFontBold(ofSize: 10)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let reasonLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = " | Reason for visit text here.."
        lbl.font = UIFont.mmFontRegular(ofSize: 10)
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let patientImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "pablo-profile")
        img.backgroundColor = UIColor.gray
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 20 //size 40
        img.clipsToBounds = true
        return img
    }()
    
    func setupViews(){
        backgroundColor = .white
        addSubview(bgView)
        addSubview(patientImage)
        addSubview(patientnameLabel)
        addSubview(timeLabel)
        addSubview(reasonLabel)
        
        bgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        patientImage.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 40, heightConstant: 40)
        patientImage.anchorCenterYToSuperview()
        patientnameLabel.anchor(topAnchor, left: bgView.rightAnchor, bottom: nil, right: patientImage.leftAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        timeLabel.anchor(patientnameLabel.bottomAnchor, left: bgView.rightAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        reasonLabel.anchor(patientnameLabel.bottomAnchor, left: timeLabel.rightAnchor, bottom: nil, right: patientImage.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        bgView.addSubview(dateLabel)
        dateLabel.fillSuperview()
        
        layer.cornerRadius = 6
        layer.borderWidth = 0.5
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

