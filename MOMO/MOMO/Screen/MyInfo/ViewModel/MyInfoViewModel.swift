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
    var nickNameText: AnyObserver<String?>
    var emailText: AnyObserver<String?>
  }
  
  struct Output {
    var nickName: Driver<String?>
    var email: Driver<String?>
    var description: Driver<String>
    var isLoggedIn: Driver<Bool>
  }
  
  var input: Input
  var output: Output

  //MARK: - Others
  
  var defaultContent: [Int: [String]] {
    return [0: ["지영맘", "momo@momo.com", "서울에 사는 21주차 엄마"],
            1: ["현재 상태 변경\n임신중과 출산 후를 선택할 수 있어요",
                "지역 변경\n현재 살고 있는 위치가 변경되었을 경우, 위치를 변경해주세요",
                "비밀변호 변경\n비밀번호를 변경하고 싶다면 말씀해주세요",
                "닉네임 변경\n커뮤니티에서 사용되는 닉네임을 변경해요"],
            2: ["로그아웃", "회원탈퇴", "Contact"]
    ]
  }

  //MARK: - Private
  var repository: UserSessionRepository
  private var disposeBag = DisposeBag()
  private let nickName: BehaviorSubject<String?>
  private let email: BehaviorSubject<String?>
  private let description: BehaviorSubject<String>
  private let isLoggedIn: BehaviorSubject<Bool>
  
  
  //MARK: - Init
  
  init(repository: UserSessionRepository) {
    self.repository = repository
    
    let nickNameText = BehaviorSubject<String?>(value: "지영맘")
    let emailText = BehaviorSubject<String?>(value: "momo@momo.com")
    let descriptionText = BehaviorSubject<String>(value: "서울에 사는 21주차 엄마")
    let userSession = BehaviorSubject<UserSession?>(value: nil)
    let isLoggedIn = BehaviorSubject<Bool>(value: true)
    
    repository.readUserSession()
      .bind(to: userSession)
      .disposed(by: disposeBag)
      
//    userSession
//      .map { return $0 == nil}
//      .bind(to: isLoggedIn)
//      .disposed(by: disposeBag)

    userSession
      .compactMap {$0}
      .map {
        $0.profile.nickname
      }
      .bind(to: nickNameText)
      .disposed(by: disposeBag)
    
    userSession
      .compactMap {$0}
      .map { $0.profile.email}
      .bind(to: emailText)
      .disposed(by: disposeBag)
    
    userSession
      .compactMap {$0}
      .map {
        return "\($0.profile.location)에 사는 엄마"
      }
      .debug()
      .bind(to: descriptionText)
      .disposed(by: disposeBag)
    
    self.input = Input(nickNameText: nickNameText.asObserver(),
                       emailText: emailText.asObserver()
                      )
    self.output = Output(nickName: nickNameText.asDriver(onErrorJustReturn: ""),
                         email: emailText.asDriver(onErrorJustReturn: ""),
                         description: descriptionText.asDriver(onErrorJustReturn: ""),
                         isLoggedIn: isLoggedIn.asDriver(onErrorJustReturn: true)
                        )
    
    self.nickName = nickNameText
    self.email = emailText
    self.description = descriptionText
    self.isLoggedIn = isLoggedIn
    
  }
  

}
