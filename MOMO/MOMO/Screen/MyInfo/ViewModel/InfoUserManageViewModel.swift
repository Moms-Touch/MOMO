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
    var withdrawalClick: AnyObserver<Bool>
    var withdrawApproved: AnyObserver<Bool>
  }
  
  var input: Input
  
  //MARK: - Output
  
  struct Output {
    var goToWithdrawal: Driver<Bool>
    var withDrawalCompleted: Driver<Bool>
    var contactURL: URL
  }
  
  var output: Output
  
  
  //MARK: - Private properties
  private var repository: UserSessionRepository
  private let goToWithdrawal = BehaviorRelay<Bool>(value: false)
  
  private let withDrawalClicked = BehaviorSubject<Bool>(value: false)
  private let withDrawalApproved = BehaviorSubject<Bool>(value: false)
  private var disposeBag = DisposeBag()
  
  //MARK: - Init
  
  init(index: Int, repository: UserSessionRepository) {
    self.repository = repository
    let withDrawalCompleted = BehaviorSubject<Bool>(value: false)
    let url =  URL(string: "https://momo-official.tistory.com/guestbook")!
    self.output = Output(goToWithdrawal: goToWithdrawal.asDriver(onErrorJustReturn: false), withDrawalCompleted: withDrawalCompleted.asDriver(onErrorJustReturn: false), contactURL: url)
    self.input = Input(withdrawalClick: withDrawalClicked.asObserver(), withdrawApproved: withDrawalApproved.asObserver())
    super.init(index: index)
    
    
    
    //MARK: - Input -> Output
    
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
