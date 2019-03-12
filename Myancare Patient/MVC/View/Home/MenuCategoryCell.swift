//
//  MenuCategoryCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class MenuCategoryCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    var homeViewController: HomeViewController?
    let cellID = "cellID"
    let buttonList:[MenuButton] = [MenuButton(title: "General Practitioners", icon: #imageLiteral(resourceName: "icons8-health_checkup").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "Specialists", icon: #imageLiteral(resourceName: "icons8-heart_with_pulse").withRenderingMode(.alwaysTemplate))]
    
    lazy var collectionView: UICollectionView = {
        //layout of collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        //collectionview
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        //change content inset
        cv.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        return cv
    }()
    
    func setupViews(){
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(MenuCategoryButtonCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Menu Cell Extension for collectionview
extension MenuCategoryCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MenuCategoryButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCategoryButtonCell
        cell.title.text = buttonList[indexPath.row].title
        cell.icon.image = buttonList[indexPath.row].icon
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red:0.98, green:0.82, blue:0.19, alpha:1) //yellow
        } else {
            cell.backgroundColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1) //green
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 6
        return CGSize(width: cellWidth, height: collectionView.frame.height/2 - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
            let viewController = DoctorSpecializeViewController(collectionViewLayout: layout)
            self.homeViewController?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            
            let layout = UICollectionViewFlowLayout()
            let docListVC = DoctorListViewController(collectionViewLayout: layout)
            self.homeViewController?.navigationController?.pushViewController(docListVC, animated: true)
        }
    }
}

//Cell inside menucell
class MenuCategoryButtonCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor(white: 1, alpha: 0.5)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Button Text"
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontBold(ofSize: 26)
        return lbl
    }()
    
    func setupViews(){
        
        addSubview(icon)
        addSubview(title)
        
        icon.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 14, widthConstant: 50, heightConstant: 50)
        title.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: icon.leftAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 20, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        //setup border
        //        self.layer.borderColor = UIColor.lightGray.cgColor
        //        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        //background color
        self.backgroundColor = UIColor.white
        
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






