//
//  VideoCallHandlingVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Sinch

enum EButtonsBar
{
    case kButtonsAnswerDecline
    case kButtonsHangup
    case kButtonsWakenByCallKit
}

class VideoCallHandlingVC: SINUIViewController, SINCallDelegate {
    
    var totalSecond = 0
    var isMute : Bool = false
    var isDisableCamera : Bool = false
    var appointmentID : String = ""
    var doctorID : String = ""
    var durationTimer: Timer?
    weak var call: SINCall?
    
    func audioController() -> SINAudioController
    {
        return (((UIApplication.shared.delegate as? AppDelegate)?.client)?.audioController())!
    }
    
    func videoController() -> SINVideoController
    {
        return (((UIApplication.shared.delegate as? AppDelegate)?.client)?.videoController())!
    }
    
    func setCall(_ call: SINCall)
    {
        self.call = call
        self.call?.delegate = self
    }
    
    let doctorImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 60 //size 120
        img.clipsToBounds = true
        return img
    }()
    
    let doctornamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Kaung Mon"
        lbl.font = UIFont.mmFontBold(ofSize: 22)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let callinglabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ringing..."
        lbl.font = UIFont.mmFontBold(ofSize: 18)
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var hangupBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-call_disconnected").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.red
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(hangup), for: .touchUpInside)
        return btn
    }()
    
    lazy var localView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        return view
    }()
    
    let remoteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var hangupButtonLeftConstraint:NSLayoutConstraint?
    var muteButtonRightConstraint:NSLayoutConstraint?
    var doctorImageTopConstraint: NSLayoutConstraint?
    var localViewHeightConstraint: NSLayoutConstraint?
    var timer = Timer()
    
    @objc func hangupBtnClick(){
        timer.invalidate()
        callinglabel.text = "Call Ended "+callinglabel.text!
    }
    
    var min = 0
    var sec = 0
    @objc func timerAction(){
        sec = sec + 1
        
        if sec == 60 {
            min = min + 1
            sec = 0
        }
        
        let minuteString = String(min).count == 1 ? "0\(min)" : String(min)
        let secondString = String(sec).count == 1 ? "0\(sec)" : String(sec)
        callinglabel.text = minuteString+" : "+secondString
    }
    
    func animateViews(){
        
        hangupButtonLeftConstraint?.constant = 30
        muteButtonRightConstraint?.constant = -30
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    lazy var muteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("M", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(muteUnmute), for: .touchUpInside)
        return btn
    }()
    
    lazy var speakerBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-microphone").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(muteUnmute), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraFlipBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-rotate_camera").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(onSwitchCameraTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var someBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-video_call").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(localViewOnOff), for: .touchUpInside)
        return btn
    }()
    
    var localViewIsOn = true
    @objc func localViewOnOff(){
        
        if isDisableCamera{
            isDisableCamera = false
            videoController().localView()?.isHidden = false
            self.localView.isHidden = false
            self.someBtn.setImage(#imageLiteral(resourceName: "icons8-video_call").withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            isDisableCamera = true
            videoController().localView()?.isHidden = true
            self.localView.isHidden = true
            self.someBtn.setImage(#imageLiteral(resourceName: "icons8-no_video").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
//        if localViewIsOn {
//            localViewHeightConstraint?.constant = 0
//            localViewIsOn = false
////            someBtn.setTitle("HC", for: .normal)
//        } else {
//            localViewHeightConstraint?.constant = 190
//            localViewIsOn = true
////            someBtn.setTitle("SC", for: .normal)
//        }
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
    }
    
    let centerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondLayout()
        setupVideoController()
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(secondLayout), userInfo: nil, repeats: false)
        NotificationCenter.default.addObserver(self, selector: #selector(hangup), name: Notification.Name.didReceiveAppointmentTimeUp, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        videoController().localView().contentMode = .scaleAspectFill
        videoController().remoteView().contentMode = .scaleAspectFill
        
        self.localView.addSubview(videoController().localView())
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        doctorImage.tag = 103
        view.addSubview(doctorImage)
        doctornamelabel.tag = 102
        view.addSubview(doctornamelabel)
        callinglabel.tag = 101
        view.addSubview(callinglabel)
        hangupBtn.tag = 100
        view.addSubview(hangupBtn)
        
        
        let v = view.safeAreaLayoutGuide
        doctorImageTopConstraint = doctorImage.anchorWithReturnAnchors(v.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 120)[0]
        doctorImage.anchorCenterXToSuperview()
        doctornamelabel.anchor(doctorImage.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        callinglabel.anchor(doctornamelabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        hangupBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        hangupBtn.anchorCenterXToSuperview()
    }
    
    @objc func secondLayout(){
        
//        doctorImageTopConstraint?.constant = 100
        
        //animate view
        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//        }) { (true) in
//            //after animation
//        }
        
        //remove firt added views
//        view.viewWithTag(100)?.removeFromSuperview()
//        view.viewWithTag(101)?.removeFromSuperview()
//        view.viewWithTag(102)?.removeFromSuperview()
//        view.viewWithTag(103)?.removeFromSuperview()
        
        //add subviews
        view.addSubview(remoteView)
        view.addSubview(localView)
        view.addSubview(doctornamelabel)
        view.addSubview(callinglabel)
        view.addSubview(hangupBtn)
//        view.addSubview(muteBtn)
        view.addSubview(speakerBtn)
        view.addSubview(someBtn)
        view.addSubview(cameraFlipBtn)
        view.addSubview(centerView)
        
        let v = view.safeAreaLayoutGuide
        
        remoteView.fillSuperview()
        cameraFlipBtn.anchor(v.topAnchor, left: nil, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 46, heightConstant: 46)
        someBtn.anchor(v.topAnchor, left: nil, bottom: nil, right: cameraFlipBtn.leftAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 46, heightConstant: 46)
//        muteBtn.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 46, heightConstant: 46)
        localViewHeightConstraint = localView.anchorWithReturnAnchors(cameraFlipBtn.bottomAnchor, left: nil, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 140, heightConstant: 190).last
        callinglabel.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 130, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        doctornamelabel.anchor(nil, left: v.leftAnchor, bottom: callinglabel.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        centerView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 1)
        centerView.anchorCenterXToSuperview()
        hangupBtn.anchor(nil, left: centerView.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 30, rightConstant: 0, widthConstant: 56, heightConstant: 56)
        hangupBtn.layer.cornerRadius = 28
        speakerBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: centerView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 30, widthConstant: 56, heightConstant: 56)
        speakerBtn.layer.cornerRadius = 28
        
//        self.view.alpha = 0
        //animate subviews
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            self.view.alpha = 1
//        }, completion: nil)
        
        //start timer
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
}

extension VideoCallHandlingVC{
    
    func setupVideoController(){
        
        self.navigationController?.navigationBar.isHidden = true
        
        if (((UIApplication.shared.delegate as? AppDelegate)?.callKitProvider)?.callExists(self.call?.callId))!
        {
            if self.call?.state == SINCallState.established
            {
                self.startCallDurationTimer(with: #selector(onDurationTimer(_:)))
                self.showButtons(EButtonsBar.kButtonsHangup)
            }
            else
            {
                self.setCallStatusText("")
                self.showButtons(EButtonsBar.kButtonsWakenByCallKit)
            }
        }
        else
        {
            if self.call?.direction == SINCallDirection.incoming
            {
                self.cameraFlipBtn.isHidden = true
                self.muteBtn.isHidden = true
                self.setCallStatusText("incoming...")
                self.showButtons(EButtonsBar.kButtonsAnswerDecline)
                
                self.audioController().startPlayingSoundFile(path(forSound: "incoming"), loop: true)
            }
            else
            {
                self.cameraFlipBtn.isHidden = false
                self.muteBtn.isHidden = false
                self.setCallStatusText("calling...")
                
                self.showButtons(EButtonsBar.kButtonsHangup)
            }
        }
        
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if (currentRoute.outputs != nil)
        {
            for description in currentRoute.outputs
            {
                if (description.portType == AVAudioSession.Port.headphones)
                {
                    self.audioController().disableSpeaker()
                    print("headphone plugged in")
                }
                else
                {
                    self.audioController().enableSpeaker()
                    print("headphone pulled out")
                }
            }
        }
        else
        {
            print("requires connection to device")
        }
        
        //self.remoteVideoView.addSubview(videoController().localView())
//        self.localView.addSubview(videoController().localView())
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    /// function for call Dismissed
    func callDismissed()
    {
        self.call?.hangup()
        self.dismiss()
    }
    
    @objc dynamic private func audioRouteChangeListener (notification:NSNotification)
    {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason
        {
            
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            self.audioController().disableSpeaker()
            print("headphone plugged in")
            
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            self.audioController().enableSpeaker()
            print("headphone pulled out")
            
        default:
            break
        }
    }
    
    /// UIViewController Life Cycle Method
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
//        self.remoteView.isHidden = true
        // self.localVideoView.isHidden = true
        
        self.audioController().unmute()
        
        if self.call?.direction == SINCallDirection.incoming
        {
            let dicData = self.call?.headers
            print(" calling user headers====== \(dicData ?? [:])")
            
            var pushData = NSDictionary()
            var pushDict = NSDictionary()
            
            if((userDefaults.object(forKey: "pushUserInfo")) != nil)
            {
                pushData = userDefaults.object(forKey: "pushUserInfo") as! NSDictionary
                pushDict = pushData["public_headers"] as! NSDictionary
            }
            
            print(" calling user push data====== \(pushDict)")
            
            if (dicData != nil && !(dicData?.isEmpty)!)
            {
                self.doctornamelabel.text = dicData!["CALLER_NAME"] as? String
                
                if let image_url = dicData!["CALLER_IMAGE"] as? String{
                    UIImage.loadImage(image_url) { (image) in
                        self.doctorImage.image = image
                    }
                }
            }
            else if(pushDict != nil)
            {
                self.doctornamelabel.text = dicData!["CALLER_NAME"] as? String
                
                if let image_url = dicData!["CALLER_IMAGE"] as? String{
                    UIImage.loadImage(image_url) { (image) in
                        self.doctorImage.image = image
                    }
                }
            }
            else
            {
                self.doctornamelabel.text = self.call?.remoteUserId
                self.doctorImage.image = UIImage(named: "no-image")
                
            }
        }
        else
        {
            let dicData = self.call?.headers
            
            if (dicData != nil && !(dicData?.isEmpty)!)
            {
                appointmentID = dicData!["APPOINTMENT_ID"] as! String
            }
            
            print(" calling user headers====== \(dicData ?? [:])")
            
            if (dicData != nil)
            {
                self.doctornamelabel.text = dicData!["RECEIVER_NAME"] as? String
                
                if let image_url = dicData!["RECEIVER_IMAGE"] as? String{
                    UIImage.loadImage(image_url) { (image) in
                        self.doctorImage.image = image
                    }
                }
            }
            else
            {
                self.doctornamelabel.text = self.call?.remoteUserId
                self.doctorImage.image = UIImage(named: "no-image")
            }
        }
    }
    
    // MARK: - Call Actions
    
    /// action performed on accept call button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func accept()
    {
        self.audioController().stopPlayingSoundFile()
        //self.audioController().enableSpeaker()
        self.call?.answer()
    }
    
    /// action performed on decline call button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func decline()
    {
        self.call?.hangup()
        self.audioController().disableSpeaker()
        self.dismiss()
    }
    
    /// action performed on hangup call button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func hangup()
    {
        self.call?.hangup()
        self.dismiss(animated: true) {
            //show review vc
            NotificationCenter.default.post(name: Notification.Name.didReceiveNotiToShowConfirmRetryForFeedback, object: nil, userInfo: nil)
        }
    }
    
    /// action performed on mute/unmute call button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func muteUnmute()
    {
        if(isMute)
        {
            isMute = false
            self.audioController().unmute()
            self.speakerBtn.setImage(#imageLiteral(resourceName: "icons8-microphone").withRenderingMode(.alwaysTemplate), for: .normal)
//            self.muteBtn.setTitle("Mute", for: .normal)
        }
        else
        {
            isMute = true
            self.audioController().mute()
            self.speakerBtn.setImage(#imageLiteral(resourceName: "icons8-no_microphone").withRenderingMode(.alwaysTemplate), for: .normal)
//            self.muteBtn.setTitle("Unmute", for: .normal)
        }
    }
    
    /// action performed on switch camera button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func onSwitchCameraTapped()
    {
        let current: AVCaptureDevice.Position = self.videoController().captureDevicePosition
        self.videoController().captureDevicePosition = SINToggleCaptureDevicePosition(current)
    }
    
    /// action performed on full screen button click
    ///
    /// - Parameter sender: uibutton reference
    @objc func onFullScreenTapped(_ sender: Any)
    {
        let _: UIView? = (sender as AnyObject).view
    }
    
    /// function to start call duration timer
    ///
    /// - Parameter unused: Timer reference
    @objc func onDurationTimer(_ unused: Timer)
    {
        let duration = Int(Date().timeIntervalSince ((self.call?.details.establishedTime)!))
        self.setDuration(duration)
        self.totalSecond = duration
    }
    
    //MARK: - Doctor Call Fire Socket Event
    
    /// function to fire doctor Call Event
    ///
    /// - Parameter eventType: event type - video
    func doctorCallEvent(_ eventType:String)
    {
        if !SocketManagerHandler.sharedInstance().isSocketConnected()
        {
            return
        }
        
//        SocketManagerHandler.sharedInstance().manageCallSocketEvent (callDuration, eventType: eventType, appointmentID: appointmentID) { (dataDict, statusCode) in
//
//        }
    }
    
    // MARK: - SINCallDelegate
    
    /// SINCallDelegate method -> call Did Progressed
    ///
    /// - Parameter call: SINCall reference
    func callDidProgress(_ call: SINCall)
    {
        print("did Progress call detail ===== \(String(describing: self.call?.details))")
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventPatientCall.rawValue, callDuration: totalSecond)
        
//        doctorCallEvent (SocketManageCallEventKeyword.callEventInitiated.rawValue)
        
        self.callinglabel.textColor = UIColor.MyanCareColor.darkGray
        self.doctornamelabel.textColor = UIColor.MyanCareColor.darkGray
        self.setCallStatusText("ringing...")
        self.audioController().startPlayingSoundFile(path(forSound: "ringback"), loop: true)
    }
    
    /// SINCallDelegate method -> call Did established
    ///
    /// - Parameter call: SINCall reference
    func callDidEstablish(_ call: SINCall)
    {
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventDoctorPicked.rawValue, callDuration: totalSecond)
        
        self.callinglabel.textColor = UIColor.white
        self.doctornamelabel.textColor = UIColor.white
        
        self.remoteView.isHidden = false
        //   self.localVideoView.isHidden = false
//        self.doctornamelabel.isHidden = true
//        self.doctorImage.isHidden = true
//        self.callinglabel.isHidden = true
        
        print("did establish call detail ===== \(String(describing: self.call?.details))")
        
        self.startCallDurationTimer(with: #selector(self.onDurationTimer(_:)))
        
//        self.showButtons(EButtonsBar.kButtonsHangup)
        self.audioController().stopPlayingSoundFile()
        
        //self.audioController().enableSpeaker()
        self.cameraFlipBtn.isHidden = false
        self.muteBtn.isHidden = false
    }
    
    /// SINCallDelegate method -> call Did ended
    ///
    /// - Parameter call: SINCall reference
    func callDidEnd(_ call: SINCall)
    {
        print("did end call detail ===== \(String(describing: self.call?.details))")
        
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventPatientHangs.rawValue, callDuration: totalSecond)
        
        dismiss(animated: true) {
            self.audioController().stopPlayingSoundFile()
            self.stopCallDurationTimer()
            self.videoController().remoteView().removeFromSuperview()
            self.audioController().disableSpeaker()
            NotificationCenter.default.post(name: Notification.Name.didReceiveNotiToShowConfirmRetryForFeedback, object: nil, userInfo: nil)
        }
        self.dismiss()
        
//        doctorCallEvent (SocketManageCallEventKeyword.callEventDoctorHangs.rawValue)
        
    }
    
    /// SINCallDelegate method -> call Did add video track
    ///
    /// - Parameter call: SINCall reference
    func callDidAddVideoTrack(_ call: SINCall)
    {
        self.remoteView.addSubview(videoController().remoteView())
    }
    
    // MARK: - Sounds
    
    /// function to get path name for sound file
    ///
    /// - Parameter soundName: sound name string
    /// - Returns: string value
    func path(forSound soundName: String) -> String
    {
        let audioFileName = soundName
        
        let audioFilePath = Bundle.main.path(forResource: audioFileName, ofType: "wav")
        print(audioFilePath ?? "")
        
        return audioFilePath!
    }
}

extension VideoCallHandlingVC
{
    func setCallStatusText(_ text: String)
    {
        callinglabel.text = text
    }
    
    // MARK: - Buttons
    func showButtons(_ buttons: EButtonsBar)
    {
        hangupBtn.isHidden = false
        muteBtn.isHidden = false
        speakerBtn.isHidden = false
    }
    
    // MARK: - Duration
    func setDuration(_ seconds: Int)
    {
        callDuration = String(seconds)
        
        setCallStatusText(String(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60)))
        
        if seconds == 6
        {
//            doctorCallProgress (SocketManageCallEventKeyword.callEventCallProgress.rawValue)
        }
        
        if (seconds == 900)
        {
            self.call?.hangup()
            self.dismiss()
            
        }
        
        let current_milliSecond = Date().millisecondsSince1970
        
        if current_milliSecond == appointment_EndTime_MilliSecond{
            self.call?.hangup()
            self.dismiss()
        } else if current_milliSecond == appointment_EndTime_MilliSecond - 120000{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.showAlert(title: "Warning", message: "Consultation will end in next 2 minutes!")
        }
    }
    
    //MARK: - Doctor Call Progress Socket Event
    func doctorCallProgress(_ eventType:String)
    {
        if !SocketManagerHandler.sharedInstance().isSocketConnected()
        {
            return
        }
        
//        SocketManagerHandler.sharedInstance().manageCallSocketEvent (callDuration, eventType: eventType, appointmentID: appointmentID) { (dataDict, statusCode) in
        
//        }
    }
    
    @objc func internal_updateDuration(_ timer: Timer)
    {
        let selector: Selector = NSSelectorFromString(timer.userInfo as! String)
        
        if responds(to: selector)
        {
            //clang diagnostic push
            //clang diagnostic ignored "-Warc-performSelector-leaks"
            perform(selector, with: timer)
            //clang diagnostic pop
        }
    }
    
    func startCallDurationTimer(with sel: Selector)
    {
        let selectorAsString: String = NSStringFromSelector(sel)
        
        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.internal_updateDuration(_:)), userInfo: selectorAsString, repeats: true)
    }
    
    func stopCallDurationTimer()
    {
        durationTimer?.invalidate()
        durationTimer = nil
    }
}
