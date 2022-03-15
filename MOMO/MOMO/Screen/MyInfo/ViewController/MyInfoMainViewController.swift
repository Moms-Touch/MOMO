//
//  MyInfoMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MyInfoMainViewController: UIViewController, ViewModelBindableType {
  
  //MARK: - ViewModelBindableType

  func bindViewModel() {
    
    viewModel.output.nickName
      .distinctUntilChanged()
      .drive(nickname)
      .disposed(by: disposeBag)
    
    viewModel.output.email
      .distinctUntilChanged()
      .drive(email)
      .disposed(by: disposeBag)
    
    viewModel.output.description
      .distinctUntilChanged()
      .drive(userDescription)
      .disposed(by: disposeBag)
    
    viewModel.output.isLoggedIn
      .distinctUntilChanged()
      .drive(isLoggedIn)
      .disposed(by: disposeBag)
  }
  
  var viewModel: MyInfoViewModel
  //MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  //MARK: - Init
  init(viewModel: MyInfoViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Private
  
  private var nickname = BehaviorRelay<String?>(value: nil)
  private var email = BehaviorRelay<String?>(value: nil)
  private var userDescription = BehaviorRelay<String>(value: "대한민국에 사는 엄마")
  private var isLoggedIn = BehaviorRelay<Bool>(value: true)
  private var disposeBag = DisposeBag()

  //MARK: - UI
  
  let collectionView : UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = InfoMainConstant.lineSpacing
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    
    collectionView.backgroundColor = .clear
    collectionView.register(MyInfoCollectionViewCell.self)
    collectionView.isPagingEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  let navTitle = UILabel().then {
    $0.navTitleStyle()
    $0.text = InfoMainConstant.navTitle
  }
  
  let closeBar = UIView().then {
    $0.setRound()
    $0.backgroundColor = .systemGray3
  }
  
  let closeButton = UIButton().then {
    $0.setImage(InfoMainConstant.backbutton, for: .normal)
    $0.tintColor = Asset.Colors._45.color
  }
  
  private func setupUI() {
    
    view.addSubview(closeButton)
    view.backgroundColor = InfoMainConstant.backgroundColor
    
    closeButton.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(InfoMainConstant.verticalSpaing)
      make.width.height.equalTo(InfoMainConstant.buttonSize)
    }
    
    view.addSubview(navTitle)
    navTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(InfoMainConstant.navTitleSpacing)
      make.centerX.equalToSuperview()
      make.centerY.equalTo(closeButton)
    }
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
      make.top.equalTo(self.navTitle.snp.bottom).offset(InfoMainConstant.verticalSpaing)
    }
    
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

//MARK: - CollectionViewDatasource

extension MyInfoMainViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.defaultContent.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as! MyInfoCollectionViewCell
   
    if indexPath.item == InfoMainConstant.status.infoCell.rawValue {
            
      let cellmodel = MyInfoCellViewModel(index: indexPath.item, email: email, nickname: nickname, description: userDescription)
      cell.viewModel = cellmodel
      
    } else if indexPath.item == InfoMainConstant.status.changeCell.rawValue {
      cell.findCellheight(with: viewModel.defaultContent[indexPath.item])
      let cellmodel = InfoChangeCellViewModel(index: indexPath.item, content: viewModel.defaultContent[indexPath.item]!)
      cell.viewModel = cellmodel
    } else {
      cell.findCellheight(with: viewModel.defaultContent[indexPath.item])
      let cellmodel = InfoUserManageViewModel(index: indexPath.item, repository: viewModel.repository)
      cell.viewModel = cellmodel
    }

    return cell
  }
}


//MARK: - CollectionViewDelegateFlowLayout

extension MyInfoMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.size.width * InfoMainConstant.ratio
    let estimatedHeight: CGFloat = 50
    
    //더미셀을 활용해서 Cell의 최적화된 높이를 찾는다.
    let dummyCell = MyInfoCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
    dummyCell.findCellheight(with: viewModel.defaultContent[indexPath.item])
    dummyCell.layoutIfNeeded()
    let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))
    
    return CGSize(width: width, height: estimatedSize.height)
  }
}

//MARK: - Constant

enum InfoMainConstant {
  
  enum status: Int {
    case infoCell
    case changeCell
    case loggoutCell
  }
  
  static var lineSpacing: CGFloat {
    return 35
  }
  
  static var navTitle: String {
    return "마이 페이지"
  }
  
  static var navTitleSpacing: CGFloat {
    return 50
  }
  
  static var backbutton: UIImage {
    return UIImage(systemName: "chevron.left")!
  }
  
  static var buttonSize: CGFloat {
    return 24
  }
  
  static var verticalSpaing: CGFloat {
    return 20
  }
  
  static var backgroundColor: UIColor {
    return Asset.Colors.fa.color.withAlphaComponent(0.8)
  }
  
  static var ratio: Double {
    return 0.8
  }
  
}

