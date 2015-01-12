//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Afonso Graça on 24/12/14.
//  Copyright (c) 2014 Afonso Graça. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var recordingInProgress: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var recordButton: UIButton!
	
	var audioRecorder: AVAudioRecorder!
	var recordedAudio: RecordedAudio!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.stopButton.hidden = true
		self.recordButton.enabled = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func recordAudio(sender: UIButton) {
		self.recordingInProgress.hidden = false
		self.stopButton.hidden = false
		self.recordButton.enabled = false
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		
		let formatter = NSDateFormatter()
		formatter.dateFormat = "ddMMyyyy-HHmmss"
		let recordingName = formatter.stringFromDate(NSDate())
		let filePath = NSURL.fileURLWithPathComponents([dirPath, recordingName])
		println(filePath)
		
		AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
		
		audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}

	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
		if flag {
			recordedAudio = RecordedAudio()
			recordedAudio.title = recorder.url.lastPathComponent
			recordedAudio.filePathURL = recorder.url
			
			self.performSegueWithIdentifier("Play Recorded Audio", sender: recordedAudio)
		}
		else {
			UIAlertView(title: "Recording Error", message: "Pitch Perfect was not able to recording your audio successfully", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
			recordButton.enabled = true
			stopButton.hidden = true
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "Play Recorded Audio" {
			if let viewController = segue.destinationViewController as? PlaySoundsViewController {
				viewController.recordedAudio = sender as RecordedAudio
			}
		}
	}
	
	@IBAction func stopRecording(sender: UIButton) {
		self.recordingInProgress.hidden = true
		self.stopButton.hidden = true
		
		audioRecorder.stop()
		AVAudioSession.sharedInstance().setActive(false, error: nil)
	}
}

