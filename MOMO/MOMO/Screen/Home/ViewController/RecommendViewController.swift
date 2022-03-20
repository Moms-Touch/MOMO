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
    
    layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    
    let twoCardWidth: CGFloat = UIScreen.main.bounds.width / 2
    layout.itemSize = CGSize(width: twoCardWidth - 50, height: 240)
    
    
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

  
  //MARK: - BindViewModel
  var viewModel: RecommendViewModel
  
  func bindViewModel() {
    
    func goToDetail(info: InfoData) {
      guard let vc = RecommendDetailViewController.loadFromStoryboard() as? RecommendDetailViewController
      else {return}
      vc.data = info
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    viewModel.output.gotoDetail
      .compactMap { $0 }
      .throttle(.seconds(1))
      .drive(onNext: {
//        goToDetail(info: $0)
        print($0)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.datasource
      .drive(collectionView.rx.items(cellIdentifier: RecommendCollectionViewCell.identifier, cellType: RecommendCollectionViewCell.self)) {
        index, data, cell in
        cell.data = data
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(InfoData.self)
      .bind(to: viewModel.input.tappedInfoData)
      .disposed(by: disposeBag)
  
  }
  
  //MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
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
  }
  
}

extension RecommendViewController {
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
    }
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
    }
    
  }
}
