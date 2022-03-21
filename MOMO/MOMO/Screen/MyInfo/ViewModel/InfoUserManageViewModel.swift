//
//  InfoUserManageViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class InfoUserManageViewModel: InfoCellViewModel, ViewModelType {
  //MARK: - Input
  
  struct Input {
    var logoutClick: AnyObserver<Void>
    var logoutApproved: AnyObserver<Bool>
    var withdrawalClick: AnyObserver<Void>
    var withdrawApproved: AnyObserver<Bool>
  }
  
  var input: Input
  
  //MARK: - Output
  
  struct Output {
    var gotoLogout: Driver<Void>
    var goToWithdrawal: Driver<Void>
    var withDrawalCompleted: Driver<Bool>
    var logoutCompleted: Driver<Bool>
    var contactURL: URL
  }
  
  var output: Output
  
  
  //MARK: - Private properties
  private var repository: UserSessionRepository
  private let goToWithdrawal = PublishRelay<Void>()
  private let logoutClicked = PublishSubject<Void>()
  private let gotoLogout = PublishRelay<Void>()
  private let logoutApproved = BehaviorSubject<Bool>(value: false)
  private let withDrawalClicked = PublishSubject<Void>()
  private let withDrawalApproved = BehaviorSubject<Bool>(value: false)
  private var disposeBag = DisposeBag()
  
  //MARK: - Init
  
  init(index: Int, repository: UserSessionRepository) {
    self.repository = repository
    let withDrawalCompleted = BehaviorSubject<Bool>(value: false)
    let logoutCompleted = BehaviorRelay<Bool>(value: false)
    
    let url =  URL(string: "https://momo-official.tistory.com/guestbook")!
    self.output = Output(gotoLogout: gotoLogout.asDriver(onErrorJustReturn: ()),
                         goToWithdrawal: goToWithdrawal.asDriver(onErrorJustReturn: ()),
                         withDrawalCompleted: withDrawalCompleted.asDriver(onErrorJustReturn: false), logoutCompleted: logoutCompleted.asDriver(onErrorJustReturn: false),
                         contactURL: url)
    self.input = Input(logoutClick: logoutClicked.asObserver(),
                       logoutApproved: logoutApproved.asObserver(),
                       withdrawalClick: withDrawalClicked.asObserver(),
                       withdrawApproved: withDrawalApproved.asObserver())
    super.init(index: index)
    
    //MARK: - Input -> Output
    
    logoutClicked
      .debug()
      .bind(to: gotoLogout)
      .disposed(by: disposeBag)
    
    logoutApproved
      .bind(to: logoutCompleted)
      .disposed(by: disposeBag)
    
    withDrawalClicked
      .bind(to: goToWithdrawal)
      .disposed(by: disposeBag)
    
    withDrawalApproved
      .filter { $0 == true }
      .subscribe(onNext: { _ in
        repository.deleteUser()
          .subscribe { completable in
            switch completable {
            case .completed:
              withDrawalCompleted.onNext(true)
            case .error(let error):
              withDrawalCompleted.onError(error)
            }
          }
      })
      .disposed(by: disposeBag)
  }
}
