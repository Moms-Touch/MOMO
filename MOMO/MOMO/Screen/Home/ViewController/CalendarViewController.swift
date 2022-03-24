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
    return collectionView
    
  }()
  
  
  // MARK: - Viewmodel & BindViewModel
  
  func bindViewModel() {
    
  }

  var viewModel: CalendarViewModel
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()

  // MARK: - init
  
  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CalendarCollectionViewCell.self)
  }
}

// MARK: - UICollectionViewDatasource
extension CalendarViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    <#code#>
  }

  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
  
  

}

// MARK: - UICollctionViewDelegateFlowlayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
  
}


