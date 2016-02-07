//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thomas Ptak on 1/19/16.
//  Copyright © 2016 Thomas Ptak. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer = AVAudioPlayer!()
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        // Do any additional setup after loading the view.
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            let filePathURL = NSURL.fileURLWithPath(filePath)
//            audioPlayer = try! AVAudioPlayer(contentsOfURL: filePathURL)
//            audioPlayer.enableRate = true
//        }else{
//            print("the filepath is empty")
//        }
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlaySlowAudio(sender: UIButton) {
        PlayAudio(0.5)
    }

    @IBAction func PlayFastAudio(sender: UIButton) {
        PlayAudio(2.0)
    }
    
    @IBAction func PlayChipmunkAudio(sender: UIButton) {
        PlayAudioWithVariablePitch(1000)
    }
    
    @IBAction func PlayDarthVaderAudio(sender: UIButton) {
        PlayAudioWithVariablePitch(-1000)
    }
    
    @IBAction func StopPlayingAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func PlayAudio(rate: float_t)
    {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func PlayAudioWithVariablePitch(pitch: Float){
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
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
