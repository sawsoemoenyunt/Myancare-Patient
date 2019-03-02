//
//  DoctorSpecializationViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorSpecializeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.topItem?.title = ""
        
        //add right barbuttonitem
        let questionButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ask_question_filled"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [questionButton]
        
        //setup collectionview
        collectionView?.backgroundColor = .white
        collectionView?.register(SpecializationCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Choose Specializations"
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width/2-10, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SpecializationCell
            cell.label.text = buttonList[indexPath.row].title
            cell.icon.image = buttonList[indexPath.row].icon
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let docVC = DoctorListViewController(collectionViewLayout: layout)
        docVC.doctorType = DoctorType.specialize
        self.navigationController?.pushViewController(docVC, animated: true)
    }
}

