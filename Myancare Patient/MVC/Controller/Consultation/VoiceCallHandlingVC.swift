//
//  VoiceCallHandlingVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Sinch
import AVKit
import AudioToolbox

class VoiceCallHandlingVC: SINUIViewController, SINCallDelegate {
    
    var totalSecond = 0
    
    /// Bool Variable - Identify Mute/Unmute State
    var isMute : Bool = false
    /// Bool Variable - Identify Speaker On/Off State
    var isSpeaker : Bool = false
    
    /// String Variable - Store Appointment ID
    var appointmentID : String = ""
    /// String Variable - Store Doctor ID
    var doctorID : String = ""
    
    /// Timer Variable - Store Call Duration Timing
    var durationTimer: Timer?
    
    /// SINCall Refrence Varible - Handle All Calling Event
    weak var call: SINCall?
    
    /// Sinch Audio Controller
    ///
    /// - Returns: SinAudio Contoller
    func audioController() -> SINAudioController
    {
        return (((UIApplication.shared.delegate as? AppDelegate)?.client)?.audioController())!
    }
    
    /// Sinch SetCall Method
    ///
    /// - Parameter call: SInCall Refrence
    func setCall(_ call: SINCall)
    {
        self.call = call
        self.call?.delegate = self
    }
    
    let doctorImage: CachedImageView = {
        let img = CachedImageView()
        img.image = UIImage(named: "pablo-image")
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 60 //size 120
        img.clipsToBounds = true
        return img
    }()
    
    let doctornamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Kaung Mon"
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textAlignment = .center
        return lbl
    }()
    
    let callinglabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Calling..."
        lbl.font = UIFont.MyanCareFont.type2
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
        btn.addTarget(self, action: #selector(hangup(_:)), for: .touchUpInside)
        return btn
    }()
    
    var hangupButtonLeftConstraint:NSLayoutConstraint?
    var muteButtonRightConstraint:NSLayoutConstraint?
    var timer = Timer()
    
    lazy var muteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-microphone").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(muteUnmute(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var speakerBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-mute").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(speaker(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hangup(_:)), name: Notification.Name.didReceiveAppointmentTimeUp, object: nil)
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        view.addSubview(doctorImage)
        view.addSubview(doctornamelabel)
        view.addSubview(callinglabel)
        speakerBtn.tag = 102
        view.addSubview(speakerBtn)
        muteBtn.tag = 101
        view.addSubview(muteBtn)
        hangupBtn.tag = 100
        view.addSubview(hangupBtn)
        
        
        let v = view.safeAreaLayoutGuide
        doctorImage.anchor(v.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 120)
        doctorImage.anchorCenterXToSuperview()
        doctornamelabel.anchor(doctorImage.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        callinglabel.anchor(doctornamelabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        hangupBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        hangupBtn.anchorCenterXToSuperview()
        hangupButtonLeftConstraint = speakerBtn.anchorWithReturnAnchors(nil, left: hangupBtn.rightAnchor, bottom: hangupBtn.bottomAnchor, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)[0]
        muteButtonRightConstraint = muteBtn.anchorWithReturnAnchors(nil, left: nil, bottom: hangupBtn.bottomAnchor, right: hangupBtn.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 70, heightConstant: 70)[1]
    }
}

extension VoiceCallHandlingVC{
    /// Audio Route Change Listener to Change Speaker On/Off state
    ///
    /// - Parameter notification:
    @objc dynamic private func audioRouteChangeListener1(notification : NSNotification){
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
            
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            
            if(isSpeaker){
                self.audioController().enableSpeaker()
            } else {
                self.audioController().disableSpeaker()
            }
            print("headphone plugged in")
            
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            
            if(isSpeaker){
                self.audioController().enableSpeaker()
            } else {
                self.audioController().disableSpeaker()
            }
            print("headphone pulled out")
            
        default:
            break
        }
    }
    
    /// Call Dimissed Method
    func callDismissed(){
        self.call?.hangup()
        
        dismiss(animated: true)
        {
            self.audioController().stopPlayingSoundFile()
            
            self.stopCallDurationTimer()
            
            self.audioController().disableSpeaker()
            
            //show review vc
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.audioController().unmute()
        
        if self.call?.direction == SINCallDirection.incoming{
            let dicData = self.call?.headers
            print(" calling user headers====== \(String(describing: dicData!))")
            
            if (dicData != nil && !(dicData?.isEmpty)!){
                appointmentID = dicData!["APPOINTMENT_ID"] as! String
            }
            
            var pushData = NSDictionary()
            var pushDict = NSDictionary()
            
            if((userDefaults.object(forKey: "pushUserInfo")) != nil){
                pushData = userDefaults.object(forKey: "pushUserInfo") as! NSDictionary
                pushDict = pushData["public_headers"] as! NSDictionary
                appointmentID = pushDict["APPOINTMENT_ID"] as! String
            }
            
            print("pushData = ", pushData)
            print("pushDict = ", pushDict)
            print("appointmentID = ", appointmentID)
            
            if (dicData != nil && !(dicData?.isEmpty)!){
                self.doctornamelabel.text = dicData!["CALLER_NAME"] as? String
                self.doctorID = (dicData!["CALL_ID"] as? String)!
                
//                UIImage.loadImage((dicData!["CALLER_IMAGE"] as? String)!) { (image) in
//                    self.doctorImage.image = image
//                }
                self.doctorImage.loadImage(urlString: (dicData!["CALLER_IMAGE"] as? String)!)
                
            } else if(pushDict != nil){
                self.doctornamelabel.text = pushDict["CALLER_NAME"] as? String
                self.doctorID = (pushDict["CALL_ID"] as? String)!
                
//                UIImage.loadImage((dicData!["CALLER_IMAGE"] as? String)!) { (image) in
//                    self.doctorImage.image = image
//                }
                self.doctorImage.loadImage(urlString: (dicData!["CALLER_IMAGE"] as? String)!)
                
            } else{
                self.doctornamelabel.text = self.call?.remoteUserId
                self.doctorImage.image = UIImage(named: "no-image")
            }
            
        } else {
            let dicData = self.call?.headers
            print(" calling user headers====== \(dicData ?? [:])")
            
            if (dicData != nil && !(dicData?.isEmpty)!){
                appointmentID = dicData!["APPOINTMENT_ID"] as! String
            }
            
            if (dicData != nil){
                self.doctornamelabel.text = dicData!["CALLER_NAME"] as? String
                self.doctorID = (dicData!["CALL_ID"] as? String)!
                
                UIImage.loadImage((dicData!["CALLER_IMAGE"] as? String)!) { (image) in
                    self.doctorImage.image = image
                }
            } else {
                self.doctornamelabel.text = self.call?.remoteUserId
                self.doctorImage.image = UIImage(named: "no-image")
            }
        }
    }
    
    //MARK: - Sinch Call Fire Socket Event
    
    /// Sinch Socket Call Fire Event
    ///
    /// - Parameters:
    ///   - eventType: eventType - Video Call/ Voice Call
    ///   - appointmentID: Appointment ID
    func sinchSocketCallEvent(_ eventType:String, appointmentID: String){
        if !SocketManagerHandler.sharedInstance().isSocketConnected()
        {
            return
        }
        
//        SocketManagerHandler.sharedInstance().manageCallSocketEvent (callDuration, eventType: eventType, appointmentID: appointmentID) { (dataDict, statusCode) in
//        }
    }
    
    // MARK: - Call Actions
    
    /// When Click To Accept Button Event
    ///
    /// - Parameter sender: Accept Button Refrence
    @objc func accept(_ sender: Any){
        self.audioController().stopPlayingSoundFile()
        self.audioController().disableSpeaker()
        
//        sinchSocketCallEvent (SocketManageCallEventKeyword.callEventPatientPicked.rawValue, appointmentID: appointmentID)
        
        self.call?.answer()
    }
    
    /// Decline Button Clicked Event
    ///
    /// - Parameter sender: Decline Button Refrence
    @objc func decline(_ sender: Any){
        self.call?.hangup()
        self.audioController().disableSpeaker()
        
//        sinchSocketCallEvent (SocketManageCallEventKeyword.callEventPatientReject.rawValue, appointmentID: appointmentID)
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventPatientHangs.rawValue, callDuration: totalSecond)
        self.dismiss()
    }
    
    /// Hangup Button Clicked Event
    ///
    /// - Parameter sender: HangUp Button Refrence
    @objc func hangup(_ sender: Any){
        self.call?.hangup()
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventPatientHangs.rawValue, callDuration: totalSecond)
        
        dismiss(animated: true){
            self.audioController().stopPlayingSoundFile()
            self.stopCallDurationTimer()
            self.audioController().disableSpeaker()
            
            //show review vc
            NotificationCenter.default.post(name: Notification.Name.didReceiveNotiToShowConfirmRetryForFeedback, object: nil, userInfo: nil)
        }
    }
    
    /// Mute/Unmute Button Click Event
    ///
    /// - Parameter sender: Mute/UnMute Button Refrence
    @objc func muteUnmute(_ sender: Any){
        isMute = !isMute
        if(!isMute){
//            isMute = false
            self.audioController().unmute()
            self.muteBtn.setImage(#imageLiteral(resourceName: "icons8-microphone").withRenderingMode(.alwaysTemplate), for: .normal)
            
        } else {
//            isMute = true
            self.audioController().mute()
            self.muteBtn.setImage(#imageLiteral(resourceName: "icons8-no_microphone").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    /// Speaker On/Off Clicked Event
    ///
    /// - Parameter sender: Speaker On/Off Button Refrence
    @objc func speaker(_ sender: Any){
        isSpeaker = !isSpeaker
        if(isSpeaker)
        {
//            isSpeaker = false
            self.audioController().enableSpeaker()
            self.speakerBtn.setImage(#imageLiteral(resourceName: "icons8-speaker").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        else
        {
//            isSpeaker = true
            self.audioController().disableSpeaker()
            self.speakerBtn.setImage(#imageLiteral(resourceName: "icons8-mute").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    /// On Show Duration Timer When Call Is Initiated
    ///
    /// - Parameter unused: call timer
    @objc func onDurationTimer(_ unused: Timer){
        let duration = Int(Date().timeIntervalSince ((self.call?.details.establishedTime)!))
        self.setDuration(duration)
    }
    
    // MARK: - SINCallDelegate
    
    /// Sinch Call Delegate Methods
    /// Call Did Progress Event
    /// - Parameter call: SINCall Refrence
    func callDidProgress(_ call: SINCall){
        print("did Progress call detail ===== \(String(describing: self.call?.details))")
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventInitiated.rawValue, callDuration: totalSecond)
        
        self.setCallStatusText("ringing...")
        self.audioController().startPlayingSoundFile(path(forSound: "ringback"), loop: true)
    }
    
    /// Call Did Establised Method
    ///
    /// - Parameter call: SINCall Refrence
    func callDidEstablish(_ call: SINCall){
        print("did establish call detail ===== \(String(describing: self.call?.details))")
        
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventPatientCall.rawValue, callDuration: totalSecond)
        
        self.startCallDurationTimer(with: #selector(self.onDurationTimer(_:)))
        
        self.hangupBtn.isHidden = false
        
        self.audioController().stopPlayingSoundFile()
        self.audioController().disableSpeaker()
        
        self.speakerBtn.isHidden = false
        self.muteBtn.isHidden = false
    }
    
    /// Call Did End Event
    ///
    /// - Parameter call: SINCall Refrence
    func callDidEnd(_ call: SINCall){
        print("did end call detail ===== \(String(describing: self.call?.details))")
        
        SocketManagerHandler.sharedInstance().emitCallLog(appointmentID: appointmentID, eventType: SocketManageCallEventKeyword.callEventEnded.rawValue, callDuration: totalSecond)
        
        if isAppearing
        {
            setShouldDeferredDismiss(true)
            return
        }
        
        dismiss(animated: true)
        {
            self.audioController().stopPlayingSoundFile()
            
            self.stopCallDurationTimer()
            
            self.audioController().disableSpeaker()
            
            //show review vc
            NotificationCenter.default.post(name: Notification.Name.didReceiveNotiToShowConfirmRetryForFeedback, object: nil, userInfo: nil)
        }
    }
    
    // MARK: - Sounds
    
    func path(forSound soundName: String) -> String
    {
        let audioFileName = soundName
        
        let audioFilePath = Bundle.main.path(forResource: audioFileName, ofType: "wav")
        print(audioFilePath ?? "")
        
        return audioFilePath!
    }
    
    func setCallStatusText(_ text: String)
    {
        self.callinglabel.text = text
    }
    
    // MARK: - Buttons
//    func showButtons(_ buttons: UIButton)
//    {
//        if buttons == EButtonsBar.kButtonsAnswerDecline
//        {
//            answerButton.isHidden = false
//            declineButton.isHidden = false
//            endCallButton.isHidden = true
//            connectingLabel.isHidden = true
//        }
//        else if buttons == EButtonsBar.kButtonsHangup
//        {
//            endCallButton.isHidden = false
//            answerButton.isHidden = true
//            declineButton.isHidden = true
//            connectingLabel.isHidden = true
//        }
//        else if buttons == EButtonsBar.kButtonsWakenByCallKit
//        {
//            endCallButton.isHidden = true
//            answerButton.isHidden = true
//            declineButton.isHidden = true
//            connectingLabel.isHidden = false
//        }
//    }
    
    // MARK: - Duration
    func setDuration(_ seconds: Int)
    {
        totalSecond = seconds
        
        setCallStatusText(String(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60)))
        
        callDuration = String(seconds)
        
        if (seconds == 900)
        {
            self.call?.hangup()
            
            self.dismiss(animated: true)
            {
                self.audioController().stopPlayingSoundFile()
                
                self.stopCallDurationTimer()
                
                self.audioController().disableSpeaker()
                
                //show review vc
            }
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
