//
//  CreateDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit

import RealmSwift
import RxSwift
import RxCocoa

final class CreateDiaryViewController: DiaryShowViewController, ViewModelBindableType {
  
  private var disposeBag = DisposeBag()
  
  // MARK: - ViewModel & Binding
  
  var viewModel: CreateDiaryViewModel
  
  func bindViewModel() {
    
    // MARK: - Input
    backButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(to: viewModel.input.dismissClicked)
      .disposed(by: disposeBag)
    
    completeOrDeleteButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(to: viewModel.input.completedClicked)
      .disposed(by: disposeBag)
    
    emotionButtons.enumerated().forEach { index, button in
      button.rx.tap
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .map{ return DiaryEmotion.allCases[index] }
        .bind(to: viewModel.input.selectEmotionButton)
        .disposed(by: disposeBag)
      
      button.rx.tap
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .map { return button }
        .bind(onNext: {
          self.emotionButtons.forEach {
            $0.isSelected = false
          }
          $0.isSelected = true
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    /// inputType 에 따라 InPutContainerView 를 채운다
    
    viewModel.output.withInputViewModel
      .drive(onNext: { [weak self] viewModel in
        guard let self = self else {return}
  
        if viewModel is WithTextViewModel,
           let vm = viewModel as? WithTextViewModel {
          let vc = WithTextViewController(withTextViewModel: vm,
                                          readTextViewModel: nil)
          self.appendChildVC(to: self.diaryInputContainerView, with: vc)
          
        } else if viewModel is WithVoiceViewModel,
                  let vm = viewModel as? WithVoiceViewModel {
          let vc = WithVoiceViewController(withVoiceViewModel: vm,
                                           readVoiceViewModel: nil)
          self.appendChildVC(to: self.diaryInputContainerView, with: vc)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.complete
      .drive(onNext: { [weak self] _ in
        self?.saveCompleted()
      })
      .disposed(by: disposeBag)
    
    viewModel.output.dismiss
      .drive(onNext: { [weak self] in
        self?.dismiss()
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotoOption
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.date
      .drive(dateLabel.rx.text)
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Init
  
  init(viewModel: CreateDiaryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    self.bind(viewModel: self.viewModel)
  }
  
  // MARK: - Method
  
  private func dismiss() {
    self.alertWithObservable(title: "작성 중단", text: "그만두시겠어요? 작성중인 내용은 저장되지 않아요")
      .bind(to: viewModel.input.dismissWithoutSave)
      .disposed(by: disposeBag)
  }
  
  private func saveCompleted() {
      self.alertWithOneAnswer(title: "일기 저장 성공", text: "일기가 잘 저장되었어요", answer: "알겠어요")
        .subscribe(onCompleted: { [weak self] in
          guard let self = self else {return}
          self.view.window?.rootViewController?.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
  }
  
  internal override func setupUI() {
    completeOrDeleteButton.setTitle("완료", for: .normal)
    super.setupUI()
  }
  
}
