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
  }
  
  var output: Output
  
  //MARK: - Private properties
  private var content: [String]
  private var isPregnantClick: BehaviorSubject<Bool>
  private var changeNickNameClick: BehaviorSubject<Bool>
  private var changeLocationClick: BehaviorSubject<Bool>
  
  private var newNickname = BehaviorSubject<String>(value: "")
  private var isPregnantPublishSubject: PublishSubject<Bool>
  private var disposeBag = DisposeBag()
  
  //MARK: - Init

  init(index: Int, content: [String], repository: UserSessionRepository) {
    self.content = content
    
    let isPregnantClick = BehaviorSubject<Bool>(value: true)
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
                         newNickname: newNickname.asDriver(onErrorJustReturn: "")
    )
    
    self.input = Input(isPregnantClicked: isPregnantClick.asObserver(),
                       locationClicked: changeLocationClick.asObserver(),
                       nicknameClicked: changeNickNameClick.asObserver(),
                       newNickname: nicknameBehaviorSubject.asObserver(),
                       newIsPregnant: isPregnantPublishSubject.asObserver())
    
    super.init(index: index)
    
    nicknameBehaviorSubject
      .asObservable()
      .flatMap { return repository.renameNickname(with: $0)}
      .map { $0.nickname}
      .bind(to: newNickname)
      .disposed(by: disposeBag)

    
    isPregnantPublishSubject
      .debug()
      .withUnretained(self)
      .bind(onNext: { vm, ispregnantStatus in
        repository.changeCurrentStatus(isPregnant: ispregnantStatus)
          .subscribe(onNext: {
            print($0)
          })
          .disposed(by: vm.disposeBag)
      })
      .disposed(by: disposeBag)
    
    
  }


  
  
}
