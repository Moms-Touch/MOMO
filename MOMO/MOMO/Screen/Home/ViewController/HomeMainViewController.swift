//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit

final class HomeMainViewController: UIViewController, StoryboardInstantiable, Dimmable, UIViewControllerTransitioningDelegate {
  
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
      let tapgesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoMyProfile(_:)))
      babyProfileImageView.addGestureRecognizer(tapgesture)
    }
  }
  
  @IBOutlet weak var bellButton: UIButton! {
    didSet {
      bellButton.isHidden = true
    }
  }
  @IBOutlet weak var dateWithBabyButton: UIButton! {
    didSet {
      dateWithBabyButton.setRound()
      dateWithBabyButton.backgroundColor = .white
      
      //Usermodel을 observing 하고 있어야함
    }
  }
  
  //banner의 현재 페이지
  private var currentPage = 0
  private var datasource: [NoticeData] = []
  
  //networking
  lazy var networkManager = NetworkManager()
  lazy var customNavigationDelegate = CustomNavigationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
    getNotice()
    changeBabyName()
    NotificationCenter.default.addObserver(self, selector: #selector(changeBabyName), name: UserManager.didSetAppUserNotification, object: nil)
  }
  
  @objc func changeBabyName() {
    guard let userInfo = UserManager.shared.userInfo else {
      print("로그인을 해주세요")
      return}
      guard let babyBirth = UserManager.shared.babyInWeek else {
        self.dateWithBabyButton.setTitle("생일 등록하기", for: .normal)
        return}
      guard let babyName = userInfo.baby?.first?.name else {
        self.dateWithBabyButton.setTitle("아이 이름 등록하기", for: .normal)
        return
      }
      guard let imageUrl = userInfo.baby?.first?.imageUrl else {
        self.babyProfileImageView.image = UIImage(named: "Logo")
        return
      }
      self.babyProfileImageView.setImage(with: imageUrl)
      self.dateWithBabyButton.setTitle("\(babyName) \(babyBirth)", for: .normal)
      self.dateWithBabyButton.sizeToFit()
  }
  
  override func viewDidLayoutSubviews() {
    imageHuggingView.setRound()
    babyProfileImageView.setRound()
  }
  
  private func getNotice() {
    networkManager.request(apiModel: GetApi.noticeGet) { result in
      switch result {
      case.success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [NoticeData].self) { data in
          DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.datasource = data
            self.bannerCollectionView.reloadData()
            self.bannerTimer()
          }
        }
      case .failure(let error):
        print(error)
      }
    }
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
  
  @IBAction private func didTapRecommendButton(_ sender: UIButton) {
    let recommendModalVC = RecommendModalViewController()
    customNavigationDelegate.direction = .bottom
    recommendModalVC.transitioningDelegate = customNavigationDelegate
    recommendModalVC.modalPresentationStyle = .custom
    // networking
    guard let token = UserManager.shared.token else {return}
    guard let period = UserManager.shared.periodOfWeek else {return}
    networkManager.request(apiModel: GetApi.infoGet(token: token, start: "\(period.0)", end: "\(period.1)")) { (result) in
      switch result {
      case .success(let data):
        let parsingmanager = ParsingManager()
        parsingmanager.judgeGenericResponse(data: data, model: [InfoData].self) { [weak self] body in
          guard let self = self else {return}
          recommendModalVC.setData(data: body)
          DispatchQueue.main.async {
            self.dim(direction: .In, color: .black, alpha: 0.5, speed: 0.3)
            recommendModalVC.completionHandler = { [weak self] in
              self?.dim(direction: .Out)
            }
            self.present(recommendModalVC, animated: true, completion: nil)
          }
        }
      case .failure(let error):
        fatalError("\(error)")
      }
    }
  }
  
  @IBAction private func didTapTodayButton(_ sender: UIButton) {
    print(#function)
  }
  
  
  @IBAction func didTapBellButton(_ sender: UIButton) {
    self.navigationController?.pushViewController(AlertViewController.loadFromStoryboard(), animated: true)
  }
  
  @IBAction private func didTapProfile(_ sender: Any) {
    gotoMyProfile()
  }
  
  @objc private func gotoMyProfile(_ sender: Any?) {
    gotoMyProfile()
  }
  
  private func gotoMyProfile() {
    self.navigationController?.pushViewController(MyInfoMainViewController.loadFromStoryboard(), animated: true)
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let url = datasource[indexPath.row].url
    let storyboard = UIStoryboard.init(name: "MySetting", bundle: nil)
    guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingWebViewController") as? SettingWebViewController else {return}
    vc.targetURL = URL(string: url)!
    present(vc, animated: true, completion: nil)
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

