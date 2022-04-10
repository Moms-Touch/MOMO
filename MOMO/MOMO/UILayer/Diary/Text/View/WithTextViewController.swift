//
//  WithTextViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/27.
//

import UIKit

import RxSwift
import RxCocoa

class WithTextViewController: ViewController {
  
  // MARK: - UI
  
  private lazy var collectionView: UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  // MARK: - ViewModel & Binding
  var editViewModel: WithTextViewModel?
  var showViewModel: ReadContentViewModel?
  
  func bindViewModel() {
    
    if let viewModel = editViewModel {
      viewModel.output.datasource
        .drive(collectionView.rx.items(cellIdentifier: WithTextCollectionViewCell.identifier, cellType: WithTextCollectionViewCell.self)){
          index, item, cell in
          cell.configure(with: WithTextCellViewModel(question: item, index: "\(index + 1)/3", qnaRelay: viewModel))
        }
        .disposed(by: disposeBag)
      
      //요런것도 viewmodel로 값을 옮긴다음에 빼야할까?
      keyboardHeight()
        .map { return $0 > 0 ? false : true }
        .bind(to: collectionView.rx.isScrollEnabled)
        .disposed(by: disposeBag)
    }
   
    if let viewModel = showViewModel {
      viewModel.output.qnaList
        .drive(collectionView.rx.items(cellIdentifier: WithTextCollectionViewCell.identifier, cellType: WithTextCollectionViewCell.self)){
          index, item, cell in
          cell.configure(with: ReadTextCellViewModel(question: item.0, answer: item.1, index: "\(index + 1)/3"))
        }
        .disposed(by: disposeBag)

    }
  
  }
  
  // MARK: - Init
  
  init(withTextViewModel: WithTextViewModel? = nil, readTextViewModel: ReadContentViewModel? = nil) {
    self.editViewModel = withTextViewModel
    self.showViewModel = readTextViewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
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

