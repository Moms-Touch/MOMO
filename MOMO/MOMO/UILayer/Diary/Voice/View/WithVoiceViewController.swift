//
//  WithVoiceViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/12/31.
//

import UIKit

import RxCocoa
import RxSwift

final class WithVoiceViewController: UIViewController  {
  
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
  
  var editViewModel: WithVoiceViewModel?
  var showViewModel: ReadContentViewModel?
  
  func bindViewModel() {
    // MARK: - 일기작성일때 viewmodel
    if let viewModel = editViewModel {
      viewModel.output.questionCount
        .drive(questionCount)
        .disposed(by: disposeBag)
      
      viewModel.output.datasource
        .drive(collectionView.rx.items(cellIdentifier: WithVoiceCollectionViewCell.identifier, cellType: WithVoiceCollectionViewCell.self)){
          index, item, cell in
          cell.configure(with: WithVoiceCellModel(question: item, voiceRecordHelper: viewModel, index: index))
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - 일기보기모드일때 viewmodel
    if let viewModel = showViewModel {
      
      viewModel.output.qnaList
        .map { return $0.count }
        .drive(questionCount)
        .disposed(by: disposeBag)
      
      viewModel.output.qnaList
        .drive(collectionView.rx.items(cellIdentifier: WithVoiceCollectionViewCell.identifier, cellType: WithVoiceCollectionViewCell.self)) {
          index, item, cell in
          cell.configure(with: ReadVoiceCellViewModel(question: item.0, recordPlayerPreparable: viewModel, recordPlayer: MomoRecordPlayer(date: viewModel.diaryDate, index: index)))
        }
        .disposed(by: disposeBag)
    }
    
    
  }
  
  init(withVoiceViewModel: WithVoiceViewModel? = nil, readVoiceViewModel: ReadContentViewModel? = nil) {
    self.editViewModel = withVoiceViewModel
    self.showViewModel = readVoiceViewModel
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
