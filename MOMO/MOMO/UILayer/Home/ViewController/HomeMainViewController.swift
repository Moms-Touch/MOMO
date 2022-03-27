//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import RealmSwift

final class HomeMainViewController: UIViewController, StoryboardInstantiable, Dimmable, UIViewControllerTransitioningDelegate, BackgroundPureable {
  
  @IBOutlet weak var bannerCollectionView: UICollectionView! {
    didSet {
      bannerCollectionView.backgroundColor = Asset.Colors.fa.color.withAlphaComponent(0.5)
      bannerCollectionView.delegate = self
      bannerCollectionView.dataSource = self
      bannerCollectionView.register(BannerCell.self)
      bannerCollectionView.isPagingEnabled = true
      bannerCollectionView.showsHorizontalScrollIndicator = false
      
    }
  }
  @IBOutlet weak var imageHuggingView: UIView!
  @IBOutlet weak var babyProfileImageView: UIImageView! {
    didSet {
      babyProfileImageView.isUserInteractionEnabled = true
      let tapgesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoBabyVC(_:)))
      babyProfileImageView.addGestureRecognizer(tapgesture)
    }
  }
  
  @IBOutlet weak var settingButton: UIButton!
  
  //banner의 현재 페이지
  private var currentPage = 0
  private var datasource: [NoticeData] = []
  
  //networking
  lazy var networkManager = NetworkManager()
  lazy var customNavigationDelegate = CustomNavigationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
    changeButtonTitle()

    NotificationCenter.default.addObserver(self, selector: #selector(changeBabyName), name: UserManager.didSetAppUserNotification, object: nil)
    bannerCollectionView.isHidden = true
  }
  
  @objc func changeBabyName() {
    DispatchQueue.main.async {
      self.changeButtonTitle()
    }
  }
  
  private func changeButtonTitle() {
    guard let userInfo = UserManager.shared.userInfo else {
      print("로그인을 해주세요")
      return}
    
    guard let babyBirth = UserManager.shared.babyInWeek else {
      self.view.makeToast("아이의 생일을 다시 입력해주세요")
      return}
    guard let babyName = userInfo.baby?.first?.name else {
      return
    }
    if let imageUrl = userInfo.baby?.first?.imageUrl {
      self.babyProfileImageView.setImage(with: imageUrl)
    } else {
      self.babyProfileImageView.image = UIImage(named: "mascot")
      self.view.makeToast("가운데 버튼을 눌러서, 아이의 사진으로 변경해보아요🤰")
    }
  }
  
  override func viewDidLayoutSubviews() {
    imageHuggingView.setRound()
    babyProfileImageView.setRound()
  }
  
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
  
  @IBAction private func didTapTodayButton(_ sender: UIButton) {
    
    /// 이미 일기를 작성했는지 확인
    /// Realm 에 데이터가 있는지?
    let realm = try! Realm()
    
    /// 오늘 날짜의 00시 00분
    let targetDate = Date().timeToZero()
    
    let targetDiary = realm.objects(Diary.self).where {
      $0.date == targetDate
    }
    
    /// 이미 일기를 작성했다면
    guard let diary = targetDiary.first else {
      
      /// 작성된 일기가 없다면
      /// 일기 작성 화면
      
      let diaryInputOptionVC = DiaryInputOptionViewController.loadFromStoryboard()
      
      diaryInputOptionVC.hidesBottomBarWhenPushed = true
      
      self.show(diaryInputOptionVC, sender: nil)
      
      return
    }
    
    // FIXME: AlertVC 모듈화
    let alertVC = UIAlertController(title: "작성한 일기 있음", message: "오늘은 이미 일기를 작성하셨습니다. 보러가실래요?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "보러갈래요", style: .default) { action in
      
      /// 일기 상세 화면
      
      let readDiaryVC = ReadDiaryViewController.make(with: diary)
      
      self.show(readDiaryVC, sender: nil)
    }
    
    let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
    
    alertVC.addAction(okAction)
    alertVC.addAction(cancelAction)
    
    self.present(alertVC, animated: true, completion: nil)
    
  }
  
  
  @IBAction func didTapBellButton(_ sender: UIButton) {
    gotoMyProfile()
  }
  
  @objc private func gotoBabyVC(_ sender: Any?) {
    gotoBabyVC()
  }
  
  private func gotoBabyVC() {
    
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
  
  func makeCalendarViewModel() -> CalendarViewModel {
    let datastore = MomoDiaryDataStore()
    let repository = MomoDiaryRepository(diaryDataStore: datastore)
    let usecase = MomoCalendarUseCase(repository: repository, baseDate: Date())
    return CalendarViewModel(calendarUseCase: usecase)
  }
  
  @IBAction private func gotoCalender(_ sender: UIButton) {
    let vm = makeCalendarViewModel()
    let vc = CalendarViewController(viewModel: vm)
    customNavigationDelegate.direction = .bottom
    vc.transitioningDelegate = customNavigationDelegate
    vc.modalPresentationStyle = .custom
    present(vc, animated: true, completion: nil)
  }
  
  func makeMyInfoViewModel() -> MyInfoViewModel {
    
    //Dependencies
    let coder = NetworkCoder()
    let networkManager = NetworkManager(session: URLSession.shared, coder: coder)
    let remoteAPI = MomoUserRemoteAPI(networkManager: networkManager, decoder: coder)
    let datastore = MomoUserSessionDataStore(userManager: UserManager.shared, keychainService: KeyChainService.shared)
    let repository = MomoUserSessionRepository(remoteAPI: remoteAPI, dataStore: datastore)

    return MyInfoViewModel(repository: repository)
  }
  
  private func gotoMyProfile() {
    let viewModel = makeMyInfoViewModel()
    let pureCompletionHandler = { [weak self] in
      self?.pure(direction: .Out)
    }
    let vc = MyInfoMainViewController(viewModel: viewModel, completion: pureCompletionHandler)
    self.pure(direction: .In, alpha: 1, speed: 0.3)
    vc.modalPresentationStyle = .overFullScreen
    present(vc, animated: true, completion: nil)
  }
}

extension HomeMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datasource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else {return BannerCell()}
    cell.data = datasource[indexPath.row]
    return cell
  }
  
}

extension HomeMainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
  }
  
  // collectionview의 감속이 끝날때 현재 페이지 체크
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  // 배너 타이머
  private func bannerTimer() {
    let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] (timer) in
      self?.bannerMove()
    }
  }
  
  //배너가 돌아가는 애니메이션 + 페이지네이션하는 로직
  private func bannerMove() {
    if currentPage == datasource.count - 1 {
      
      currentPage = 0
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let self = self else {return}
        self.bannerCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
      }
      
    } else {
      currentPage += 1
      UIView.animate(withDuration: 1.0) { [weak self] in
        guard let self = self else {return}
        self.bannerCollectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .bottom, animated: false)
      }
      
    }
  }
  
}

extension HomeMainViewController {
  @IBAction private func didTapBookmarkListButton(_ sender: UIButton) {
    let destinationVC = BookmarkListViewController.loadFromStoryboard()
    customNavigationDelegate.direction = .left
    destinationVC.transitioningDelegate = customNavigationDelegate
    destinationVC.modalPresentationStyle = .custom
    present(destinationVC, animated: true, completion: nil)
  }
}

