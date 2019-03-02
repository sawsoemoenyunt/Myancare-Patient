//
//  LoginViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let cellID = "cellID"
    let pages = ["page1", "page2", "page3", "page4", "page5"]
    
    //page control for walk through
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.MyanCareColor.green
        pc.numberOfPages = pages.count
        return pc
    }()
    
    //collection view walk through
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    //custom button for facebook login
    lazy var fbBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login with Facebook".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.fbBlue
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(fbBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func fbBtnClick(){
        self.navigationController?.pushViewController(UserInformationVC(), animated: true)
    }
    
    //custom button for mobile login
    lazy var mobileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login with Mobile", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 16)
        btn.setTitleColor(UIColor.MyanCareColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(fbBtnClick), for: .touchUpInside)
        return btn
    }()
    
    let lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        return view
    }()
    
    var loginbtnBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.register(WalkthroughCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateViews()
    }
    
    func setupViews(){
        
        //add subviews to view
        view.addSubview(collectionView)
        view.addSubview(lineView)
        view.addSubview(fbBtn)
        view.addSubview(mobileBtn)
        view.addSubview(pageControl)
        
        //setup contraints of subviews
         loginbtnBottomConstraint = mobileBtn.anchorWithReturnAnchors(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 287, heightConstant: 30)[0]
        mobileBtn.anchorCenterXToSuperview()
        fbBtn.anchor(nil, left: nil, bottom: mobileBtn.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 287, heightConstant: 50)
        fbBtn.anchorCenterXToSuperview()
        lineView.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: fbBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: lineView.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchor(lineView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchorCenterXToSuperview()
        
        loginbtnBottomConstraint?.constant = 150
    }
    
    func animateViews(){
        
        loginbtnBottomConstraint?.constant = -20
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension LoginViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WalkthroughCell
        cell.image.image = UIImage(named: pages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
}

class WalkthroughCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    func setupViews(){
        addSubview(image)
        image.fillSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
