//
//  DiaryInputOptionViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class DiaryInputOptionViewController: UIViewController, StoryboardInstantiable {

  /// [ 작성 방식 (글, 목소리) 버튼들을 담고 있는 스택 뷰
  /// - 첫번째 단계 에 화면에 나타난다

  @IBOutlet var labelList: [UILabel]!
  @IBOutlet var backButton: UIButton!
  
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

  // MARK: - ViewModel & Bind

  var viewModel: DiaryInputOptionViewModel!
  
  func bindViewModel() {
    
  // MARK: - Input
    Observable.merge(textOptionButton.rx.tap.map{ InputType.text },
                     voiceOptionButton.rx.tap.map{ InputType.voice })
              .bind(to: viewModel.input.inputOption)
              .disposed(by: disposeBag)
  
    Observable.merge(guideOptionButton.rx.tap.map { true },
                     noGuideOptionButton.rx.tap.map { false })
              .bind(to: viewModel.input.hasGuideOption)
              .disposed(by: disposeBag)
    
    backButton.rx.tap
      .withUnretained(self)
      .bind { vc, event in
        vc.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
    
  // MARK: - Output
    viewModel.output.gotoSecondStep
      .drive(onNext: { [weak self] _ in
        self?.onSecondStep()
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotocreateDiaryVC
      .drive(onNext: { [weak self] in
        let vc = CreateDiaryViewController(viewModel: $0)
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: false)
      })
      .disposed(by: disposeBag)
  
  }
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bindViewModel()
    onFirstStep()
  }
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  private var inputType: DiaryInputType?
  
  // MARK: - Private methods
  
  private func onFirstStep() {
    
    inputOptionStack.isHidden = false
    guideOptionStack.isHidden = true
    
  }
  
  private func onSecondStep() {
    inputOptionStack.isHidden = true
    guideOptionStack.isHidden = false
  }
}
