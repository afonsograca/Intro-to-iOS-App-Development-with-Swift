//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Afonso Graça on 06/01/15.
//  Copyright (c) 2015 Afonso Graça. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
	
	// MARK: Types
	@IBOutlet weak var slowButton: UIButton!
	@IBOutlet weak var fastButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var chipmunkButton: UIButton!
	@IBOutlet weak var darthVaderButton: UIButton!
	
	var audioPlayer : AVAudioPlayer!
	var recordedAudio : RecordedAudio!
	var audioEngine : AVAudioEngine!
	var audioFile : AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathURL , error: nil)
		audioPlayer.enableRate = true
		
		audioEngine = AVAudioEngine()
		audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
//		if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//			
//		}
//		else {
//			println("cannot resolve the path for the specified name")
//		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func playAudio(rate : Float) {
		if let audio = audioPlayer {
			audio.stop()
			audio.rate = rate
			audio.currentTime = 0.00
			audio.play()
		}
	}
	
	func playAudioWithVariablePitch(pitch : Float) {
		
		audioPlayer.stop()
		audioEngine.stop()
		audioEngine.reset()
		
		let audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)
		
		let pitchEffectNode = AVAudioUnitTimePitch()
		pitchEffectNode.pitch = pitch
		audioEngine.attachNode(pitchEffectNode)
		
		audioEngine.connect(audioPlayerNode, to: pitchEffectNode, format: nil)
		audioEngine.connect(pitchEffectNode, to: audioEngine.outputNode, format: nil)
		
		audioPlayerNode.scheduleFile(self.audioFile, atTime: nil, completionHandler: nil)
		audioEngine.startAndReturnError(nil)
		
		audioPlayerNode.play()
	}
	
	@IBAction func playSlowSound(sender: AnyObject) {
		self.playAudio(0.5)
	}
	
	@IBAction func playFastSound(sender: AnyObject) {
		self.playAudio(2.0)
	}
	
	@IBAction func playChipmunkSound(sender: AnyObject) {
		self.playAudioWithVariablePitch(1000.0)
	}
	
	@IBAction func playDarthVaderSound(sender: AnyObject) {
		self.playAudioWithVariablePitch(-1000.0)
	}
	@IBAction func stopAudio(sender: AnyObject) {
		if let audio = audioPlayer {
			audio.stop()
			audio.currentTime = 0.00
			audioEngine.stop()	
		}
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
