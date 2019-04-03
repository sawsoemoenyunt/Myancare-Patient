//
//  SINCallKitProvider.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import CallKit
import Sinch

private func SINGetCallEndedReason(cause: SINCallEndCause) -> CXCallEndedReason
{
    switch cause
    {
        
    case SINCallEndCause.error:
        return .failed
        
    case SINCallEndCause.denied:
        return .remoteEnded
        
    case SINCallEndCause.hungUp:
        // This mapping is not really correct, as SINCallEndCauseHungUp is the end case also when the local peer ended the
        // call.
        return .remoteEnded
        
    case SINCallEndCause.timeout:
        return .unanswered
        
    case SINCallEndCause.canceled:
        return .unanswered
        
    case SINCallEndCause.noAnswer:
        return .unanswered
        
    case SINCallEndCause.otherDeviceAnswered:
        return .unanswered
        
    default:
        break
    }
    
    return .failed
}

class SINCallKitProvider: NSObject, CXProviderDelegate {
    
    weak var _client: SINClient?
    var _provider: CXProvider?
    var _acDelegate: AudioControllerDelegate?
    var _calls = [UUID: SINCall]()
    var _muted = false
    
    convenience init(client: SINClient?)
    {
        self.init()
        
        _client = client
        _muted = false
        
        _acDelegate = AudioControllerDelegate()
        
        _client?.audioController().delegate = _acDelegate
        
        let config = CXProviderConfiguration(localizedName: "MyanCare")
        config.iconTemplateImageData = UIImage(named: "pablo-image")?.jpegData(compressionQuality: 1)
        config.supportsVideo = true;
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        
        _provider = CXProvider(configuration: config)
        _provider?.setDelegate(self, queue: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callDidEnd(_:)), name: NSNotification.Name.SINCallDidEnd, object: nil)
    }
    
    func reportNewIncomingCall(_ call: SINCall?)
    {
        let dicData = call?.headers
        print(" calling user headers====== \(String(describing: dicData!))")
        
        let nameCallee : NSString
        var pushData = NSDictionary()
        var pushDict = NSDictionary()
        
        if((userDefaults.object(forKey: "pushUserInfo")) != nil)
        {
            pushData = userDefaults.object(forKey: "pushUserInfo") as! NSDictionary
            pushDict = pushData["public_headers"] as! NSDictionary
        }
        
        if (dicData != nil && !(dicData?.isEmpty)!)
        {
            nameCallee = dicData!["CALLER_NAME"] as! String as NSString
        }
        else if(pushDict != nil)
        {
            nameCallee = pushDict["CALLER_NAME"] as! String as NSString
        }
        else
        {
            nameCallee = call?.remoteUserId as! String as NSString
        }
        
        let update = CXCallUpdate()
        if (call?.details.isVideoOffered)!
        {
            update.hasVideo = true
        }
        else
        {
            update.hasVideo = false
        }
        
        update.remoteHandle = CXHandle(type: .generic, value: nameCallee as String )
        
        if let anId = UUID(uuidString: call?.callId ?? "")
        {
            _provider?.reportNewIncomingCall(with: anId, update: update, completion: {(_ error: Error?) -> Void in
                
                if error == nil
                {
                    self.addNewCall(call)
                }
            })
        }
    }
    
    /// function called when there is a new outgoing call
    ///
    /// - Parameter call: sinch call reference
    func reportNewOutgoingCall(_ call: SINCall?)
    {
        let dicData = call?.headers
        print(" outgoing user headers====== \(dicData ?? [:])")
        
        let nameCallee : String
        if (dicData != nil && !(dicData?.isEmpty)!)
        {
            nameCallee = (dicData!["RECEIVER_NAME"] as? String)!
        }
        else
        {
            nameCallee = (call?.remoteUserId)!
        }
        
        let callHandle = CXHandle(type: .generic, value: nameCallee)
        let controller = CXCallController()
        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(uuidString: call?.callId ?? "")!, handle: callHandle))
        
        controller.request(transaction, completion: { error in
            
            if error == nil
            {
                let update = CXCallUpdate()
                update.remoteHandle = callHandle
                update.supportsDTMF = true
                update.supportsHolding = false
                update.supportsGrouping = false
                update.supportsUngrouping = false
                
                if (call?.details.isVideoOffered)!
                {
                    update.hasVideo = true
                }
                else
                {
                    update.hasVideo = false
                }
                
                self.addNewCall(call)
                self._provider?.reportCall(with: UUID(uuidString: (call?.callId)!)!, updated: update)
            }
        })
    }
    
    func addNewCall(_ call: SINCall?)
    {
        print("addNewCall: Adding call: \(call?.callId ?? "")")
        
        _calls[UUID (uuidString: call!.callId)!] = call!
    }
    
    // Handle cancel/bye event initiated by either caller or callee
    
    @objc  func callDidEnd(_ notification: Notification?)
    {
        let call = notification?.userInfo![SINCallKey] as? SINCall
        if call != nil
        {
            if let anId = UUID(uuidString: call?.callId ?? "")
            {
                _provider?.reportCall(with: anId, endedAt: call?.details.endedTime, reason: SINGetCallEndedReason(cause: (call?.details.endCause)!))
                
            }
        }
        else
        {
            print("WARNING: No Call was reported as ended on SINCallDidEndNotification")
        }
        
        if callExists(call?.callId)
        {
            print("callDidEnd, Removing call: \(call?.callId ?? "")")
            _calls.removeValue(forKey: UUID(uuidString: call?.callId ?? "")!)
        }
    }
    
    func callExists(_ callId: String?) -> Bool
    {
        if _calls.isEmpty
        {
            return false
        }
        
        guard let _ = _calls[UUID (uuidString: callId!)!] else {
            return false
        }
        
        return true
    }
    
    func activeCalls() -> [SINCall]?
    {
        return _calls.compactMap{$0.value}
//        return _calls.flatMap{$0.value}
    }
    
    func currentEstablishedCall() -> SINCall?
    {
        if let calls = activeCalls(), !calls.isEmpty, calls.first!.state == .established
        {
            return calls[0]
        }
        
        return nil
    }
    
    // MARK: - CXProviderDelegate
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession)
    {
        _client?.call().provider(provider, didActivate: audioSession)
    }
    
    func call(for action: CXCallAction?) -> SINCall?
    {
        let call = _calls[(action?.callUUID)!]
        
        if call == nil
        {
            print("WARNING: No call found for \(String(describing: action?.callUUID))")
        }
        
        return call
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction)
    {
        
        call(for: action)?.answer()
        
        guard let appD = appDelegate as? AppDelegate else {
            return
        }
        
        let topController = appD.window?.visibleViewController()
        let call1 = _calls[(action.callUUID)]
        
        if (call1?.details.isVideoOffered)! {
            let videoCallHandlingVc = VideoCallHandlingVC()
            videoCallHandlingVc.setCall(call1!)
            topController?.navigationController?.pushViewController (videoCallHandlingVc, animated: true)
            
        } else {
            let voiceCallHandlingVc = VoiceCallHandlingVC()
            voiceCallHandlingVc.setCall(call1!)
            topController?.present(voiceCallHandlingVc, animated: true, completion: nil)
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction)
    {
        DispatchQueue.main.async
            {
                self.call(for: action)?.hangup()
                action.fulfill()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction)
    {
        print("-[CXProviderDelegate performSetMutedCallAction:]")
        
        if (_acDelegate?.muted)!
        {
            _client?.audioController().unmute()
        }
        else
        {
            _client?.audioController().mute()
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession)
    {
        print("-[CXProviderDelegate didDeactivateAudioSession:]")
    }
    
    func providerDidReset(_ provider: CXProvider)
    {
        print("-[CXProviderDelegate providerDidReset:]")
    }
    
    /// delegate method of cxprovider -> perform action -> start call
    ///
    /// - Parameters:
    ///   - provider: CXProvider reference
    ///   - action: CXStartCallAction reference
    func provider(_ provider: CXProvider, perform action: CXStartCallAction)
    {
        print("Provider performs the start call action")
        
        guard let appD = appDelegate as? AppDelegate else {
            return
        }
        
        let topController = appD.window?.visibleViewController()
        
        let date = Date()
        self._provider?.reportOutgoingCall(with: action.callUUID, startedConnectingAt: date)
        
        let call1 = _calls[(action.callUUID)]
        
        if (call1?.details.isVideoOffered)!
        {
            //video call
            let videoCallHandlingVC = VideoCallHandlingVC()
            videoCallHandlingVC.setCall(call1!)
            
            topController?.present(videoCallHandlingVC, animated: false, completion:
                {
                    DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5)
                    {
                        self._provider?.reportOutgoingCall(with: action.callUUID, connectedAt:date)
                        action .fulfill()
                    }
            })
        }
        else
        {
            let callHandlingVC = VoiceCallHandlingVC()
            callHandlingVC.setCall(call1!)
            
            topController?.present(callHandlingVC, animated: false, completion:
                {
                    DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5)
                    {
                        self._provider?.reportOutgoingCall(with: action.callUUID, connectedAt:date)
                        action .fulfill()
                    }
            })
        }
    }
}
