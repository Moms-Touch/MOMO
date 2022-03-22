//
//  RecommendViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/20.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendViewModel {
  
  //MARK: - Input
  
  struct Input {
    var tappedInfoData: AnyObserver<InfoData?>
  }
  
  var input: Input
  
  //MARK: - Output
  
  struct Output {
    var datasource: Driver<[InfoData]>
    var gotoDetail: Driver<InfoData?>
  }
  
  var output: Output
  
  //MARK: - Private
  private let repository: RecommendRepository
  
  private let tappedInfoData = BehaviorSubject<InfoData?>(value: nil)
  private let goToDetail = PublishRelay<InfoData?>()
  private var disposeBag = DisposeBag()
  //MARK: - Init
  
  init(reposoitory: RecommendRepository) {
    self.repository = reposoitory
    let datasource = BehaviorRelay<[InfoData]>(value: [])
    
    self.repository.getRecommendInfo()
      .bind(to: datasource)
      .disposed(by: disposeBag)
    
    tappedInfoData
      .bind(to: goToDetail)
      .disposed(by: disposeBag)
    

    self.input = Input(tappedInfoData: tappedInfoData.asObserver())
    self.output = Output(datasource: datasource.asDriver(onErrorJustReturn: []),
                         gotoDetail: goToDetail.asDriver(onErrorJustReturn: nil))
  }
  
  
}
