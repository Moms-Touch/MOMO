//
//  InfoChangeCellViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift
import RxCocoa

class InfoChangeCellViewModel: InfoCellViewModel, ViewModelType {
  
  //MARK: - Input

  struct Input {
    var isPregnantClicked: AnyObserver<Void>
    var locationClicked: AnyObserver<Void>
    var nicknameClicked: AnyObserver<Void>
    var newNickname: AnyObserver<String>
    var newIsPregnant: AnyObserver<Bool>
  }
  
  var input: Input

  //MARK: - Output
  
  struct Output {
    var goToChangeLocation: Driver<Void>
    var goToChangeNickname: Driver<Void>
    var goToChangeIspregnant: Driver<Void>
    var newNickname: Driver<String>
    var newPregnant: Driver<Bool>
  }
  
  var output: Output
  
  //MARK: - Private properties
  private var content: [String]
  private var isPregnantClick: PublishSubject<Void>
  private var changeNickNameClick: PublishSubject<Void>
  private var changeLocationClick: PublishSubject<Void>
  
  private var newNickname = BehaviorSubject<String>(value: "")
  private var newPregnant = BehaviorSubject<Bool>(value: true)
  private var isPregnantPublishSubject: PublishSubject<Bool>
  private var disposeBag = DisposeBag()
  
  //MARK: - Init

  init(index: Int, content: [String], repository: UserSessionRepository) {
    self.content = content
    let isPregnantClick = PublishSubject<Void>()
    let changeNickNameClick = PublishSubject<Void>()
    let changeLocationClick = PublishSubject<Void>()
    let isPregnantPublishSubject = PublishSubject<Bool>()
    let nicknamePublishSubject = PublishSubject<String>()
    
    self.isPregnantPublishSubject = isPregnantPublishSubject
    self.changeLocationClick = changeLocationClick
    self.changeNickNameClick = changeNickNameClick
    self.isPregnantClick = isPregnantClick
    

    self.output = Output(goToChangeLocation: changeLocationClick.asDriver(onErrorJustReturn: ()),
                         goToChangeNickname: changeNickNameClick.asDriver(onErrorJustReturn: ()),
                         goToChangeIspregnant: isPregnantClick.asDriver(onErrorJustReturn: ()),
                         newNickname: newNickname.asDriver(onErrorJustReturn: ""),
                         newPregnant: newPregnant.asDriver(onErrorJustReturn: true)
    )
    
    self.input = Input(isPregnantClicked: isPregnantClick.asObserver(),
                       locationClicked: changeLocationClick.asObserver(),
                       nicknameClicked: changeNickNameClick.asObserver(),
                       newNickname: nicknamePublishSubject.asObserver(),
                       newIsPregnant: isPregnantPublishSubject.asObserver())
    
    super.init(index: index)
    
    //input -> Outeput
    
    nicknamePublishSubject
      .asObservable()
      .flatMapLatest { return repository.renameNickname(with: $0)}
      .map { $0.nickname}
      .bind(to: newNickname)
      .disposed(by: disposeBag)

    isPregnantPublishSubject
      .asObservable()
      .flatMapLatest {return repository.changeCurrentStatus(isPregnant: $0)}
      .map{ $0.isPregnant }
      .bind(to: newPregnant)
      .disposed(by: disposeBag)
    
  }
  
}
