//
//  EHRListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class EHRListVC: UIViewController {
    
    let cellID = "cellID"
    let cellID_lifeStyle = "cellID_lifeStyle"
    let cellID_currentMedicine = "cellID_currentMedicine"
    let cellID_avoidMedicine = "cellID_avoidMedicine"
    let cellID_disease = "cellID_disease"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "ကျန်းမာရေးမှတ်တမ်းများ"
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.register(PatientInfoCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(LifeStyleCellCollectionView.self, forCellWithReuseIdentifier: cellID_lifeStyle)
        collectionView.register(CurrentMedicineCellCollectionView.self, forCellWithReuseIdentifier: cellID_currentMedicine)
        collectionView.register(AvoidMedicineCellCollectionView.self, forCellWithReuseIdentifier: cellID_avoidMedicine)
        collectionView.register(DiseaseCellCollectionView.self, forCellWithReuseIdentifier: cellID_disease)
    }
}

extension EHRListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if indexPath.row == 0{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PatientInfoCell
            cell = cell1
        }else if indexPath.row == 1{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_lifeStyle, for: indexPath) as! LifeStyleCellCollectionView
            cell = cell1
        }
        else if indexPath.row == 2{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_currentMedicine, for: indexPath) as! CurrentMedicineCellCollectionView
            cell = cell1
        }
        else if indexPath.row == 3{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_avoidMedicine, for: indexPath) as! AvoidMedicineCellCollectionView
            cell = cell1
        }
        else if indexPath.row == 4{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_disease, for: indexPath) as! DiseaseCellCollectionView
            cell = cell1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 220
        if indexPath.row == 1 {
            height = 330
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
}




