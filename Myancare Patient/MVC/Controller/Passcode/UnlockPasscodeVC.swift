//
//  UnlockPasscodeVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

enum PasscodeFor{
    case unlock
    case new
    case change
}

class PasscodeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let cancelDeleteCellId = "cancelDeleteCellId"
    
    let numbers = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "Cancel", "0", "Del"
    ]
    
    // hack solution
    let lettering = [
        "", "A B C", "D E F", "G H I", "J K L", "M N O", "P Q R S", "T U V", "W X Y Z", "", "+", ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setLoginPasscode(value: "1234")
        
        collectionView.backgroundColor = .white
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CancelDeleteCell.self, forCellWithReuseIdentifier: cancelDeleteCellId)
        
        collectionView.register(DialedNumbersHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    var dialedNumbersDisplayString = ""
    var titleString = ""
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // backspace indexPath
        if indexPath.item == 9 {
            dialedNumbersDisplayString = ""
            print("Close Btn click")
            
        } else if indexPath.item == 11{
            dialedNumbersDisplayString = String(dialedNumbersDisplayString.dropLast())
            print("Delete Btn click")
        } else {
            let number = numbers[indexPath.item]
            
            if dialedNumbersDisplayString.count < 4{
                dialedNumbersDisplayString += number
                
                if dialedNumbersDisplayString.count == 4{
                    checkPassword()
                }
            }
            
            print("\(dialedNumbersDisplayString)")
        }
        
        collectionView.reloadData()
    }
    
    func checkPassword(){
        var title = ""
        var subTitle = ""
        
        if let savedPassword = UserDefaults.standard.getLoginPsscode(){
            if dialedNumbersDisplayString == savedPassword{
                title = "Success"
                subTitle = "You're login!"
                dialedNumbersDisplayString = ""
            } else {
                title = "Failed"
                subTitle = "Wrong password entered!"
                dialedNumbersDisplayString = ""
            }
        }
        
        let alertController = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DialedNumbersHeader
        header.numbersLabel.text = titleString
        
        switch dialedNumbersDisplayString.count {
        case 1:
            header.dot1.backgroundColor = UIColor.gray
            header.dot2.backgroundColor = UIColor.white
            header.dot3.backgroundColor = UIColor.white
            header.dot4.backgroundColor = UIColor.white
        case 2:
            header.dot1.backgroundColor = UIColor.gray
            header.dot2.backgroundColor = UIColor.gray
            header.dot3.backgroundColor = UIColor.white
            header.dot4.backgroundColor = UIColor.white
        case 3:
            header.dot1.backgroundColor = UIColor.gray
            header.dot2.backgroundColor = UIColor.gray
            header.dot3.backgroundColor = UIColor.gray
            header.dot4.backgroundColor = UIColor.white
        case 4:
            header.dot1.backgroundColor = UIColor.gray
            header.dot2.backgroundColor = UIColor.gray
            header.dot3.backgroundColor = UIColor.gray
            header.dot4.backgroundColor = UIColor.gray
        default:
            header.dot1.backgroundColor = UIColor.white
            header.dot2.backgroundColor = UIColor.white
            header.dot3.backgroundColor = UIColor.white
            header.dot4.backgroundColor = UIColor.white
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        let height = view.frame.height * 0.2
        return .init(width: view.frame.width, height: height)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return numbers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 9 || indexPath.item == 11 {
            let greenButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: cancelDeleteCellId, for: indexPath) as! CancelDeleteCell
            greenButtonCell.label.text = indexPath.item == 9 ? "Cancel" : "Delete"
            return greenButtonCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeyCell
        cell.digitsLabel.text = numbers[indexPath.item]
        cell.lettersLabel.text = lettering[indexPath.item]
        return cell
    }
    
    lazy var leftRightPadding = view.frame.width * 0.13
    lazy var interSpacing = view.frame.width * 0.1
    lazy var totalEmptySpace = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing)
    lazy var cellWidth = totalEmptySpace / 3
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            let leftPadding = (view.frame.width) / 2 - cellWidth / 2
            return .init(top: 0, left: leftPadding, bottom: 0, right: self.leftRightPadding)
        }
        return .init(top: 16, left: leftRightPadding, bottom: 16, right: leftRightPadding)
    }
    
}


