//
//  HomeMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit

final class HomeMainViewController: UIViewController, StoryboardInstantiable, Dimmable {
  
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
  lazy var customNavigationDelegate = CustomNavigationManager()
  private var datasource: [NoticeData] = [NoticeData(id: 1, author: "관리자", title: "공지사항1", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 2, author: "관리자", title: "공지사항2", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 3, author: "관리자", title: "공지사항3", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 4, author: "관리자", title: "공지사항4", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12"), NoticeData(id: 5, author: "관리자", title: "공지사항5", url: "www.naver.com", createdAt: "2012.11.12", updatedAt: "2012.11.12")]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignbackground()
    bannerTimer()
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
  
  @IBAction private func didTapRecommendButton(_ sender: UIButton) {
    let recommendModalVC = RecommendModalViewController()
    recommendModalVC.modalPresentationStyle = .custom
    recommendModalVC.transitioningDelegate = self
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

extension HomeMainViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    if presented is RecommendModalViewController {
      return PresentationController(presentedViewController: presented, presenting: presenting)
    } else {
      return nil
    }
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
    print(view.frame.size)
    print(bannerCollectionView.frame.size)
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

