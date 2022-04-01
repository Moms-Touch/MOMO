//
//  WithVoiceUseCase.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/31.
//

import Foundation
import AVFoundation
import RxSwift

/// 참고
/* https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
 */

enum RecordError: Error {
  case permissionError
  case unknownError
}

protocol WithVoiceUseCase {
  func startRecording(date: Date) -> Observable<RecordStatus>
  func finishRecording(success: Bool) -> Observable<RecordStatus>
  func checkRecordPermission() -> Observable<RecordStatus>
  var savedURL: BehaviorSubject<String> {get set}
}

final class MomoWithVoiceUseCase: NSObject, WithVoiceUseCase {
  
  private var recordingSession: AVAudioSession
  private var audioRecorder: AVAudioRecorder
  private let voiceRecordsDirectoryName: String = "VoiceRecords"
  private let repository: DiaryRepository
  private var disposeBag = DisposeBag()
  var savedURL = BehaviorSubject<String>(value: "")
  
  init(recodingSession: AVAudioSession, audioRecoder: AVAudioRecorder, repository: DiaryRepository) {
    self.recordingSession = recodingSession
    self.audioRecorder = audioRecoder
    self.repository = repository
  }
  
  func startRecording(date: Date) -> Observable<RecordStatus> {
    
    let audioFilename = getVoiceDirectory()
      .appendingPathComponent("\(date).m4a")
    
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
      savedURL.onNext("\(audioFilename)")
      return Observable.just(.recording)
    } catch {
      return finishRecording(success: false)
    }
    
  }
  
//  func pauseRecording() -> Observable<RecordStatus> {
//
//    audioRecorder.pause()
//    return Observable.just(RecordStatus.paused)
//  }
  
  func finishRecording(success: Bool) -> Observable<RecordStatus> {
    
    audioRecorder.stop()
    return Observable.just(RecordStatus.finished)
  }
  
  func checkRecordPermission() -> Observable<RecordStatus> {
    return Observable.create { [weak self] observer in
      guard let self = self else {
        return observer.onError(AppError.noSelf) as! Disposable
      }
      do {
        try self.recordingSession.setCategory(.playAndRecord, mode: .default)
        try self.recordingSession.setActive(true)
        self.recordingSession.requestRecordPermission { allowed in
          if allowed {
            observer.onNext(.notstarted)
          } else {
            observer.onError(RecordError.permissionError)
          }
        }
        
      } catch {
        return observer.onError(RecordError.permissionError) as! Disposable
      }
      return Disposables.create()
    }
  }
  
}

// MARK: - Private Methods

extension MomoWithVoiceUseCase {
  
  private func getVoiceDirectory() -> URL {
    
    makeVoiceDirectoryIfNotExists()
    
    let docURL = getDocumentsDirectory()
    
    return docURL.appendingPathComponent(voiceRecordsDirectoryName, isDirectory: true)
  }
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
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
}

extension MomoWithVoiceUseCase: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      if !flag {
          finishRecording(success: false)
      }
  }
}
