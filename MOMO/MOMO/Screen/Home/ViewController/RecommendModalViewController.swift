//
//  RecommendModalViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import SnapKit

class RecommendModalViewController: UIViewController {
  
  private var datasource: [Int] = [1,2,3,4,5,6]
  private let collectionViewHeight: CGFloat = 150
  internal var completionHandler: (()->())?
  internal var selectedCell: RecommendCollectionViewCell?
  
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
    recommendCollectionView.register(RecommendCollectionViewCell.self)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
    view.addGestureRecognizer(panGesture)
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
      
      // 내리는 속도에 따라서
      let dragVelocity = sender.velocity(in: view)
      if dragVelocity.y >= 1300, let completion = completionHandler {
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
    recommendCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    recommendCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    recommendCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight.fit(self)).isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datasource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else {return RecommendCollectionViewCell()}
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: recommendCollectionView.frame.height, height: recommendCollectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = RecommendDetailViewController.loadFromStoryboard()
    vc.isModalInPresentation = true
    present(vc, animated: true, completion: nil)
  }
  
}
