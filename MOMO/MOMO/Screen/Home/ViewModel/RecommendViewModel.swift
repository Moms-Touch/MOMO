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
  private let datasource = BehaviorSubject<[InfoData]>(value: [])
  private let tappedInfoData = BehaviorSubject<InfoData?>(value: nil)
  private let goToDetail = PublishRelay<InfoData?>()
  private var disposeBag = DisposeBag()
  //MARK: - Init
  
  init(reposoitory: RecommendRepository) {
    self.repository = reposoitory
    
    tappedInfoData
      .bind(to: goToDetail)
      .disposed(by: disposeBag)
    
    datasource.onNext([
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: ""),
      InfoData(id: 1, author: "hi", title: "hi", url: nil, thumbnailImageUrl: nil, isBookmark: false, week: 1, createdAt: "", updatedAt: "")
                    ])
    
    self.input = Input(tappedInfoData: tappedInfoData.asObserver())
    self.output = Output(datasource: datasource.asDriver(onErrorJustReturn: []),
                         gotoDetail: goToDetail.asDriver(onErrorJustReturn: nil))
  }
  
  
}
