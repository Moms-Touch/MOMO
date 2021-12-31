//
//  ReadDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit
import RealmSwift
import FSCalendar

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
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy.MM.dd")
    return formatter
  }()
  
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
        break
    }
    
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
