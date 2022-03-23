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
  private let infoData: BehaviorSubject<InfoData>
  
  init(repository: RecommendRepository, info: BehaviorSubject<InfoData>) {
    self.repository = repository
    self.infoData = info
    let bookmarkButtonClick = PublishSubject<Void>()
    let bookmark = BehaviorRelay<Bool>(value: false)
    let url = BehaviorRelay<URL?>(value: nil)
    
    self.infoData
      .take(1)
      .map { URL(string: $0.url!) }
      .bind(to: url)
      .disposed(by: disposeBag)
    
    // 현재 북마크를 받아오기
    self.infoData
      .map { $0.isBookmark }
      .bind(to: bookmark)
      .disposed(by: disposeBag)
    
    self.input = Input(bookmarkButtonClick: bookmarkButtonClick.asObserver())
    
    self.output = Output(url: url.asDriver(onErrorJustReturn: nil), bookmark: bookmark.asDriver(onErrorJustReturn: false))
  
    // MARK: input -> output
    // bookmark 처리
    bookmarkButtonClick.withLatestFrom(info)
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
    // infodata에서 bookmark로 연결되기 때문에 infodata로 보내기
      .bind(to: self.infoData)
      .disposed(by: disposeBag)
      

  }
  
  
  
}
