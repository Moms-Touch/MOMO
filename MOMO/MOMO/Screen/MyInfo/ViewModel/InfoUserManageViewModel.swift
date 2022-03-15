//
//  InfoUserManageViewModel.swift
//  MOMO
//
//  Created by abc on 2022/03/14.
//

import Foundation
import RxSwift

class InfoUserManageViewModel: InfoCellViewModel, ViewModelType {
  //MARK: - Input

  struct Input {
    
  }
  
  var input: Input

  //MARK: - Output
  
  struct Output {
    var withdrawalUser: Completable
  }
  
  var output: Output
  
  
  //MARK: - Private properties
  private var repository: UserSessionRepository
  
  //MARK: - Init

  init(index: Int, repository: UserSessionRepository) {
    self.repository = repository
    let withdrawalUser = repository.deleteUser()
    self.output = Output(withdrawalUser: withdrawalUser)
    self.input = Input()
    super.init(index: index)
  }
  
  //MARK: - Methods


}
