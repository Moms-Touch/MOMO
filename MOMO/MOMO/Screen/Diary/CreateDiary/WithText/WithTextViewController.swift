//
//  WithTextViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

class WithTextViewController: UIViewController, StoryboardInstantiable {
  
  static var storyboardName: String = "WithText"

  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var pageControl: UIPageControl!
  
  var hasGuide: Bool {
    
    return numOfCells == 3 ? true : false
  }
  
  var numOfCells: Int?
  
  var defaultQuestion = "자유롭게 일기를 작성해주세요."
  
  var questionManager = DiaryQuestionManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpCollectionView()
    
    setUpPageControl()
  }
  
  private func setUpCollectionView() {
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(WithTextCollectionViewCell.nib, forCellWithReuseIdentifier: WithTextCollectionViewCell.identifier)
    
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false

    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
  }
  
  
  private func setUpPageControl() {
    
    ///numOfCells 는 inputType 의 hasGuide 로 정해진다
    ///
    /// 가이드가 있으면 컬렉션 뷰셀의 개수는 3
    ///
    /// 가이드가 없으면 컬렉션 뷰셀의 개수는 1 + 페이지 컨트롤은 숨겨져야한다

    pageControl.isHidden = hasGuide ? false : true
  }


}

extension WithTextViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return numOfCells ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithTextCollectionViewCell.identifier, for: indexPath) as? WithTextCollectionViewCell else { return UICollectionViewCell() }
    
    cell.backgroundColor = Asset.Colors.pink5.color
    
    if hasGuide {
      
      cell.questionLabel.text = questionManager.guideQuestionList[indexPath.row]
      
    } else {
      
      cell.questionLabel.text = defaultQuestion
      
    }
    
    cell.widthAnchor.constraint(equalToConstant: collectionView.frame.width).isActive = true
    cell.heightAnchor.constraint(equalToConstant: collectionView.frame.height).isActive = true
    
    cell.tag = indexPath.row
    
    return cell
  }
}

extension WithTextViewController: UICollectionViewDelegate {
  
}

extension WithTextViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
}

extension WithTextViewController {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {

    pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
  }
}
