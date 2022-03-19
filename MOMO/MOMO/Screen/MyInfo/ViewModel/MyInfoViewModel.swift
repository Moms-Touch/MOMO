//
//  MyInfoViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/12.
//

import Foundation
import RxSwift
import RxCocoa

final class MyInfoViewModel: ViewModelType {
  
  //MARK: - Input & OutPut
  
  //TODO: 여기서 셀모델 3개 만들어서 가고, viewmodel 많이 고고

  struct Input {
    var nickNameText: BehaviorRelay<String?>
    var emailText: BehaviorRelay<String?>
  }
  
  struct Output {
    var nickName: Driver<String?>
    var email: Driver<String?>
    var description: Driver<String>
    var isLoggedIn: Driver<Bool>
    var firstCellModel: MyInfoCellViewModel
    var infoChangecellModel: InfoChangeCellViewModel
    var infoUserManageCellModel: InfoUserManageViewModel
  }
  
  var input: Input
  var output: Output

  //MARK: - Others
  
  var defaultContent: [Int: [String]] = [0: ["지영맘", "momo@momo.com", "서울에 사는 21주차 엄마"],
            1: ["현재 상태 변경\n임신중과 출산 후를 선택할 수 있어요",
                "지역 변경\n현재 살고 있는 위치가 변경되었을 경우, 위치를 변경해주세요",
                "비밀변호 변경\n비밀번호를 변경하고 싶다면 말씀해주세요",
                "닉네임 변경\n커뮤니티에서 사용되는 닉네임을 변경해요"],
            2: ["로그아웃", "회원탈퇴", "Contact"]
    ]

  //MARK: - Private
  var repository: UserSessionRepository
  private var disposeBag = DisposeBag()
  
  private let nickName = BehaviorRelay<String?>(value: "지영맘")
  private let email = BehaviorRelay<String?>(value: "momo@momo.com")
  private let description = BehaviorRelay<String>(value: "서울에 사는 21주차 엄마")
  private let userSession = BehaviorSubject<UserSession?>(value: nil)
  private let isLoggedIn = BehaviorSubject<Bool>(value: true)
  private let infoChangeCellModel: InfoChangeCellViewModel
  private let infoUserManageCellModel: InfoUserManageViewModel
  
  
  //MARK: - Init
  
  init(repository: UserSessionRepository) {
    self.repository = repository
    let observable = repository.readUserSession()
    
    userSession
      .compactMap {$0}
      .map { $0.profile.nickname }
      .bind(to: nickName)
      .disposed(by: disposeBag)
    
    userSession
      .compactMap {$0}
      .map { $0.profile.email}
      .bind(to: email)
      .disposed(by: disposeBag)
    
    userSession
      .compactMap {$0}
      .map {
        return "\($0.profile.location)에 사는 엄마"
      }
      .bind(to: description)
      .disposed(by: disposeBag)
    
    let firstCellModel = MyInfoCellViewModel(index: 0,
                                             email: self.email,
                                             nickname: self.nickName,
                                             description: self.description)
    
    let infoChangeCellModel = InfoChangeCellViewModel(index: 1,
                                                      content: defaultContent[1]!,
                                                      repository: repository )
    
    self.infoChangeCellModel = infoChangeCellModel
    
    self.infoChangeCellModel.output.newNickname
      .drive(self.nickName)
      .disposed(by: disposeBag)
    
    self.infoChangeCellModel.output.newNickname
      .asObservable()
      .flatMap({ _ -> Observable<UserSession> in
        return repository.readUserSession()
      })
      .bind(to: userSession)
      .disposed(by: disposeBag)
    
    self.infoChangeCellModel.output.newPregnant
      .drive(onNext: {
        print($0)
      })
      .disposed(by: disposeBag)
    
    
    
    let infoUserCellModel = InfoUserManageViewModel(index: 2, repository: repository)
    self.infoUserManageCellModel = infoUserCellModel
    
    
    self.input = Input(nickNameText: nickName,
                       emailText: email
                      )
    self.output = Output(nickName: self.nickName.asDriver(onErrorJustReturn: ""),
                         email: self.email.asDriver(onErrorJustReturn: ""),
                         description: self.description.asDriver(onErrorJustReturn: ""),
                         isLoggedIn: isLoggedIn.asDriver(onErrorJustReturn: true),
                         firstCellModel: firstCellModel,
                         infoChangecellModel: infoChangeCellModel,
                         infoUserManageCellModel: infoUserCellModel
                        )
    
    observable
      .bind(to: userSession)
      .disposed(by: disposeBag)
    
  }

}
