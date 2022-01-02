//
//  WithVoiceViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit
import AVFoundation

final class WithVoiceViewController: UIViewController, StoryboardInstantiable  {
  
  @IBOutlet weak var recordButton: UIButton!
  
  var recordingSession: AVAudioSession!
  
  var audioRecorder: AVAudioRecorder!
  
  let voiceRecordsDirectoryName: String = "VoiceRecords"

  override func viewDidLoad() {
    super.viewDidLoad()
    
    recordingSession = AVAudioSession.sharedInstance()

    do {
      
        try recordingSession.setCategory(.playAndRecord, mode: .default)
      
        try recordingSession.setActive(true)
      
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
              
                if allowed {
                  
                } else {
                  
                  // failed to record!
                  
                  let alertVC = UIAlertController(title: "에러 발생", message: "마이크 사용을 허가해 주세요.", preferredStyle: .alert)
                  
                  alertVC.addAction(UIAlertAction.okAction)
                  
                  present(alertVC, animated: true)
                  
                }
            }
        }
    } catch {
      
        // failed to record!
      
      let alertVC = UIAlertController(title: "에러 발생", message: "잠시 뒤에 다시 시도해 주세요", preferredStyle: .alert)
      
      alertVC.addAction(UIAlertAction.okAction)
      
      present(alertVC, animated: true)
    }
  }
  
  @IBAction func didTapRecordButton(_ sender: UIButton) {
    
    /// 녹음이 시작되지 않았다면 nil 이다
    if audioRecorder == nil {
      
        startRecording()
      
    } else {
      
      if audioRecorder.isRecording {
        
        pauseRecording()
      } else {
        
        startRecording()
      }
    }
  }
  
  @IBAction func didTapFinishButton(_ sender: Any) {
    
    guard let _ = audioRecorder else { return }
    
    finishRecording(success: true)
    
  }
  func startRecording() {
    
    let audioFilename = getVoiceDirectory()
      .appendingPathComponent("\(Date().timeToZero()).m4a")

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
        
          recordButton.setImage(stopImage, for: .selected)
          recordButton.isSelected = true
        
      } catch {
          finishRecording(success: false)
      }
  }
  
  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
  }
  
  /// 녹음 저장 경로가 없다면 새로 만든다
  private func makeVoiceDirectoryIfNotExists() {
    
    let docURL = getDocumentsDirectory()
    
    let dataPath = docURL.appendingPathComponent(voiceRecordsDirectoryName)
    
    if !FileManager.default.fileExists(atPath: dataPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
  }
  
  /// 녹음 저장 경로를 가져온다
  private func getVoiceDirectory() -> URL {
    
    makeVoiceDirectoryIfNotExists()
    
    let docURL = getDocumentsDirectory()
    
    return docURL.appendingPathComponent(voiceRecordsDirectoryName, isDirectory: true)
  }
  
  func pauseRecording() {
    
    audioRecorder.pause()
    
    recordButton.setImage(playImage, for: .selected)
  }
  
  func finishRecording(success: Bool) {
    
      audioRecorder.stop()
      audioRecorder = nil
    
      recordButton.isSelected = false

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
  
  var playImage: UIImage {
    
    return UIImage(systemName: "record.circle")!
  }
  
  var stopImage: UIImage {
  
    return UIImage(systemName: "stop.circle")!
  }
  
  var pauseImage: UIImage {
    
    return UIImage(systemName: "pause.circle")!
  }
}
