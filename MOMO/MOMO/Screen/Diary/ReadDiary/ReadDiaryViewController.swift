//
//  ReadDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit
import RealmSwift
import FSCalendar
import AVFoundation


class ReadDiaryViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var qnaContainerStackView: UIStackView!
  
  @IBOutlet weak var deleteButton: UIButton! {
    didSet {
      deleteButton.layer.cornerRadius = 5
    }
  }
  
  
  var diary: Diary! {
    didSet {
      
      guard self.qnaContainerStackView != nil else { return }
      
      setUpViewWithDiary()
    }
  }
  
  private var player: AVQueuePlayer?
  
  var observation: NSKeyValueObservation?
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy.MM.dd")
    return formatter
  }()
  
  // MARK: - Life Cycle
  /// 1회성
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpViewWithDiary()
  }
  
  /// 스토리 보드에서 뷰정보를 가져오고, diary 를 주입할 수 있는 생성자
  static func make(with diary: Diary) -> ReadDiaryViewController {
    
    let vc = ReadDiaryViewController.loadFromStoryboard() as! ReadDiaryViewController
    
    vc.diary = diary
    
    return vc
  }
  
  func setUpViewWithDiary() {
    
    /*
     날짜
     */
    
    dateLabel.text = dateFormatter.string(from: diary.date)
    
    /*
     일기 Q&A
     */
    
    guard let contentType = DiaryInputType.InputType(rawValue:diary.contentType) else { return }
    
    switch contentType {
        
      case .text:
        
        for (index, qna) in diary.qnaList.enumerated() {
          
          var qnaView: QnAView
          
          if diary.qnaList.count == 1 {
            
            qnaView = QnAView.make(question: qna.question, answer: qna.answer!)
            
          } else {
            
            qnaView = QnAView.make(question: "Q\(index+1). " + qna.question, answer: qna.answer!)
          }
          
          qnaContainerStackView.addArrangedSubview(qnaView)
        }
        
      case .voice:
        
        /// 음원이 경로에 있는지 확인
        ///
        // FIXME: AVPlayerItem 을 옵셔널 변수로 가지고 있으면
        // line:113 에서의 코드 중복을 줄일 수 있을 것 같다.
        let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(diary.date)").appendingPathExtension("m4a")
        
        guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
        
        
        /// 플레이어 생성
        
        player = AVQueuePlayer(url: dataURL)
        
        observation = player?.observe(\.currentItem, options: [.new], changeHandler: { [unowned self] object, change in
          
          let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(self.diary.date)").appendingPathExtension("m4a")
          
          guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
          
          self.player?.insert(AVPlayerItem.init(url: dataURL), after: nil)
          
          self.player?.pause()
          
          (self.qnaContainerStackView.arrangedSubviews.last as? VoiceView)?.playButton.isSelected = false
        })
        
        let voiceView = VoiceView.make()
        
        voiceView.playButton.addTarget(self, action: #selector(didTapPlayBuntton), for: .touchUpInside)
        
        qnaContainerStackView.addArrangedSubview(voiceView)
    }
    
  }
  
  @objc func didTapPlayBuntton(_ sender: UIButton) {
    
    guard let player = player else {
      return
    }
    
    if sender.isSelected {
      
    /// 음성 중지
      player.pause()
      
    } else {
      
    /// 음성 실행
      player.play()
      
      
    }
    
    sender.isSelected.toggle()
  }
  
  @IBAction func deleteDiary(_ sender: UIButton) {
    
    let alertVC = UIAlertController(title: "일기 삭제", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "네", style: .destructive) { _code in
      
      do {
        
        let realm = try Realm()
        
        try realm.write {
          
          realm.delete(self.diary)
          
        }
        
      } catch {
        print(error.localizedDescription)
      }
      
      self.navigationController?.popToRootViewController(animated: true)
      
      // TODO: Toast 필요
    }
    
    alertVC.addAction(okAction)
    alertVC.addAction(UIAlertAction.cancelAction)
    
    self.present(alertVC, animated: true, completion: nil)
    
  }
  
  @IBAction func dismiss(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
}
