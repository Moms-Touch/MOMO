//
//  RecommendModalViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import SnapKit

class RecommendModalViewController: UIViewController {
  
  private var datasource: [InfoData] = []
  private let collectionViewHeight: CGFloat = 150
  internal var completionHandler: (()->())?
  internal var selectedCell: RecommendCollectionViewCell?
  private let transition = PopAnimator()
  
  lazy var closeIndicator: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
    view.setRound()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemGray3
    return view
  }()
  
  lazy var recommendCollectionView: UICollectionView = {
    let flowlayout = UICollectionViewFlowLayout()
    flowlayout.scrollDirection = .horizontal
    flowlayout.minimumLineSpacing = 35
    flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    view.backgroundColor = .white
    view.isPagingEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.bounces = false
    view.alwaysBounceHorizontal = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "12주차 소미님을 위한 추천 정보"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var hasSetPointOrigin = false
  private var pointOrigin: CGPoint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setDelegate()
    setuplayout()
    print("숫자", datasource.count)
    recommendCollectionView.register(RecommendCollectionViewCell.self)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
    view.addGestureRecognizer(panGesture)
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
  }
  
  internal func setData(data: [InfoData]) {
    self.datasource = data
  }
  
}

//MARK: - PanGesture for HalfModal

extension RecommendModalViewController {
  
  override func viewDidLayoutSubviews() {
    if !hasSetPointOrigin {
      hasSetPointOrigin = true
      pointOrigin = self.view.frame.origin
    }
  }
  
  @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    
    //위로 올리는 제스쳐는 안되게 함
    guard translation.y >= 0 else {return}
    
    //양 옆으로는 움직이지 못하게함
    view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
    
    if sender.state == .ended {
      
      // 원래 크기의 반보다 아래라면?
      if translation.y > view.frame.height / 2, let completion = completionHandler{
        completion()
        self.dismiss(animated: true, completion: nil)
      } else {
        UIView.animate(withDuration: 0.3) {
          self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
        }
      }
    }
  }
}

//MARK: - CollectionView Setting

extension RecommendModalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private func setDelegate() {
    recommendCollectionView.delegate = self
    recommendCollectionView.dataSource = self
  }
  
  private func setuplayout() {
    view.addSubview(closeIndicator)
    view.addSubview(titleLabel)
    view.addSubview(recommendCollectionView)
    closeIndicator.snp.makeConstraints { make in
      make.top.equalTo(self.view).offset(10)
      make.centerX.equalTo(self.view)
      make.width.equalTo(30)
      make.height.equalTo(3)
    }
    titleLabel.snp.makeConstraints{ make in
      make.top.equalTo(self.view).offset(20)
      make.left.equalTo(self.view).offset(20)
    }
    recommendCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    recommendCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    recommendCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    recommendCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight.fit(self)).isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if datasource.count % 2 != 0 {
      return datasource.count + 1
    }
    return datasource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else {return RecommendCollectionViewCell()}
    
    // 홀수일 경우 paging을 위해서 빈 셀을 하나 더 만들어준다.
    if datasource.count % 2 != 0 && indexPath.row == datasource.count{
      cell.thumbNailImageView.image = nil
      cell.titleLabel.text = ""
      cell.isUserInteractionEnabled = false
    } else {
      cell.thumbNailImageView.image = UIImage(named: "Logo")
      cell.titleLabel.text = "도레미"
      cell.isUserInteractionEnabled = true
      cell.getData(data: datasource[indexPath.row])
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: recommendCollectionView.frame.height, height: recommendCollectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCell = collectionView.cellForItem(at: indexPath) as? RecommendCollectionViewCell
    guard let vc = RecommendDetailViewController.loadFromStoryboard() as? RecommendDetailViewController else {return}
    if let data = selectedCell?.data {
      vc.data = data
      vc.index = indexPath.item
    }
    vc.postCompletionHandler = { [weak self] id in
      guard let self = self else {return}
      for index in self.datasource.indices {
        if self.datasource[index].id == id {
          self.datasource[index].isBookmark = true
          self.recommendCollectionView.reloadData()
          return
        }
      }
    }
    vc.deleteCompletionHandler = { [weak self] index in
      guard let self = self else {return}
      self.datasource.remove(at: index)
      self.recommendCollectionView.reloadData()
      return
    }
    vc.transitioningDelegate = self
    present(vc, animated: true, completion: nil)
  }
  
}

extension RecommendModalViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.originFrame = selectedCell!.superview!.convert(selectedCell!.frame, to: nil)
    transition.presenting = true
    selectedCell!.isHidden = true
    
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    return transition
  }
  
}
