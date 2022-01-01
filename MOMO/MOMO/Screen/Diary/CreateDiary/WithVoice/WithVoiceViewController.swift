//
//  WithVoiceViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit
import AVFoundation

class WithVoiceViewController: UIViewController, StoryboardInstantiable  {
  
  @IBOutlet weak var recordButton: UIButton!
  
  var recordingSession: AVAudioSession!
  
  var audioRecorder: AVAudioRecorder!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    recordingSession = AVAudioSession.sharedInstance()

    do {
      
        try recordingSession.setCategory(.playAndRecord, mode: .default)
      
        try recordingSession.setActive(true)
      
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
              
                if allowed {
                  
//                    self.loadRecordingUI()
                  
                } else {
                  
                  // failed to record!
                  
                  //You should replace the
                  // failed to record! comment with a meaningful error alert to your user, or perhaps an on-screen label.
                  
                }
            }
        }
    } catch {
        // failed to record!
    }
  }
  
  @IBAction func didTapRecordButton(_ sender: UIButton) {
    
    if audioRecorder == nil {
      
        startRecording()
      
    } else {
      
      finishRecording(success: true)
      
//      let alertVC = UIAlertController(title: "녹음 종료", message: "녹음을 끝내실건가요?", preferredStyle: .alert)
//
//      let okAction = UIAlertAction(title: "네", style: .default) { _ in
//        self.finishRecording(success: true)
//      }
//
//      let pauseAction = UIAlertAction(title: "일시 정지", style: .default) { _ in
//
//        self.pauseRecording()
//      }
//
//      alertVC.addAction(okAction)
//
//      alertVC.addAction(pauseAction)
//
//      present(alertVC, animated: true, completion: nil)

    }
    
  }
  
  func startRecording() {
    
      let audioFilename = getDocumentsDirectory().appendingPathComponent("0시로 맞춘 데이트 가 들어가야함.m4a")

      let settings = [
          AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
          AVSampleRateKey: 12000,
          AVNumberOfChannelsKey: 1,
          AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]

      do {
          audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
          audioRecorder.delegate = self
          audioRecorder.record()
        
          recordButton.setImage(pauseImage, for: .selected)
          recordButton.isSelected = true
        
      } catch {
          finishRecording(success: false)
      }
  }
  
  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
  }
  
  func pauseRecording() {
    
    audioRecorder.pause()
    
    recordButton.setImage(pauseImage, for: .selected)
  }
  
  func finishRecording(success: Bool) {
    
      audioRecorder.stop()
      audioRecorder = nil
    
    recordButton.isSelected = false

//      if success {
////          recordButton.setTitle("Tap to Re-record", for: .normal)
//        recor
//      } else {
//          recordButton.setTitle("Tap to Record", for: .normal)
//          // recording failed :(
//      }
    
  }
  
}

extension WithVoiceViewController: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      if !flag {
          finishRecording(success: false)
      }
  }
}

extension WithVoiceViewController {
  
  var recordImage: UIImage {
    
    return UIImage(systemName: "record.circle")!
  }
  
  var stopImage: UIImage {
  
    return UIImage(systemName: "stop.circle")!
  }
  
  var pauseImage: UIImage {
    
    return UIImage(systemName: "pause.circle")!
  }
}
