//
//  RecodePlayer.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import Foundation
import AVFoundation

protocol RecordPlayer {
  
}

final class MomoRecordPlayer: RecordPlayer {
 
//  private var player: AVQueuePlayer
  
  init(date: Date) {
    
    let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(date)").appendingPathExtension("m4a")
    print(dataURL)
    guard FileManager.default.fileExists(atPath: dataURL.path) else {
      print("파일없나????")
      return }
    let player = AVQueuePlayer(url: dataURL)
    
  }
  
  
  
}
