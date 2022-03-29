//
//  CalendarViewController.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class CalendarViewController: UIViewController, ViewModelBindableType {
  
  // MARK: - UI
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    return collectionView
    
  }()
  
  private let footerView = UIImageView().then {
    $0.image = UIImage(named: "calendarBackground")!
    $0.contentMode = .scaleToFill
  }

  
  // MARK: - Viewmodel & BindViewModel
  
  func bindViewModel() {
    viewModel.output.days
      .drive(collectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) {
        index, data, cell in
        cell.configure(day: data, index: index)
      }
      .disposed(by: disposeBag)
    
    Observable.zip(collectionView.rx.itemSelected,
                   collectionView.rx.modelSelected(Day.self))
    .bind(to: viewModel.input.didSelectCell)
    .disposed(by: disposeBag)
    
    viewModel.output.numberOfWeeksInBaseDate
      .drive(numberOfWeeksInBaseDate)
      .disposed(by: disposeBag)
    
    viewModel.output.closeView
      .drive(onNext: { [unowned self] in
        self.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }

  var viewModel: CalendarViewModel
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let days = BehaviorRelay<[Day]>(value: [])
  private let numberOfWeeksInBaseDate = BehaviorRelay<Int>(value: 0)
  
  // MARK: - init
  
  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  
}

// MARK: - SetupUI
extension CalendarViewController {
  private func setupUI() {
    view.backgroundColor = .white
    collectionView.register(CalendarCollectionViewCell.self)
    
    let headerview = CalendarHeaderView(viewModel: viewModel.output.calendarHeaderViewModel).then {
      $0.backgroundColor = .white
    }
  
    view.addSubview(headerview)
    view.addSubview(footerView)
    view.addSubview(collectionView)
    
    footerView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(collectionView.snp.top)
      make.bottom.equalTo(collectionView.snp.bottom).offset(150)
    }
    
    headerview.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(collectionView.snp.top)
      make.height.equalTo(110)
    }
    
    collectionView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.height.equalTo(collectionView.snp.width).multipliedBy(0.8)
    }
  }
}

// MARK: - DelegateFlowLayout

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate.value
    return CGSize(width: width, height: height)
  }
  
}



