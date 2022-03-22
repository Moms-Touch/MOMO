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
    var title: Driver<String>
  }
  
  var output: Output
  
  //MARK: - Private
  private let repository: RecommendRepository
  private let userRepository: UserSessionRepository
  
  private let tappedInfoData = BehaviorSubject<InfoData?>(value: nil)
  private let goToDetail = PublishRelay<InfoData?>()
  private var disposeBag = DisposeBag()
  //MARK: - Init
  
  init(reposoitory: RecommendRepository, userRepository: UserSessionRepository) {
    self.repository = reposoitory
    self.userRepository = userRepository
    let datasource = BehaviorRelay<[InfoData]>(value: [])
    let titleRelay = BehaviorRelay<String>(value: "12주차 모모님을 위한 추천정보")
    
    self.userRepository.readUserSession()
      .map{
        let duration = $0.profile.isPregnant == true ? $0.profile.baby?.first?.birthday?.trimStringDate().fetusInWeek() : $0.profile.baby?.first?.birthday?.trimStringDate().babyInWeek()
        return "\(duration ?? "") \($0.profile.nickname)님을 위한 추천정보" }
      .bind(to: titleRelay)
      .disposed(by: disposeBag)
    
    self.repository.getRecommendInfo()
      .map { $0.reversed()}
      .bind(to: datasource)
      .disposed(by: disposeBag)
    
    tappedInfoData
      .bind(to: goToDetail)
      .disposed(by: disposeBag)
    

    self.input = Input(tappedInfoData: tappedInfoData.asObserver())
    self.output = Output(datasource: datasource.asDriver(onErrorJustReturn: []),
                         gotoDetail: goToDetail.asDriver(onErrorJustReturn: nil), title: titleRelay.asDriver(onErrorJustReturn: ""))
  }
  
  
}
