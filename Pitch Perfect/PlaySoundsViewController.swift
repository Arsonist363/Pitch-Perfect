//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cesar Colorado on 11/30/14.
//  Copyright (c) 2014 Cesar Colorado. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var session = AVAudioSession.sharedInstance()
    
    var playbackDelay:NSTimeInterval!
    
    var echoPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        try! audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        //enable audio playback in the larger speaker
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        try! echoPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlaySlow(sender: UIButton) {
        //Play audio sloowly here......
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func PlayFast(sender: UIButton) {
        //Play audio fast here......
        playAudioWithVariableRate(1.5)
    }
    func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1
        audioPlayer.play()
        playbackDelay = 0.25;
        echoPlayer.volume = 0.25;
        echoPlayer.playAtTime(audioPlayer.deviceCurrentTime + playbackDelay)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        
        audioPlayerNode.play()
    }
    
       @IBAction func StopAudio(sender: UIButton) {
        audioPlayer.stop()
    }


}
