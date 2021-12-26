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
      //Usermodel을 observing 하고 있어야함
    }
  }
  
  @IBOutlet weak var dateWithBabyButton: UIButton! {
    didSet {
      dateWithBabyButton.setRound()
      dateWithBabyButton.backgroundColor = .white
      //Usermodel을 observing 하고 있어야함
    }
  }
  
  private var currentPage = 0
  lazy var networkManager = NetworkManager()
  lazy var customNavigationDelegate = CustomNavigationManager()
  private var datasource: [NoticeData] = [NoticeData(id: 1, author: "관리자", title: "공지사항1", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 2, author: "관리자", title: "공지사항2", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 3, author: "관리자", title: "공지사항3", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 4, author: "관리자", title: "공지사항4", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 5, author: "관리자", title: "공지사항5", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12")]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
    bannerTimer()
    getNotice()
    testPolicy()
  }
  
  override func viewDidLayoutSubviews() {
    imageHuggingView.setRound()
    babyProfileImageView.setRound()
  }
  
  private func testPolicy() {
    networkManager.request(apiModel: GetApi.policyGet(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjksImVtYWlsIjoieWJAa2ltLmNvbSIsIm5hbWUiOiJ5YmtpbSIsImlhdCI6MTY0MDE4NjE1MCwiZXhwIjoxNjQwNDQ1MzUwLCJpc3MiOiJtb21vIn0.4TtHoK5dpdebtC8vyUc0XCMkCW3SAW9B6vz6_WgKYcU", keyword: nil, location: nil, category: "law", page: nil)) { result in
      switch result {
      case.success(let data):
        let parsingmanager = ParsingManager()
        parsingmanager.judgeGenericResponse(data: data, model: [SimpleCommunityData].self) { data in
          print(data)
        }
      case .failure(let error):
        print(error)
      }
    }
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
    dim(direction: .In, color: .black, alpha: 0.5, speed: 0.3)
    recommendModalVC.completionHandler = { [weak self] in
      self?.dim(direction: .Out)
    }
    present(recommendModalVC, animated: true, completion: nil)
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
    //여기서 바로 safari로 넘겨야할듯
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
  
  private func bannerTimer() {
    let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] (timer) in
      self?.bannerMove()
    }
  }
  
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

