//
//  RecommendViewController.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class RecommendViewController: UIViewController {
  
  //MARK: - UI
  let collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    
    layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 30
    layout.minimumInteritemSpacing = 10
    
    let twoCardWidth: CGFloat = UIScreen.main.bounds.width / 2
    let size = RecommendCollectionViewCell.fittingSize(width: twoCardWidth - 40)
    layout.itemSize = size
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(RecommendCollectionViewCell.self)
    return collectionView
  }()

  let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "12주차 모모님을 위한 추천정보"
    $0.font = .customFont(forTextStyle: .title1)
  }
  
  func goToDetail(viewModel: RecommendDetailViewModel) {
    guard let vc = RecommendDetailViewController.loadFromStoryboard() as? RecommendDetailViewController
    else {return}
    vc.transitioningDelegate = self
    vc.viewModel = viewModel
    present(vc, animated: true, completion: nil)
  }
  
 
  //MARK: - BindViewModel
  var viewModel: RecommendViewModel
  
  func bindViewModel() {
    
    viewModel.output.title
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.gotoDetail
      .throttle(.seconds(1))
      .compactMap {$0}
      .drive(onNext: { [weak self] in
        self?.goToDetail(viewModel: $0)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.datasource
      .drive(collectionView.rx.items(cellIdentifier: RecommendCollectionViewCell.identifier, cellType: RecommendCollectionViewCell.self)) {
        index, data, cell in
        cell.configure(data: data)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .withUnretained(self)
      .subscribe(onNext: { vc, indexpath in
        vc.selectedCell = vc.collectionView.cellForItem(at: indexpath) as? RecommendCollectionViewCell
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(InfoData.self)
      .bind(to: viewModel.input.tappedInfoData)
      .disposed(by: disposeBag)
  
  }
  
  //MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var selectedCell: RecommendCollectionViewCell?
  private let transition = PopAnimator()

  
  //MARK: - Init

  init(viewModel: RecommendViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
  }
  
}

extension RecommendViewController {
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
    }
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
    }
    
  }
}

// MARK: Animation
extension RecommendViewController: UIViewControllerTransitioningDelegate {
  
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


