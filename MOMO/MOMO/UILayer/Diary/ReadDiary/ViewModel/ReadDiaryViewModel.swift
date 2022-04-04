//
//  ReadDiaryViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/03.
//

import Foundation

import RxSwift
import RxCocoa

// creatDiary 에 createViewModel, ReadDiaryViewModel(delete 하는 usecase 필요,
// createViewModel을 만들어야하는 dependencies 필요) 두개 -> 상속으로 두개를 묶기
// -> withTextViewModel(여기서 editmode, showmode 의존성 추가)
// -> withVoiceViewModel(여기서 editmode, showmode 의존성 추가)

class ReadDiaryViewModel: ViewModelType {
  
  // MARK: - Input
  
  struct Input {
//    var saveButtonClicked: AnyObserver<Void>
//    var deleteButtonClicked: AnyObserver<Void>
//    var dismissClicked: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
//    var dismiss: Driver<Void>
//    var saveCompleted: Driver<Bool>
//    var withInputViewModel: Driver<WithInputViewModel>
//    var deleteCompleted: Driver<Bool>
//    var toastMessage: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  
  // MARK: - init
  init(diary: Diary) {
    self.input = Input()
    self.output = Output()
  }

}
