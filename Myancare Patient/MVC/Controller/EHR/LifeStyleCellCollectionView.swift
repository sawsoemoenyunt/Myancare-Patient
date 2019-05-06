//
//  LifeStyleCellCollectionView.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class LifeStyleCellCollectionView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var ehrVC : EHRListVC?
    var lifeStyleList = [Disease]()
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        lbl.text = "လူနေမှုဘဝပုံစံမှတ်တမ်းများ"
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    let lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lifeStyleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LifeStyleCell
        
        if lifeStyleList.count > 0{
            cell.questionlabel.text = lifeStyleList[indexPath.row].name!
            cell.answerSwitch.isOn = lifeStyleList[indexPath.row].checked!
            cell.ehrVC = self.ehrVC
            cell.index = indexPath.row
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func setupViews(){
        addSubview(titlelabel)
        addSubview(collectionView)
        addSubview(lineView)
        
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(titlelabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        
        collectionView.register(LifeStyleCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LifeStyleCell: UICollectionViewCell {
    
    var ehrVC : EHRListVC?
    var index : Int?
    
    let questionlabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ရာသီတုပ်ကွေးဆေးထိုးလေ့ရှိပါသလား?"
        return lbl
    }()
    
    lazy var answerSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(changeAnswer), for: .valueChanged)
        return sw
    }()
    
    @objc func changeAnswer(){
        if (self.ehrVC?.lifeStyleList[index!].checked!)!{
            self.ehrVC?.lifeStyleList[index!].checked = false
            
        } else {
            self.ehrVC?.lifeStyleList[index!].checked = true
        }
        self.ehrVC?.collectionView.reloadData()
    }
    
    func setupViews(){
        addSubview(questionlabel)
        addSubview(answerSwitch)
        
        questionlabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 70, widthConstant: 0, heightConstant: 0)
        answerSwitch.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        answerSwitch.anchorCenterYToSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

