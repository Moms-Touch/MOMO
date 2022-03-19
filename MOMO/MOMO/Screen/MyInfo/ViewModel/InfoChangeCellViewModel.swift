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
    var isPregnantClicked: AnyObserver<Bool>
    var locationClicked: AnyObserver<Bool>
    var nicknameClicked: AnyObserver<Bool>
    var newNickname: AnyObserver<String>
    var newIsPregnant: AnyObserver<Bool>
  }
  
  var input: Input

  //MARK: - Output
  
  struct Output {
    var goToChangeLocation: Driver<Bool>
    var goToChangeNickname: Driver<Bool>
    var goToChangeIspregnant: Driver<Bool>
    var newNickname: Driver<String>
    var newPregnant: Driver<Bool>
  }
  
  var output: Output
  
  //MARK: - Private properties
  private var content: [String]
  private var isPregnantClick: BehaviorSubject<Bool>
  private var changeNickNameClick: BehaviorSubject<Bool>
  private var changeLocationClick: BehaviorSubject<Bool>
  
  private var newNickname = BehaviorSubject<String>(value: "")
  private var newPregnant = BehaviorSubject<Bool>(value: true)
  private var isPregnantPublishSubject: PublishSubject<Bool>
  private var disposeBag = DisposeBag()
  
  //MARK: - Init

  init(index: Int, content: [String], repository: UserSessionRepository) {
    self.content = content
    
    let isPregnantClick = BehaviorSubject<Bool>(value: false)
    let changeNickNameClick = BehaviorSubject<Bool>(value: false)
    let changeLocationClick = BehaviorSubject<Bool>(value: false)
    let isPregnantPublishSubject = PublishSubject<Bool>()
    let nicknameBehaviorSubject = PublishSubject<String>()
    
    self.isPregnantPublishSubject = isPregnantPublishSubject
    self.changeLocationClick = changeLocationClick
    self.changeNickNameClick = changeNickNameClick
    self.isPregnantClick = isPregnantClick
    

    self.output = Output(goToChangeLocation: changeLocationClick.asDriver(onErrorJustReturn: false),
                         goToChangeNickname: changeNickNameClick.asDriver(onErrorJustReturn: false),
                         goToChangeIspregnant: isPregnantClick.asDriver(onErrorJustReturn: false),
                         newNickname: newNickname.asDriver(onErrorJustReturn: ""),
                         newPregnant: newPregnant.asDriver(onErrorJustReturn: true)
    )
    
    self.input = Input(isPregnantClicked: isPregnantClick.asObserver(),
                       locationClicked: changeLocationClick.asObserver(),
                       nicknameClicked: changeNickNameClick.asObserver(),
                       newNickname: nicknameBehaviorSubject.asObserver(),
                       newIsPregnant: isPregnantPublishSubject.asObserver())
    
    super.init(index: index)
    
    //input -> Outeput
    
    nicknameBehaviorSubject
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
