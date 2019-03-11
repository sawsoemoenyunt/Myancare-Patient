//
//  StartScreenViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import SwiftyGif

/// Start Screen View Controller with Animated gif logo
class StartScreenViewController: UIViewController, SwiftyGifDelegate {
    
    ///Imageview for gif logo
    let logo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    ///This func work after view was loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup views
        view.backgroundColor = .white
        view.addSubview(logo)
        logo.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        logo.anchorCenterSuperview()
        
        //init gif
        initGifPlayer()
    }
    
    /**
     Initializes a new gif with file name
     - Parameters: nil
     - Returns: nil
     */
    func initGifPlayer(){
        let gif = UIImage(gifName: "Logo-Motion_Gif.gif")
        logo.delegate = self
        logo.setGifImage(gif, manager: SwiftyGifManager.defaultManager, loopCount: 1)
        logo.startAnimatingGif()
    }
    
    /**
     gif player listener to check gif was playing
     - Parameters: nil
     - Returns: nil
     */
    func gifDidStart(sender: UIImageView) {
        print("StartScreen : gif file start animating")
    }
    
    /**
     gif player listener to check gif was stop playing
     - Parameters: nil
     - Returns: nil
     */
    func gifDidStop(sender: UIImageView) {
        print("StartScreen : gif file finished animating")
        
        //switch rootview controller to HomeViewController after gif was finished playing
//        let layout = UICollectionViewFlowLayout()
//        let homeViewController =  HomeViewController(collectionViewLayout:layout)
//        UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: homeViewController))
        UtilityClass.changeRootViewController(with: LanguageViewController())
    }
    
    // MARK : Deinit
    deinit {
        print("StartScreen Deinit")
    }
}
