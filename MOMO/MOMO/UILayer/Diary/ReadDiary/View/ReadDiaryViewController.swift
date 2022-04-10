//
//  ReadDiaryViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit
import Then
import SnapKit

import RxCocoa
import RxSwift

import AVFoundation

class ReadDiaryViewController: DiaryShowViewController, ViewModelBindableType {
  
  // MARK: - ViewModel & BindingViewModel
  var viewModel: ReadDiaryViewModel
  
  func bindViewModel() {
    
    // MARK: - Input
    backButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(to: viewModel.input.dismissClicked)
      .disposed(by: disposeBag)
    
    completeOrDeleteButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(to: viewModel.input.deleteButtonClicked)
      .disposed(by: disposeBag)
    
    // MARK: - Output
    
    viewModel.output.withInputViewModel
      .drive(onNext: { [weak self] in
        guard let self = self, let vm = $0 as? ReadContentViewModel else {return}
        if vm.contentType == .text {
          let vc = WithTextViewController(withTextViewModel: nil, readTextViewModel: vm)
          self.appendChildVC(to: self.diaryInputContainerView, with: vc)
        } else {
          let vc = WithVoiceViewController(withVoiceViewModel: nil, readVoiceViewModel: vm)
          self.appendChildVC(to: self.diaryInputContainerView, with: vc)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.date
      .drive(dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.emotion
      .filter({ emotion, index in
        emotion != .unknown
      })
      .drive(onNext: { [unowned self] emotion, index in
        self.emotionButtons.forEach { $0.isUserInteractionEnabled = false }
        self.emotionButtons[index].isSelected = true
      })
      .disposed(by: disposeBag)
    
    viewModel.output.toastMessage
      .drive(onNext: { [weak self] message in
        self?.view.makeToast(message)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.deleteCompleted
      .debug()
      .filter { $0 == true}
      .drive(onNext: { [weak self] _ in
        self?.view.makeToast("삭제가 완료되었습니다.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self?.view.window?.rootViewController?.dismiss(animated: false)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.dismiss
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  
  
  // MARK: - init
  init(viewModel: ReadDiaryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  /// 1회성
  override func viewDidLoad() {
    super.viewDidLoad()
    completeOrDeleteButton.setTitle("삭제", for: .normal)
    setupUI()
    self.bind(viewModel: self.viewModel)
  }
  

  
}
