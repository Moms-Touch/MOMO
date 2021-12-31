//
//  DiaryInputOptionViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

/// DiaryInputOption 에서 사용자가 선택한 옵션들로 이 구조체를 구성함
/// 이 구조체를 기반으로 CreateDiaryVC 의 모양이 달라지게됨
///
// FIXME: Naming 이 중복되어서 마음에 안듬
struct DiaryInputType {
  
  enum InputType: String {
    case text
    case voice
  }
  
  var inputType: InputType
  var hasGuide: Bool?
}

enum InputOptionErrorType: Error {
  
  case unspecifiedButton
}

class DiaryInputOptionViewController: UIViewController, StoryboardInstantiable {
  
  var inputType: DiaryInputType?
  
  /// [ 작성 방식 (글, 목소리) 버튼들을 담고 있는 스택 뷰
  /// - 첫번째 단계 에 화면에 나타난다

  @IBOutlet weak var inputOptionStack: UIStackView!
  
  /// [ 가이드 여부 선택 버튼들을 담고 있는 스택 뷰
  /// - 두번째 단계 에 화면에 나타난다
  
  @IBOutlet weak var guideOptionStack: UIStackView!
  
  /// [글로 작성] 버튼
  
  @IBOutlet weak var textOptionButton: UIButton!
  
  /// [목소리로 작성] 버튼
  
  @IBOutlet weak var voiceOptionButton: UIButton!
  
  /// [질문에 답하기] 버튼
  
  @IBOutlet weak var guideOptionButton: UIButton!
  
  /// [자유롭게 남기기] 버튼
  
  @IBOutlet weak var noGuideOptionButton: UIButton!
  
  private var isFirstStep: Bool = true {
    didSet {
      isFirstStep ? onFirstStep() : onSecondStep()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    onFirstStep()
  }
  
  private func onFirstStep() {
    
    inputOptionStack.isHidden = false
    guideOptionStack.isHidden = true
    
  }
  
  private func onSecondStep() {
    
    inputOptionStack.isHidden = true
    guideOptionStack.isHidden = false
  }
    
  @IBAction func selectFirstStepOption(_ sender: UIButton) {
    
    switch sender {
        
      case textOptionButton:
        
        inputType = DiaryInputType(inputType: .text, hasGuide: nil)
        
        onSecondStep()
        
      case voiceOptionButton:
        
        inputType = DiaryInputType(inputType: .voice, hasGuide: nil)
        
        let createDiaryVC = CreateDiaryViewController.loadFromStoryboard() as! CreateDiaryViewController
        
        guard let inputType = inputType else { return }
        
        createDiaryVC.inputType = inputType
        
        self.show(createDiaryVC, sender: nil)
        
      default:
        fatalError("Error: Unspecified Button")
    }
  }
  
  @IBAction func selectSecondStepOption(_ sender: UIButton) {
    
    switch sender {
        
      case guideOptionButton:
        
        inputType?.hasGuide = true
        
      case noGuideOptionButton:
        
        inputType?.hasGuide = false
      
      default:
        fatalError("Error: Unspecified Button")
    }
    
    let createDiaryVC = CreateDiaryViewController.loadFromStoryboard() as! CreateDiaryViewController
    
    guard let inputType = inputType else { return }
    
    createDiaryVC.inputType = inputType
    
    // Navigation에 CreateDiaryViewController push
    self.show(createDiaryVC, sender: nil)
  }
  
  @IBAction func dismiss(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
}
