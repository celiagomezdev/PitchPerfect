//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Celia Gómez de Villavedón on 14/9/16.
//  Copyright © 2016 Celia Gómez de Villavedón. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Recording Sounds View Controller

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }


// MARK: Record function
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("record button pressed")
        setUIState(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }


// MARK: StopRecording function
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("stop recording button pressed")
        audioRecorder.stop()
        setUIState(isRecording: false)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    
    //Set the label with Ternary Operators
    
    func setUIState(isRecording:Bool){
        recordingLabel.text =
            isRecording ? "Recording in progress" : "Tap to Record"
        
        // Set buttons
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as!
            PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


