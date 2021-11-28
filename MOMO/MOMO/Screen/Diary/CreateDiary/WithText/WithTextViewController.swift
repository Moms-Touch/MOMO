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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpCollectionView()
  }
  
  func setUpCollectionView() {
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(WithTextCollectionViewCell.nib, forCellWithReuseIdentifier: WithTextCollectionViewCell.identifier)
    
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false

    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
  }


}

extension WithTextViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithTextCollectionViewCell.identifier, for: indexPath) as? WithTextCollectionViewCell else { return UICollectionViewCell() }
    
    cell.backgroundColor = Asset.Colors.pink5.color
    
    cell.questionLabel.text = "질문+\(indexPath.row)"
    cell.answerTextView.text = "대답대답"
    
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
