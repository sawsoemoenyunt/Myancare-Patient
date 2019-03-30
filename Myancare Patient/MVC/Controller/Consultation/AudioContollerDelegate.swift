//
//  AudioContollerDelegate.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//


import UIKit
import Sinch

class AudioControllerDelegate: NSObject, SINAudioControllerDelegate {
    
    private(set) var muted = false
    var isMuted = false
    
    // MARK : SINAudioControllerDelegate
    func audioControllerMuted(_ audioController: SINAudioController!) {
        muted = true
    }
    
    func audioControllerUnmuted(_ audioController: SINAudioController!) {
        muted = false
    }
}
