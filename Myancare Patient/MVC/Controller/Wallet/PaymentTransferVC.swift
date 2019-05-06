//
//  PaymentTransferVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 5/4/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class PaymentTransferVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var exchangeRate = ExchangeRateModel()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(showConfirmActionSheet), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 0
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
        self.title = "Bank or Mobile Banking Transfer"
        self.view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(confirmBtn)
        
        let v = view.safeAreaLayoutGuide
        confirmBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: confirmBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(PaymentTransferCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    @objc func showBankPicker(){
        
        let actionSheet = UIAlertController(title: "Choose Bank to transfer", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let aya = UIAlertAction(title: "AYA Bank", style: .default) { (action) in
            
        }
        let cb = UIAlertAction(title: "CB Bank", style: .default) { (action) in
            
        }
        let kbz = UIAlertAction(title: "KBZ Bank", style: .default) { (action) in

        }
        
        actionSheet.addAction(aya)
        actionSheet.addAction(cb)
        actionSheet.addAction(kbz)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func showConfirmActionSheet(){
        let actionSheet = UIAlertController(title: "Please confirm to request payment", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.requestTransactions(gateWay: self.exchangeRate.payment_gateway!, coin: self.exchangeRate.coin_amount!, amount: self.exchangeRate.kyat_amount!)
        }
        
        actionSheet.addAction(confirmBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension PaymentTransferVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PaymentTransferCell
        cell.paymentTransferVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height + 300)
    }
    
}

extension PaymentTransferVC{

    func requestTransactions(gateWay:String, coin:Int, amount:Int){
        
        self.startAnimating()
        
        let url = EndPoints.transactionsRequest.path
        let params = ["coin" : coin,
                      "amount" : amount,
                      "payment_gateway" : gateWay] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    let alert = UIAlertController(title: "Success", message: "Your manual payment with \(gateWay.uppercased()) was requested to Myancare!", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let layout = UICollectionViewFlowLayout()
                        let homeVC = HomeViewController(collectionViewLayout:layout)
                        let navController = UINavigationController(rootViewController: homeVC)
                        homeVC.pushToVC(vc: WalletVC())
                        UtilityClass.changeRootViewController(with: navController)
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.showAlert(title: "Failed", message: "An error occured while requesting manual payment")
                }
                
            case .failure(let error):
                self.showAlert(title: "Failed", message: "An error occured while requesting manual payment")
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
}

class PaymentTransferCell: UICollectionViewCell{
    
    var paymentTransferVC : PaymentTransferVC?
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "ဘဏ်မှတဆင့်(သို့)မိုဘိုင်းဖြင့် အသုံးပြုရသော ဘဏ်စနစ်တစ်ခုခုနှင့် ငွေလွဲမည် ဆိုပါက အောက်ဖော်ပြပ် ဘဏ်နံပါတ် များသို့ငွေလွဲပေးပို့နိုင်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let kbzIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "kbz")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let kbzAccLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "KBZ Account Number\n2623 0102 1051 03101"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var kbzCopyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("COPY", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.tintColor = UIColor.white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(kbzbtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func kbzbtnClick(){
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "2623 0102 1051 03101"
        self.paymentTransferVC?.exchangeRate.payment_gateway = "kbz"
        self.paymentTransferVC?.showAlert(title: "Copied", message: "2623 0102 1051 03101")
    }
    
    let cbIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "cb")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let cbAccLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "CB Account Number\n0107 6001 0004 7608"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var cbCopyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("COPY", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.tintColor = UIColor.white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(cbBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func cbBtnClick(){
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "0107 6001 0004 7608"
        self.paymentTransferVC?.exchangeRate.payment_gateway = "cb"
        self.paymentTransferVC?.showAlert(title: "Copied", message: "0107 6001 0004 7608")
    }
    
    let ayaIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "aya")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let ayaAccLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "AYA Account Number\n0002 1190 1148 1712"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var ayaCopyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("COPY", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.tintColor = UIColor.white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(ayaBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func ayaBtnClick(){
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "0002 1190 1148 1712"
        self.paymentTransferVC?.exchangeRate.payment_gateway = "aya"
        self.paymentTransferVC?.showAlert(title: "Copied", message: "0002 1190 1148 1712")
    }
    
    let infoLabel2: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type2
        lbl.text = "Mobile Banking ဖြင့် ငွေလွှဲရာတွင် မည်သူမည်ဝါဖြစ်ကြောင်း သိရှိရန် မှတ်ချက်တွင် လူကြီးမင်း၏ ဖုန်းနံပါတ်ကို အင်္ဂလိပ်စာလုံးဖြင့် ရေးပေးပါရန် မေတ္တာရပ်ခံ အပ်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let infoLabel3: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "ငွေလွှဲပြီးပါက Screenshot ကို အောက်ပါတို့မှတဆင့်  ပေးပို့ထားနိုင်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let mailIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-gmail")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let mailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "info@myancare.org"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let viberIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-viber")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let viberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "09 4445555564"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let fbIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-facebook")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let fbLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "MyanCare Messenger"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let infoLabel4: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "အဆင်မပြေမှုများရှိပါက အောက်ပါဖုန်းနံပါတ်များသို့ မနက် ၉ နာရီမှ ၆ နာရီအတွင်း ပိတ်ရက်မရှိ ဆက်သွယ်နိုင်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let phoneIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-phone")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let phoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type1
        lbl.text = "09 79911 5566, 09 79922 5566"
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    func setupViews(){
        addSubview(infoLabel)
        
        addSubview(kbzIcon)
        addSubview(kbzAccLabel)
        addSubview(kbzCopyBtn)
        
        addSubview(cbIcon)
        addSubview(cbAccLabel)
        addSubview(cbCopyBtn)
        
        addSubview(ayaIcon)
        addSubview(ayaAccLabel)
        addSubview(ayaCopyBtn)
        
        addSubview(infoLabel2)
        addSubview(infoLabel3)
        
        addSubview(mailIcon)
        addSubview(mailLabel)
        addSubview(viberIcon)
        addSubview(viberLabel)
        addSubview(fbIcon)
        addSubview(fbLabel)
        
        addSubview(infoLabel4)
        addSubview(phoneLabel)
        addSubview(phoneIcon)
        
        infoLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        kbzIcon.anchor(infoLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        kbzCopyBtn.anchor(kbzIcon.topAnchor, left: nil, bottom: kbzIcon.bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 20, widthConstant: 70, heightConstant: 0)
        kbzAccLabel.anchor(kbzIcon.topAnchor, left: kbzIcon.rightAnchor, bottom: kbzIcon.bottomAnchor, right: kbzCopyBtn.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        cbIcon.anchor(kbzIcon.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        cbCopyBtn.anchor(cbIcon.topAnchor, left: nil, bottom: cbIcon.bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 20, widthConstant: 70, heightConstant: 0)
        cbAccLabel.anchor(cbIcon.topAnchor, left: cbIcon.rightAnchor, bottom: cbIcon.bottomAnchor, right: cbCopyBtn.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        ayaIcon.anchor(cbIcon.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        ayaCopyBtn.anchor(ayaIcon.topAnchor, left: nil, bottom: ayaIcon.bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 20, widthConstant: 70, heightConstant: 0)
        ayaAccLabel.anchor(ayaIcon.topAnchor, left: ayaIcon.rightAnchor, bottom: ayaIcon.bottomAnchor, right: ayaCopyBtn.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        infoLabel2.anchor(ayaIcon.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        infoLabel3.anchor(infoLabel2.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        mailLabel.anchor(infoLabel3.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        mailIcon.anchor(mailLabel.topAnchor, left: nil, bottom: nil, right: mailLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        mailLabel.anchorCenterXToSuperview()
        
        viberLabel.anchor(mailLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        viberIcon.anchor(viberLabel.topAnchor, left: nil, bottom: nil, right: viberLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        viberLabel.anchorCenterXToSuperview()
        
        fbLabel.anchor(viberLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        fbIcon.anchor(fbLabel.topAnchor, left: nil, bottom: nil, right: fbLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        fbLabel.anchorCenterXToSuperview()
        
        infoLabel4.anchor(fbLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        phoneLabel.anchor(infoLabel4.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        phoneIcon.anchor(phoneLabel.topAnchor, left: nil, bottom: nil, right: phoneLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        phoneLabel.anchorCenterXToSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
