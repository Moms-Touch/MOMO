//
//  WithVoiceViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit

import RxCocoa
import RxSwift

final class WithVoiceViewController: UIViewController, ViewModelBindableType  {
  
  // MARK: - UI
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  private var questionCount = BehaviorRelay<Int>(value: 1)
  
  // MARK: - ViewModel & Binding
  
  var viewModel: WithVoiceViewModel
  
  func bindViewModel() {
    
    viewModel.output.questionCount
      .drive(questionCount)
      .disposed(by: disposeBag)
    
    viewModel.output.datasource
      .drive(collectionView.rx.items(cellIdentifier: WithVoiceCollectionViewCell.identifier, cellType: WithVoiceCollectionViewCell.self)){ [weak self]
        index, item, cell in
        guard let self = self else {return}
        cell.configure(with: WithVoiceCellModel(question: item, voiceRecordHelper: self.viewModel))
      }
      .disposed(by: disposeBag)
    
  }
  
  init(viewModel: WithVoiceViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

extension WithVoiceViewController {
  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview()
    }
    collectionView.register(WithVoiceCollectionViewCell.self)
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

extension WithVoiceViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let height = collectionView.frame.height / CGFloat(questionCount.value)
    let width = collectionView.frame.width
    
    return CGSize(width: width, height: height)
    
  }
}



//let alertVC = UIAlertController(title: "에러 발생", message: "잠시 뒤에 다시 시도해 주세요", preferredStyle: .alert)
//
//alertVC.addAction(UIAlertAction.okAction)
//
//present(alertVC, animated: true)
