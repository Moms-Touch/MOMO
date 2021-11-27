//
//  DiaryInputOptionViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

enum InputOptionErrorType: Error {
  
  case unspecifiedButton
}

class DiaryInputOptionViewController: UIViewController, StoryboardInstantiable {
  
  var creationType: DiaryCreationType?
  
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
        creationType = DiaryCreationType(inputType: .text, hasGuide: nil)
        
      case voiceOptionButton:
        creationType = DiaryCreationType(inputType: .voice, hasGuide: nil)
      default:
        fatalError("Error: Unspecified Button")
    }
    
    onSecondStep()
  }
  
  @IBAction func selectSecondStepOption(_ sender: UIButton) {
    
    switch sender {
        
      case guideOptionButton:
        creationType?.hasGuide = true
        
      case noGuideOptionButton:
        creationType?.hasGuide = false
      
      default:
        fatalError("Error: Unspecified Button")
    }
    
    // Navigation에 CreateDiaryViewController push
    
  }
  
  
}
