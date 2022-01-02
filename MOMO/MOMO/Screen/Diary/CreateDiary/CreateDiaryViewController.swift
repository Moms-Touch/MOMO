//
//  CreateDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit
import RealmSwift

final class CreateDiaryViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var dateLabel: UILabel! {
    didSet {
      dateLabel.text = dateFormatter.string(from: Date())
    }
  }
  
  @IBOutlet weak var diaryInputContainerView: UIView!
  
  @IBOutlet var emotionButtons: [UIButton]! {
    
    didSet {
      emotionButtons.first?.isSelected = true
    }
  }
  
  @IBOutlet weak var completeDiaryButton: UIButton! {
    didSet {
      completeDiaryButton.layer.cornerRadius = 4
    }
  }
  
  var inputType: DiaryInputType!
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy.MM.dd")
    return formatter
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setUpInputContainerView()
  }
  
  // MARK: - Method

  
  /// inputType 에 따라 InPutContainerView 를 채운다
  private func setUpInputContainerView() {
    
    var inputVC: UIViewController
    
    switch inputType?.inputType {
        
      case .text:
        
        inputVC = WithTextViewController.loadFromStoryboard()
        
        guard let hasGuide = inputType?.hasGuide else { return }
        
        (inputVC as! WithTextViewController).numOfCells = hasGuide ? 3 : 1
        
      case .voice:
        
        inputVC = WithVoiceViewController.loadFromStoryboard()
        
      default:
        fatalError("Invalid Input Type")
    }

    addChild(inputVC)
    
    diaryInputContainerView.addSubview(inputVC.view)
    
    inputVC.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      inputVC.view.leadingAnchor.constraint(equalTo: diaryInputContainerView.leadingAnchor),
      inputVC.view.topAnchor.constraint(equalTo: diaryInputContainerView.topAnchor),
      inputVC.view.trailingAnchor.constraint(equalTo: diaryInputContainerView.trailingAnchor),
      inputVC.view.bottomAnchor.constraint(equalTo: diaryInputContainerView.bottomAnchor),
    ])
    
    inputVC.didMove(toParent: self)
  }
  
  
  @IBAction func dismiss(_ sender: UIButton) {
    
    let alertVC = UIAlertController(title: "작성 중단", message: "그만 두시겠어요? 작성중인 내용은 저장되지 않아요.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "중단", style: .destructive) { _ in
      
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    let cancelAction = UIAlertAction(title: "마저 쓸래요", style: .default, handler: nil)
    
    alertVC.addAction(okAction)
    alertVC.addAction(cancelAction)

    present(alertVC, animated: true, completion: nil)
  }
  
  @IBAction func didSelectEmotionButton(_ sender: UIButton) {
    
    emotionButtons.forEach {
      $0.isSelected = false
    }
    
    sender.isSelected = true

  }
  
  @IBAction func completeDiary(_ sender: Any) {
    
    /// 완료할건지 묻는 Alert
    
    /// 감정
    
    var emotion: DiaryEmotion
    
    var buttonIndex: Int = -1
    
    for (index, button) in emotionButtons.enumerated() {
      if button.isSelected {
        buttonIndex = index
        break
      }
    }
    
    switch buttonIndex {
      case 0:
        emotion = DiaryEmotion.happy
        break
      case 1 :
        emotion = DiaryEmotion.angry
        break
      case 2 :
        emotion = DiaryEmotion.sad
        break
      case 3 :
        emotion = DiaryEmotion.blue
        break
      default:
      fatalError("Invalid Button Index")
        
    }
    
    
    /// 텍스트와 음성에 따라 다르게 처리
    ///
    
    var diary: Diary
    
    switch inputType.inputType {
        
      case .text:
        
        guard let withTextVC = self.children.first as? WithTextViewController else { return }
        
        guard let hasGuide = inputType.hasGuide else { return }
        
        var qnaList: List<QNA> = List<QNA>()
        
        if hasGuide {
          
          /// 가이드가 있다면
          /// 질문은 3개일 것이다
          guard withTextVC.qnaList.count == 3 else {
            
            /// 3가지 질문을 모두 작성하지 않았다면
            /// 알림 후 종료
            
            let alertVC = UIAlertController(title: "다 채워지지 않음", message: "모든 답변을 채워주세요", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction.okAction)
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
          }
          
          /// 가이드가 없다면
          /// 질문은 1개일 것이다
        } else {
          
          guard withTextVC.qnaList.count == 1 else {
            
            /// 1가지 질문을 모두 작성하지 않았다면
            /// 알림 후 종료
            
            let alertVC = UIAlertController(title: "다 채워지지 않음", message: "모든 답변을 채워주세요", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction.okAction)
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
          }
          
        }
        
        for (question, answer) in withTextVC.qnaList {
          
          qnaList.append(QNA(question: question, answer: answer))
          
        }
        
        diary = Diary(date: Date(), emotion: emotion, contentType: inputType.inputType, qnaList: qnaList)
        
      case .voice:
        
        guard let withVoiceVC = self.children.first as? WithVoiceViewController else { return }
        
        /// 아직 녹음 중이라면 종료한다
        if let audioRecorder = withVoiceVC.audioRecorder {
          
          withVoiceVC.finishRecording(success: true)
          
        }

        diary = Diary(date: Date(), emotion: emotion, contentType: inputType.inputType, qnaList: List<QNA>())
      
        
      default:
        fatalError("Invalid Input Type")
    }
    
    /// DB 에 넣기 ^^..
    do {
      
      let realm = try Realm()
      
      try realm.write {
        realm.add(diary)
      }
      
    } catch {
      
      let alertVC = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
      
      alertVC.addAction(UIAlertAction.okAction)
      
      present(alertVC, animated: true)
    }
    
    let alertVC = UIAlertController(title: "일기 저장 성공!", message: "일기가 잘 저장되었어요.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "알겠어요", style: .default) { _ in
      
      self.navigationController?.popToRootViewController(animated: true)
      
    }
    
    alertVC.addAction(okAction)
    
    self.present(alertVC, animated: true, completion: nil)
    
  }
  
}
