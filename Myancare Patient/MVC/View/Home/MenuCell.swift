//
//  MenuCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

struct MenuButton {
    var title: String
    var icon: UIImage
}

class MenuCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    var homeViewController: HomeViewController?
    
    let cellID = "cellID"
    let buttonList:[MenuButton] = [MenuButton(title: "Wallet", icon: #imageLiteral(resourceName: "icons8-wallet").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "Appointments", icon: #imageLiteral(resourceName: "icons8-property_time").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "Medical Records", icon: #imageLiteral(resourceName: "icons8-opened_folder").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "Articles", icon: #imageLiteral(resourceName: "icons8-magazine").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "Reminder", icon: #imageLiteral(resourceName: "icons8-stopwatch").withRenderingMode(.alwaysTemplate)),
                                   MenuButton(title: "More", icon: #imageLiteral(resourceName: "icons8-more_filled").withRenderingMode(.alwaysTemplate))]
    
    lazy var collectionView: UICollectionView = {
        //layout of collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        
        //collectionview
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        //change content inset
        cv.contentInset = UIEdgeInsets(top: 6, left: 4, bottom: 0, right: 4)
        
        return cv
    }()
    
    func setupViews(){
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(MenuButtonCell.self, forCellWithReuseIdentifier: cellID)
        
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
extension MenuCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MenuButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuButtonCell
        cell.title.text = buttonList[indexPath.row].title.localized()
        cell.icon.image = buttonList[indexPath.row].icon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width/3 - 6
        return CGSize(width: cellWidth, height: collectionView.frame.height/2 - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //do something for cell click
        
        switch indexPath.row {
        case 0:
            homeViewController?.navigationController?.pushViewController(WalletVC(), animated: true)
        case 1:
            homeViewController?.navigationController?.pushViewController(AppointmentListViewController(), animated: true)
        case 2:
            homeViewController?.navigationController?.pushViewController(RecordBookVC(), animated: true)
        case 3:
            homeViewController?.navigationController?.pushViewController(ArticleVC(), animated: true)
        case 4:
            homeViewController?.navigationController?.pushViewController(ReminderListVC(), animated: true)
        case 5:
            homeViewController?.navigationController?.pushViewController(MoreViewController(), animated: true)
        default:
            //do nothing
            print("No button action")
        }
    }
}

//Cell inside menucell
class MenuButtonCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.tintColor = .black
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Button Text"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 11)
        return lbl
    }()
    
    func setupViews(){
        
        addSubview(icon)
        addSubview(title)
        
        title.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 12, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        icon.anchor(nil, left: nil, bottom: title.topAnchor, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 6, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterXToSuperview()
        
        //setup border
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        //background color
        self.backgroundColor = UIColor.white
        
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
                    self.backgroundColor = UIColor.lightGray
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                    self.backgroundColor = UIColor.white
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






