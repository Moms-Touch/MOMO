//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import RealmSwift
import RxSwift

final class HomeMainViewController: UIViewController, StoryboardInstantiable, UIViewControllerTransitioningDelegate, BackgroundPureable, ViewModelBindableType {
  
  private let logoView = UIImageView().then {
    $0.image = UIImage(named: "Logo")
    $0.contentMode = .scaleAspectFit
    $0.snp.makeConstraints { make in
      make.height.equalTo(34)
      make.width.equalTo(87)
    }
  }
  
  private let bookmarkButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(named: "Bookmark"), for: .normal)
    $0.snp.makeConstraints { make in
      make.height.width.equalTo(24)
    }
  }
  
  private let settingButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
    $0.tintColor = .label
    $0.snp.makeConstraints { make in
      make.height.width.equalTo(24)
    }
  }
  
  private let imageHuggingView = UIView(frame: .zero).then {
    $0.backgroundColor = .white
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(UIScreen.main.bounds.width * 0.33)
    }
  }
  
  private let babyProfileImageView = UIImageView().then {
    $0.image = UIImage(named: "mascot")
    $0.contentMode = .scaleAspectFill
  }
  
  private let calendarButton = UIButton(type: .custom).then {
    $0.setBackgroundImage(UIImage(named: "calendarButton"), for: .normal)
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(60)
    }
  }
  
  
  private let writeDiarybutton = UIButton(type: .custom).then {
    $0.setBackgroundImage(UIImage(named:"writeButton"), for: .normal)
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(60)
    }
  }
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private lazy var customNavigationDelegate = CustomNavigationManager()
  
  // MARK: - ViewModel & bindingViewModel
  
  var viewModel: HomeMainViewModel
  
  func bindViewModel() {
    settingButton.rx.tap
      .bind(to: viewModel.input.settingButtonClicked)
      .disposed(by: disposeBag)
    
    bookmarkButton.rx.tap
      .bind(to: viewModel.input.bookmarkButtonClicked)
      .disposed(by: disposeBag)
    
    babyProfileImageView.rx
      .tapGesture()
      .when(.recognized)
      .map { _ in () }
      .withUnretained(self)
      .subscribe(onNext: { vc, void in
        vc.gotoBabyVC()
      })
      .disposed(by: disposeBag)
    
    writeDiarybutton.rx.tap
      .bind(to: viewModel.input.writeDiaryClicked)
      .disposed(by: disposeBag)
    
    calendarButton.rx.tap
      .bind(to: viewModel.input.calendarButtonClicked)
      .disposed(by: disposeBag)
    
    // MARK: - Output
    viewModel.output.diary
      .compactMap { $0 }
      .drive(onNext: { [weak self]  diary in
        self?.gotoTodayDiary(diary: diary)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotoDiaryInput
      .drive(onNext: { [weak self] in
        self?.gotoDiaryInputOption(viewModel: $0)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotoCalendar
      .debug()
      .drive(onNext: { [weak self] in
        guard let self = self else {return}
        let vc = CalendarViewController(viewModel: $0)
        self.customNavigationDelegate.direction = .bottom
        vc.transitioningDelegate = self.customNavigationDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotoBookmark
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        let destinationVC = BookmarkListViewController.loadFromStoryboard()
        self.customNavigationDelegate.direction = .left
        destinationVC.transitioningDelegate = self.customNavigationDelegate
        destinationVC.modalPresentationStyle = .custom
        self.present(destinationVC, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.gotoSetting
      .drive(onNext: { [weak self] vm in
        let pureCompletionHandler = {
          self?.pure(direction: .Out)
        }
        let vc = MyInfoMainViewController(viewModel: vm, completion: pureCompletionHandler)
        self?.pure(direction: .In, alpha: 1, speed: 0.3)
        vc.modalPresentationStyle = .overFullScreen
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.profileImage
      .map { UIImage(named: $0)! }
      .drive(babyProfileImageView.rx.image)
      .disposed(by: disposeBag)
    
    viewModel.output.toastMessage
      .drive(onNext: { [unowned self] in
        self.view.makeToast($0)
      })
      .disposed(by: disposeBag)
    
  }
  
  init(viewModel: HomeMainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
    NotificationCenter.default.addObserver(self, selector: #selector(changeBabyName), name: UserManager.didSetAppUserNotification, object: nil)
  }
  
  @objc private func changeBabyName() {
  }
  
  private func gotoDiaryInputOption(viewModel: DiaryInputOptionViewModel) {
    guard let diaryInputOptionVC = DiaryInputOptionViewController.loadFromStoryboard() as? DiaryInputOptionViewController else { return }
    diaryInputOptionVC.viewModel = viewModel
    diaryInputOptionVC.modalTransitionStyle = .crossDissolve
    diaryInputOptionVC.modalPresentationStyle = .overFullScreen
    self.present(diaryInputOptionVC, animated: true)
  }
  
  private func gotoTodayDiary(diary: DiaryEntity) {
    
    alertWithObservable(title: "작성한 일기 있음", text: "오늘은 이미 일기를 작성하셨습니다. 보러가실래요?")
      .bind(onNext: { _ in
        let datastore = MomoDiaryDataStore()
        let repo = MomoDiaryRepository(diaryDataStore: datastore)
//        repo.delete(diary: diary)
//          .subscribe(onCompleted: {
//            print("제거성공")
//          })
//          .dispose()
      })
      .disposed(by: disposeBag)
    
  }
}

// MARK: - Private Methods
extension HomeMainViewController {
 
  private func gotoBabyVC() {
    lazy var networkManager = NetworkManager()
    guard let token = UserManager.shared.token else { return }
    networkManager.request(apiModel: GetApi.babyGet(token: token)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = NetworkCoder()
        parsingManager.judgeGenericResponse(data: data, model: [BabyData].self) { [weak self] (body) in
          guard let self = self else {return}
          if body.count > 0 {
            let baby = body[0]
            DispatchQueue.main.async {
              guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
              babyInfoVC.babyViewModel = BabyInfoViewModel()
              babyInfoVC.babyViewModel?.model = baby
              self.present(babyInfoVC, animated: true, completion: nil)
            }
          } else  {
            DispatchQueue.main.async {
              guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
              babyInfoVC.babyViewModel = BabyInfoViewModel()
              self.present(babyInfoVC, animated: true, completion: nil)
            }
          }
        }
      case .failure(_):
        return
      }
    }
  }
  
}

// MARK: -  UI Setting
extension HomeMainViewController {
  
  private func assignbackground(){
    let background = UIImage(named: "mainBackground")
    
    var imageView : UIImageView!
    imageView = UIImageView(frame: view.bounds)
    imageView.contentMode =  UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = background
    imageView.center = view.center
    view.addSubview(imageView)
    self.view.sendSubviewToBack(imageView)
  }
  
  private func setupUI() {
    
    assignbackground()
    
    let stackview = UIStackView(arrangedSubviews: [calendarButton, writeDiarybutton]).then {
      $0.axis = .vertical
      $0.distribution = .fill
      $0.alignment = .fill
      $0.spacing = 14
    }
    
    view.addSubview(stackview)
    view.addSubview(bookmarkButton)
    view.addSubview(settingButton)
    view.addSubview(logoView)
    
    view.addSubview(imageHuggingView)
    
    logoView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
//      make.bottom.equalTo(imageHuggingView).inset(106)
    }
    
    bookmarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(logoView)
      make.left.equalToSuperview().inset(20)
    }
    
    settingButton.snp.makeConstraints { make in
      make.centerY.equalTo(logoView)
      make.right.equalToSuperview().inset(20)
    }
    
    imageHuggingView.snp.makeConstraints { make in
      make.top.equalTo(logoView.snp.bottom).inset(-106)
      make.centerX.equalToSuperview()
    }
    
    imageHuggingView.addSubview(babyProfileImageView)
    babyProfileImageView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview().inset(4)
    }
    
    stackview.snp.makeConstraints { make in
      make.right.bottom.equalToSuperview().inset(20)
    }
    
    
  }
  
  override func viewDidLayoutSubviews() {
    imageHuggingView.setRound()
    babyProfileImageView.setRound()
  }
  
  
}
