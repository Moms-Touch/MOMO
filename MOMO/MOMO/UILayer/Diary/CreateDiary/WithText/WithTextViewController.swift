//
//  WithTextViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

import RxSwift
import RxCocoa

class WithTextViewController: ViewController, ViewModelBindableType {
  
  // MARK: - UI
  
  private lazy var collectionView: UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  // MARK: - ViewModel & Binding
  var viewModel: WithTextViewModel
  
  func bindViewModel() {
    
    // MARK: - Input
    
    // MARK: - Output
    viewModel.output.datasource
      .drive(collectionView.rx.items(cellIdentifier: WithTextCollectionViewCell.identifier, cellType: WithTextCollectionViewCell.self)){
        index, item, cell in
        cell.configure(with: WithTextCellViewModel(question: item, index: "\(index + 1)/3"))
      }
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Init
  
  init(viewModel: WithTextViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview()
    }
    collectionView.register(WithTextCollectionViewCell.self)
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }

}

extension WithTextViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

}

//extension WithTextViewController: UITextViewDelegate {
//  
//  func textViewDidChange(_ textView: UITextView) {
//    
//    /// textView -> contentView -> Cell
//    guard let cell = textView.superview?.superview as? WithTextCollectionViewCell else { return }
//    
//    /// 가이드가 있으면
//    if hasGuide {
//      
//      qnaList.updateValue(textView.text, forKey: cell.questionLabel.text!)
//
//      /// 가이드가 없으면
//    } else {
//      
//      qnaList.updateValue(textView.text, forKey: defaultQuestion)
//    }
//  }
//  
//}
