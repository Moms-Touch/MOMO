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

final class CreateDiaryViewController: UIViewController, ViewModelBindableType {
  
  private let dateLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    $0.text = Date().toString()
  }
  
  private let backButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName:"chevron.left"), for: .normal)
  }
  
  private let navBar = UIView(frame: .zero).then {
    $0.backgroundColor = .clear
  }
  
  private let completeDiaryButton = UIButton(type:.custom).then {
    $0.setTitle("완료", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    $0.setTitleColor(.label, for: .normal)
  }
  
  private let diaryInputContainerView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let blurView = BlurView()
  private var emotionButtons = [UIButton]()
  private var disposeBag = DisposeBag()
  
  // MARK: - ViewModel & Binding
  
  var viewModel: CreateDiaryViewModel
  
  func bindViewModel() {
    
    // MARK: - Input
    backButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind(to: viewModel.input.dismissClicked)
      .disposed(by: disposeBag)
    
    completeDiaryButton.rx.tap
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
      .filter{ $0 is WithTextViewModel } // 나중에 변경하기
      .map { WithTextViewController(viewModel: $0 as! WithTextViewModel) }
      .drive(onNext: { [weak self] in
        guard let self = self else {return}
        self.appendChildVC(to: self.diaryInputContainerView, with: $0)
      })
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
//    setupKeyboard()
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
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
//  @IBAction func completeDiary(_ sender: Any) {
//      case .voice:
//
//        guard let withVoiceVC = self.children.first as? WithVoiceViewController else { return }
//
//        /// 아직 녹음 중이라면 종료한다
//        if let audioRecorder = withVoiceVC.audioRecorder {
//
//          withVoiceVC.finishRecording(success: true)
//
//        }
//
//        diary = Diary(date: Date(), emotion: emotion, contentType: inputType.inputType, qnaList: List<QNA>())
//
//
//      default:
//        fatalError("Invalid Input Type")
//    }
//
//    /// DB 에 넣기 ^^..
//    do {
//
//      let realm = try Realm()
//
//      try realm.write {
//        realm.add(diary)
//      }
//
//    } catch {
//
//      let alertVC = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
//
//      alertVC.addAction(UIAlertAction.okAction)
//
//      present(alertVC, animated: true)
//    }
//
//  }
  
}
// MARK: - Keyboard

extension CreateDiaryViewController {
  private func setupKeyboard() {
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] noti in
      
      guard let self = self else { return }
      
      if let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
         let keybaordRectangle = keyboardFrame.cgRectValue
         let keyboardHeight = keybaordRectangle.height
         
        self.view.bounds = CGRect(x: 0, y: keyboardHeight / 2, width: self.view.bounds.width, height: self.view.bounds.height)
       }
    }
    
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { [weak self] noti in
      
      guard let self = self else { return }
      
      self.view.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
  }
}

// MARK: - Set Up UI
extension CreateDiaryViewController {
  
  private func appendChildVC(to parentView: UIView, with child: UIViewController) {
    self.addChild(child)
    parentView.addSubview(child.view)
    child.view.snp.makeConstraints { make in
      make.left.right.top.bottom.equalTo(self.diaryInputContainerView)
    }
    child.didMove(toParent: self)
  }
  
  private func makeEmotionButtonArray() -> [UIButton] {
    
    let happyBirdButton = makeEmotionButton(emotion: "bird.happy")
    let sadBirdButton = makeEmotionButton(emotion: "bird.sad")
    let blueBirdButton = makeEmotionButton(emotion: "bird.blue")
    let angryBirdButton = makeEmotionButton(emotion: "bird.angry")
    
    return [happyBirdButton, angryBirdButton, sadBirdButton, blueBirdButton]
  }
  
  private func makeStackView(emotionButtons: [UIButton]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: emotionButtons).then {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.spacing = 20
    }
    
    self.view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(20)
      make.top.equalTo(navBar.snp.bottom).inset(-25)
      make.bottom.equalTo(diaryInputContainerView.snp.top).offset(-15)
    }
    return stackView
  }
  
  private func makeEmotionButton(emotion: String) -> UIButton {
    let button = UIButton(type: .custom).then {
      $0.setImage(UIImage(named: emotion + ".default"), for: .normal)
      $0.setImage(UIImage(named: emotion), for: .selected)
    }
    return button
  }
  
  private func setupUI() {
    navBar.addSubview(backButton)
    navBar.addSubview(dateLabel)
    navBar.addSubview(completeDiaryButton)
    view.addSubview(blurView)
    view.addSubview(navBar)
    view.addSubview(diaryInputContainerView)
    
    blurView.snp.makeConstraints { make in
      make.left.right.bottom.top.equalToSuperview()
    }

    backButton.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    completeDiaryButton.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }
    
    navBar.snp.makeConstraints { make in
      make.height.equalTo(44)
      make.left.right.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    self.emotionButtons = makeEmotionButtonArray()
    let stackview = makeStackView(emotionButtons: emotionButtons)
    
    diaryInputContainerView.snp.makeConstraints { make in
      make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
      make.top.equalTo(stackview.snp.bottom).offset(-15)
    }
    
  }
}
