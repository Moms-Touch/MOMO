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
  
//  func setUpViewWithDiary() {
//    
//    switch contentType {
//
//        
//      case .voice:
//        
//        /// 음원이 경로에 있는지 확인
//        ///
//        // FIXME: AVPlayerItem 을 옵셔널 변수로 가지고 있으면
//        // line:113 에서의 코드 중복을 줄일 수 있을 것 같다.
//        let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(diary.date)").appendingPathExtension("m4a")
//        
//        guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
//        
//        
//        /// 플레이어 생성
//        
//        player = AVQueuePlayer(url: dataURL)
//        
//        observation = player?.observe(\.currentItem, options: [.new], changeHandler: { [unowned self] object, change in
//          
//          let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VoiceRecords", isDirectory: true).appendingPathComponent("\(self.diary.date)").appendingPathExtension("m4a")
//          
//          guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
//          
//          self.player?.insert(AVPlayerItem.init(url: dataURL), after: nil)
//          
//          self.player?.pause()
//          
//          (self.qnaContainerStackView.arrangedSubviews.last as? VoiceView)?.playButton.isSelected = false
//        })
//        
//        let voiceView = VoiceView.make()
//        
//        voiceView.playButton.addTarget(self, action: #selector(didTapPlayBuntton), for: .touchUpInside)
//        
//        qnaContainerStackView.addArrangedSubview(voiceView)
//    }
//    
//  }


  
}


//private var player: AVQueuePlayer?

//@objc func didTapPlayBuntton(_ sender: UIButton) {
//
//  guard let player = player else {
//    return
//  }
//
//  if sender.isSelected {
//
//  /// 음성 중지
//    player.pause()
//
//  } else {
//
//  /// 음성 실행
//    player.play()
//
//
//  }
//
//  sender.isSelected.toggle()
//}
