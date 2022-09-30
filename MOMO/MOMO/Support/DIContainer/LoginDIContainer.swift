//
//  LoginDIContainer.swift
//  MOMO
//
//  Created by Woochan Park on 2022/09/30.
//

import Foundation

final class LoginDIContainer {
    
    struct Dependencies {
    // 로그인
        var authRemoteAPI: AuthRemoteAPI
    // - 추가적으로 필요한 의존성 : Persistency 관련
        
    /** 회원가입  **/
    // 회원가입은 하위 플로우
    // - 추가적으로 필요한 의존성 : Persistency 관련
//        var signUpRemoteAPI: SignRemoteAPI
    }
}
