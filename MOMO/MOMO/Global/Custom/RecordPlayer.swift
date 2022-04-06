//
//  RecodePlayer.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation

import RxSwift
import RxCocoa
import AVFoundation

enum PlayerStatus {
  case notStarted
  case nowPlaying
  case stop
  case pause
}

protocol RecordPlayer: AnyObject {
  func play()
  func pause()
  func stop()
  func durationAndCurrentTime() -> Observable<(String, String)>
  var recordPlayerStatus: BehaviorRelay<PlayerStatus> { get set }
}

final class MomoRecordPlayer: NSObject, RecordPlayer, AVAudioPlayerDelegate {
 
  private var player: AVAudioPlayer
  var recordPlayerStatus: BehaviorRelay<PlayerStatus>
  
  init(date: Date) {
    
    let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(date)").appendingPathExtension("m4a")
    recordPlayerStatus = BehaviorRelay<PlayerStatus>(value: .notStarted)
    do {
      self.player = try AVAudioPlayer(contentsOf: dataURL)
    } catch {
      print("Error in RecordPlayer")
      self.player = AVAudioPlayer()
    }
    
    guard FileManager.default.fileExists(atPath: dataURL.path) else {
      print("파일없나????")
      return }
    
  }
  
  func play() {
    player.play()
    player.delegate = self
    recordPlayerStatus.accept(.nowPlaying)
  }
  
  func pause() {
    player.pause()
    recordPlayerStatus.accept(.pause)
  }
  
  func durationAndCurrentTime() -> Observable<(String, String)> {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm:ss"
    let duration = formatter.string(from: Date(timeIntervalSince1970: player.duration))
    let currentTime = formatter.string(from: Date(timeIntervalSince1970: player.duration - player.currentTime))
    return Observable.just((duration, currentTime))
  }
  
  func stop() {
    player.stop()
    recordPlayerStatus.accept(.notStarted)
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    if flag {
      self.stop()
    }
  }

}
