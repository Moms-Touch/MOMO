//
//  RecommendDetailViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/22.
//

import Foundation
import RxSwift
import RxCocoa

class RecommendDetailViewModel: ViewModelType {
  
  // MARK: Input
  
  struct Input {
    var bookmarkButtonClick: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: Output
  
  struct Output {
    var url: Driver<URL?>
    var bookmark: Driver<Bool>
  }
  
  var output: Output
  
  // Private Properities
  private var disposeBag = DisposeBag()
  private let repository: RecommendRepository
  private let infoData: BehaviorSubject<InfoData?>
  
  init(repository: RecommendRepository, info: BehaviorSubject<InfoData>) {
    self.repository = repository
    let infoData = BehaviorSubject<InfoData?>(value: nil)
    self.infoData = infoData
    let bookmarkButtonClick = PublishSubject<Void>()
    let bookmark = BehaviorRelay<Bool>(value: false)
    let url = BehaviorRelay<URL?>(value: nil)
    
    self.input = Input(bookmarkButtonClick: bookmarkButtonClick.asObserver())
    self.output = Output(url: url.asDriver(onErrorJustReturn: nil), bookmark: bookmark.asDriver(onErrorJustReturn: false))
    
    info
      .map { URL(string: $0.url!) }
      .bind(to: url)
      .disposed(by: disposeBag)
    
    info
      .withUnretained(self)
      .flatMap({ vm, infoData in
        return vm.repository.getDetailRecommendedInfo(id: infoData.id)
      })
      .bind(to: self.infoData)
      .disposed(by: disposeBag)
    
    // 현재 북마크를 받아오기
    self.infoData
      .compactMap { $0 }
      .withUnretained(self)
      .map { $0.1.isBookmark }
      .bind(to: bookmark)
      .disposed(by: disposeBag)
  
    // MARK: input -> output
    // bookmark 처리
    bookmarkButtonClick.withLatestFrom(self.infoData)
      .compactMap { $0 }
      .withUnretained(self)
      .flatMapLatest { vm, infoData -> Observable<(RecommendDetailViewModel, Int)> in
        return infoData.isBookmark == true ? vm.repository
          .unBookmark(id: infoData.id, category: .info)
          .andThen(Observable.just((vm, infoData.id))) :
        vm.repository
          .bookmark(id: infoData.id, category: .info)
          .andThen(Observable.just((vm, infoData.id)))
      }
      .flatMapLatest { vm, id in
        return vm.repository.getDetailRecommendedInfo(id: id)
      }
      .bind(to: self.infoData)
      .disposed(by: disposeBag)
      

  }
  
  
  
}
