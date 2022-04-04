//
//  HomeMainViewModel.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/01.
//

import Foundation

import RxSwift
import RxCocoa

class HomeMainViewModel: ViewModelType {
  
  // MARK: - Input
  
  struct Input {
    var writeDiaryClicked: AnyObserver<Void>
    var calendarButtonClicked: AnyObserver<Void>
    var bookmarkButtonClicked: AnyObserver<Void>
    var settingButtonClicked: AnyObserver<Void>
  }
  
  var input: Input
  
  // MARK: - Output
  
  struct Output {
    var diary: Driver<DiaryEntity?>
    var gotoCalendar: Driver<CalendarViewModel>
    var gotoBookmark: Driver<Void>
    var gotoSetting: Driver<MyInfoViewModel>
    var gotoDiaryInput: Driver<DiaryInputOptionViewModel>
    var profileImage: Driver<String>
    var toastMessage: Driver<String>
  }
  
  var output: Output
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private let diaryUseCase : DiaryUseCase
  private let userRepository: UserSessionRepository
  
  // MARK: - init
  init(diaryUseCase: DiaryUseCase, userRepository: UserSessionRepository) {
    //dependencies
    self.diaryUseCase = diaryUseCase
    self.userRepository = userRepository
    
    let writeDiaryClicked = PublishSubject<Void>()
    let calendarButtonClicked = PublishSubject<Void>()
    let bookmarkClicked = PublishSubject<Void>()
    let settingClicked = PublishSubject<Void>()
    
    let calendarViewModel = BehaviorSubject<CalendarViewModel>(value: makeCalendarViewModel())
    let gotoCalendar = calendarButtonClicked.withLatestFrom(calendarViewModel)
    
    let myInfoViewModel = BehaviorSubject<MyInfoViewModel>(value: makeMyInfoViewModel())
    let gotoSetting = settingClicked.withLatestFrom(myInfoViewModel)
    
    let diaryInputOptionViewModel = BehaviorRelay<DiaryInputOptionViewModel>(value: makeDiaryInputViewModel())
    let diary = BehaviorRelay<DiaryEntity?>(value: nil)
    
    let profileImage = BehaviorRelay<String>(value: "mascot")
    let toastMessage = BehaviorRelay<String>(value: "가운데 버튼을 눌러서, 아이의 사진으로 변경해보아요🤰")
    let imageUrl = userRepository
      .readUserSession()
      .map { session in
        session.profile.baby?.first?.imageUrl
      }
  
    self.input = Input(writeDiaryClicked: writeDiaryClicked.asObserver(),
                       calendarButtonClicked: calendarButtonClicked.asObserver(), bookmarkButtonClicked: bookmarkClicked.asObserver(), settingButtonClicked: settingClicked.asObserver())
    self.output = Output(diary: diary.asDriver(),
                         gotoCalendar: gotoCalendar.asDriver(onErrorJustReturn: makeCalendarViewModel()),
                         gotoBookmark: bookmarkClicked.asDriver(onErrorJustReturn: ()),
                         gotoSetting: gotoSetting.asDriver(onErrorJustReturn: makeMyInfoViewModel()),
                         gotoDiaryInput: diaryInputOptionViewModel.asDriver(),
                         profileImage: profileImage.asDriver(),
                         toastMessage: toastMessage.asDriver())
    
    writeDiaryClicked.withLatestFrom(diaryUseCase.fetchDiary(date: Date()))
      .compactMap { $0 }
      .bind(to: diary)
      .disposed(by: disposeBag)
    
    writeDiaryClicked.withLatestFrom(diaryUseCase.fetchDiary(date: Date()))
      .filter { $0 == nil}
      .map { _ in return makeDiaryInputViewModel() }
      .bind(to: diaryInputOptionViewModel)
      .disposed(by: disposeBag)
    
    calendarButtonClicked.withLatestFrom(calendarViewModel)
      .map { _ in return makeCalendarViewModel() }
      .bind(to: calendarViewModel)
      .disposed(by: disposeBag)
    
    imageUrl
      .compactMap { $0 }
      .bind(to: profileImage)
      .disposed(by: disposeBag)
    
    imageUrl
      .filter { $0 == nil}
      .take(1)
      .withLatestFrom(toastMessage)
      .bind(to: toastMessage)
      .disposed(by: disposeBag)
    
    func makeCalendarViewModel() -> CalendarViewModel {
      let datastore = MomoDiaryDataStore()
      let repository = MomoDiaryRepository(diaryDataStore: datastore)
      let usecase = MomoCalendarUseCase(repository: repository, baseDate: Date())
      return CalendarViewModel(calendarUseCase: usecase, diaryUsecase: diaryUseCase)
    }

    func makeMyInfoViewModel() -> MyInfoViewModel {
      return MyInfoViewModel(repository: userRepository)
    }
    
    func makeDiaryInputViewModel() -> DiaryInputOptionViewModel {
      return DiaryInputOptionViewModel(usecase: diaryUseCase)
    }
    
    
  }
}
