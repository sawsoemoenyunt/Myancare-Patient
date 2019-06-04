//
//  AppointmentDetailVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Sinch
import Alamofire
import NVActivityIndicatorView

enum AppointmentChangeType{
    case reject
    case accept
    case cancel
    case reschedule
}

var appointment_EndTime_MilliSecond = 0

class AppointmentDetailVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var appointmentData = AppointmentModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return cv
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Close".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.lightGray
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var closeBtn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Close".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.lightGray
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var rejectBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("REJECT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var acceptBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("ACCEPT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(acceptBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func acceptBtnClick(){
        self.navigationController?.pushViewController(RescheduleAppointmentVC(), animated: true)
    }
    
    lazy var startChatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("START CHAT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRetryCompleteAlertAction), name: Notification.Name.didReceiveNotiToShowConfirmRetryForFeedback, object: nil)
    }
    
    func setupViews(){
        self.title = "Appointment Detail"
        view.backgroundColor = UIColor.white
        
        collectionView.register(AppointmentDetailCell.self, forCellWithReuseIdentifier: cellID)
        
        setupButtons()
        
        let currentDate = Date()
        let appointmentEndDate = Date(milliseconds: appointmentData.slotEndTime!)
        
        if appointmentEndDate < currentDate {
            //close
            let v = view.safeAreaLayoutGuide
            view.addSubview(closeBtn2)
            closeBtn2.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        }
    }
    
    func setupButtons(){
        
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(rejectBtn)
        view.addSubview(acceptBtn)
        
        let v = view.safeAreaLayoutGuide
        let buttonWidth = view.frame.width/3
        
        switch appointmentData.booking_status{
        case .RESCHEDULE_BY_DOCTOR:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            rejectBtn.addTarget(self, action: #selector(reject), for: .touchUpInside)
            rejectBtn.setTitle("Reject".localized(), for: .normal)
            acceptBtn.addTarget(self, action: #selector(accept), for: .touchUpInside)
            acceptBtn.setTitle("Accept".localized(), for: .normal)
            break
        
        case .RESCHEDULE_BY_PATIENT:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2, heightConstant: 50)
            rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            rejectBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            rejectBtn.setTitle("Cancel".localized(), for: .normal)
            break
            
        case .PENDING:
            if (appointmentData.rescheduleBy?.lowercased().contains("patient"))!{
                closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2, heightConstant: 50)
                rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
                collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
                closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
                rejectBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
                rejectBtn.setTitle("Cancel".localized(), for: .normal)
                
            } else if (appointmentData.rescheduleBy?.lowercased().contains("doctor"))!{
                closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
                closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
                rejectBtn.addTarget(self, action: #selector(reject), for: .touchUpInside)
                rejectBtn.setTitle("Reject".localized(), for: .normal)
                acceptBtn.addTarget(self, action: #selector(accept), for: .touchUpInside)
                acceptBtn.setTitle("Accept".localized(), for: .normal)
                
            } else {
                closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
                collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
                closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
                rejectBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
                rejectBtn.setTitle("Cancel".localized(), for: .normal)
                acceptBtn.addTarget(self, action: #selector(reschedule), for: .touchUpInside)
                acceptBtn.setTitle("Reschedule".localized(), for: .normal)
            }
            
            break
            
        case .APPROVED:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2, heightConstant: 50)
            acceptBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            
            if appointmentData.type == "chat"{
                acceptBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
            } else {
                acceptBtn.addTarget(self, action: #selector(checkAppointment), for: .touchUpInside)
            }
            
            acceptBtn.setTitle("Start \(appointmentData.type!.capitalized.localized())", for: .normal)
            break
        
        case .COMPLETED:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            break

        default:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            break
        }
    }
    
    @objc func closeBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reject(){
        //reject doctor's reschedule
        changeAppointment(.reject)
    }
    
    @objc func accept(){
        //accept doctor's reschedule
        changeAppointment(.accept)
    }
    
    @objc func cancel(){
        //appointent cancel
        showConfirmActionSheet()
    }
    
    @objc func reschedule(){
        
        if (appointmentData.type?.lowercased().contains("chat"))!{
            self.showAlert(title: "Alert", message: "Chat cannot rescheulde!")
        } else {
            let rescheduleVC = RescheduleVC()
            rescheduleVC.appointmentData = self.appointmentData
                self.navigationController?.pushViewController(rescheduleVC, animated: true)
        }
    }
    
    /// funcion to initialize SINCH Client variable
    ///
    /// - Returns: return SINClient value
    func client() -> SINClient
    {
        return ((UIApplication.shared.delegate as? AppDelegate)?.client)!
    }
    
    ///start the conversation
    @objc func start(){
        
        var callerName = ""
        var callerID = ""
        var callerImage = ""
        var receiverName = ""
        var receiverID = ""
        var receiverImage = ""
        
        if let callName = appointmentData.patient?.object(forKey: "name") as? String{
            callerName = callName
        }
        
        if let callID = appointmentData.patient?.object(forKey: "id") as? String{
            callerID = callID
        }
        
        if let callImage = appointmentData.patient?.object(forKey: "image_url") as? String{
            callerImage = callImage
        }
        
        if let receiveName = appointmentData.doctor?.object(forKey: "name") as? String{
            receiverName = receiveName
        }
        
        if let receiveID = appointmentData.doctor?.object(forKey: "id") as? String{
            receiverID = receiveID
        }
        
        if let receiveImage = appointmentData.doctor?.object(forKey: "image_url") as? String{
            receiverImage = receiveImage
        }
        
        //set appointment end time for call drop
        appointment_EndTime_MilliSecond = appointmentData.slotEndTime!
        print("Appointment endtime \(appointment_EndTime_MilliSecond)")
        
        //start conversation chat, voice, video
        let myDictOfDict = [
            "CALLER_NAME" : callerName,
            "CALL_ID" : callerID,
            "CALLER_IMAGE" : callerImage,
            "RECEIVER_NAME" : receiverName,
            "RECEIVER_IMAGE" : receiverImage,
            "APPOINTMENT_ID" : appointmentData.id
        ]
        
        switch appointmentData.type?.lowercased() {
        case "chat":
            //start chat conversation with doctor
            let layout = UICollectionViewFlowLayout()
            let homeVC = HomeViewController(collectionViewLayout:layout)
            let navController = UINavigationController(rootViewController: homeVC)
            homeVC.pushToVC(vc: ChatListVC())
            UtilityClass.changeRootViewController(with: navController)
            
        case "voice":
            //call voice
            if(self.client().isStarted())
            {
                SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentData.id!, eventType: SocketManageCallEventKeyword.callEventPatientCall.rawValue, callDuration: 0)
                
                weak var call: SINCall? = self.client().call().callUser(withId:receiverID,headers: myDictOfDict as [AnyHashable : Any])
                
                ((UIApplication.shared.delegate as? AppDelegate)?.callKitProvider)?.reportNewOutgoingCall(call)
            }
        
        case "video":
            //call video
            print("video call")
            if(self.client().isStarted())
            {
                SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentData.id!, eventType: SocketManageCallEventKeyword.callEventPatientCall.rawValue, callDuration: 0)
                
                weak var call: SINCall? = self.client().call().callUserVideo(withId:receiverID, headers: myDictOfDict as [AnyHashable : Any])
                
                ((UIApplication.shared.delegate as? AppDelegate)?.callKitProvider)?.reportNewOutgoingCall(call)
            }
        default:
            break
        }
    }
    
    func showConfirmActionSheet(){
        let actionSheet = UIAlertController(title: "Please confirm to cancel appointment", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.cancelAppointment()
        }
        
        actionSheet.addAction(confirmBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func showRetryCompleteAlertAction(){
        let alert = UIAlertController(title: "Call Ended", message: "Would you like to retry or complete?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Complete", style: UIAlertAction.Style.default, handler: { (action) in
            let patientFeedbackVC = PatientFeedbackVC()
            
            if let patientID = self.appointmentData.patient?.object(forKey: "_id") as? String{
                patientFeedbackVC.patientID = patientID
            }
            if let doctorID = self.appointmentData.doctor?.object(forKey: "_id") as? String{
                patientFeedbackVC.doctorID = doctorID
            }
                
            self.navigationController?.pushViewController(patientFeedbackVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (action) in
//            self.checkAppointment()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension AppointmentDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppointmentDetailCell
        cell.appointmentData = self.appointmentData
        cell.appointmentDetailVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedReasonHeight = self.view.calculateHeightofTextView(dummyText: self.appointmentData.reason!, fontSize: 16, viewWdith: self.view.frame.width)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height + estimatedReasonHeight + 220)
    }
}

extension AppointmentDetailVC{
    
    @objc func checkAppointment(){
        self.startAnimating()
        
        let url = EndPoints.checkAppointment(self.appointmentData.id!).path
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            switch response.result{
            case .success:
                let statusCode = response.response?.statusCode
                if statusCode == 201 || statusCode == 200{
                    if let responeData = response.result.value as? NSDictionary{
                        if let isStart = responeData.object(forKey: "start") as? Bool{
                            print("isstart : \(isStart)")
                            
                            if isStart{
                                //allow to start
                                self.start()
                            } else {
                                if let requireTime = responeData.object(forKey: "requireTime") as? Int{
                                    let currentTimeInMilli = UtilityClass.currentTimeInMilliSeconds() + requireTime
                                    let dt : UnixTime = currentTimeInMilli / 1000
                                    //do some
                                    self.showAlert(title: "Alert", message: "Consulation can start at \(dt.dateTime).")
                                }
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func changeAppointment(_ type:AppointmentChangeType){
        
        self.startAnimating()
        
        var url = URL(string: "")
        
        switch type {
        case .accept:
            url = EndPoints.setAppointmentAccept.path
        case .cancel:
            url = EndPoints.setAppointmentCancel.path
        default:
            url = EndPoints.setAppointmentReject.path
        }
        
        let params = ["id" : "\(appointmentData.id!)"]
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url ?? "", method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            self.stopAnimating()
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    
                    self.showAlert(title: "Success", message: "Successfully \(type) this appointment!")
                    
                    if let responseDict = response.result.value as? [String:Any]{
                        let appointment = AppointmentModel()
                        appointment.updateModleUsingDict(responseDict)
                        self.appointmentData = appointment
                        
                        //reload view
                        self.collectionView.reloadData()
                        self.viewDidLoad()
                        self.viewWillAppear(true)
                    }
                } else {
                    self.showAlert(title: "Error occured", message: "Failed to process your request!")
                }
                
            case .failure(let error):
                self.showAlert(title: "Error occured", message: "Failed to process your request!")
                print("\(error)")
            }
        }
    }
    
    func cancelAppointment(){
        
        self.startAnimating()
        
        let url = EndPoints.cancelAppointment.path
        
        let params = ["id" : "\(appointmentData.id!)"]
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            self.stopAnimating()
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    
                    self.showAlert(title: "Success", message: "Successfully cancel this appointment!")
                    
                    if let responseDict = response.result.value as? [String:Any]{
                        let appointment = AppointmentModel()
                        appointment.updateModleUsingDict(responseDict)
                        self.appointmentData = appointment
                        
                        //reload view
                        self.collectionView.reloadData()
                        self.viewDidLoad()
                        self.viewWillAppear(true)
                    }
                } else {
                    self.showAlert(title: "Error occured", message: "Failed to process your request!")
                }
                
            case .failure(let error):
                self.showAlert(title: "Error occured", message: "Failed to process your request!")
                print("\(error)")
            }
        }
    }
}


