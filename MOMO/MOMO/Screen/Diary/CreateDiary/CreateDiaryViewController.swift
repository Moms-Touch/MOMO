//
//  CreateDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit

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
  
  var inputType: DiaryInputType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpInputContainerView()
  }
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy.MM.dd")
    return formatter
  }()
  
  /// inputType 에 따라 InPutContainerView 를 채운다
  ///
  private func setUpInputContainerView() {
    
    var inputVC: UIViewController
    
    switch inputType?.inputType {
        
      case .text:
        
        inputVC = WithTextViewController.loadFromStoryboard()
        
        guard let hasGuide = inputType?.hasGuide else { return }
        
        (inputVC as! WithTextViewController).numOfCells = hasGuide ? 3 : 1
        
      case .voice:
        
//        inputVC =
        
        return
        
      default:
        return
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
    
    /// 가이드인지 확인
    
    /// 대답이 비어있으면 비어있다고 알려주고 return
    
    /// 가이드라면 for 문으로 QNA 인스턴스 3개 만들기
    ///
    /// 가이드아니면 QNA 인스턴스 1개 만들기
    
    /// Diary 객체 만들기
    
    /// Realm 에 넣기
    
  }
  
}
