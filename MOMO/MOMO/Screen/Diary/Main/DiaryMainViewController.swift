//
//  DiaryMainViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit
import FSCalendar
import Kingfisher
import RealmSwift

class DiaryMainViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var calendarView:
  FSCalendar!
  
  /// 오늘 일기를 작성했는지 확인하는 로직
  /// 상태로 갈껀지 확인할 때마다 DB에 접근할 것인지?
  /// 상태로 관리하면 계속 동기화에 신경써주어야한다
  
  
  @IBOutlet weak var showReportButton: UIButton! {
    didSet {
      showReportButton.layer.borderColor = Asset.Colors.borderYellow.color.cgColor
      showReportButton.layer.borderWidth = 1
      
      showReportButton.layer.cornerRadius = 5
    }
  }
  
  var didMakeDiaryToday: Bool {
    ///
    /// Realm 접근해서 확인하는 코드
    ///
    ///오늘
    let currentDate = Date()
    let calendar = Calendar.current
    
    /// Date 에서 DateComponents 로 변환해주었다
    /// DateComponents 에서는 년, 월 , 일
    let date = calendar.dateComponents(in: .current, from: currentDate)
    
    let todayComponents = DateComponents(year: date.year, month: date.month, day: date.day)
    
    return true
  }
  
  var datesWithDiray: [Date] = []
  
  override func viewDidLoad() {
    
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    setUpCalendar()
    
    print(Realm.Configuration.defaultConfiguration.fileURL)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setUpEventsInCalendar()
    
    calendarView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  
  private func setUpCalendar() {
    
    calendarView.dataSource = self
    
    calendarView.backgroundColor = Asset.Colors.pink5.color
    
    calendarView.layer.cornerRadius = 5
    
    calendarView.delegate = self
    
    calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
    
    calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    calendarView.appearance.headerTitleColor = Asset.Colors._45.color
    
    calendarView.appearance.headerDateFormat = "yyyy.M"
    
    calendarView.appearance.caseOptions = .weekdayUsesUpperCase
    
    calendarView.appearance.weekdayTextColor = Asset.Colors._71.color
    
    calendarView.appearance.borderRadius = 0
    
    calendarView.appearance.todayColor = Asset.Colors.pink4.color
    
    calendarView.appearance.titleSelectionColor = .black
    
    calendarView.appearance.selectionColor = Asset.Colors.pink5.color
    
    calendarView.appearance.eventDefaultColor = Asset.Colors.pink2.color
    
  }
  
  @IBAction func showDiaryReport(_ sender: UIButton) {
    
    print(#function)
  }
  
  @IBAction func makeNewDiary(_ sender: UIButton) {
    
    /// 이미 일기를 작성했는지 확인
    /// Realm 에 데이터가 있는지?
    let realm = try! Realm()
    
    /// 오늘 날짜의 00시 00분
    let targetDate = Date().timeToZero()
    
    let targetDiary = realm.objects(Diary.self).where {
      $0.date == targetDate
    }
    
    /// 이미 일기를 작성했다면
    guard let diary = targetDiary.first else {
      
      /// 작성된 일기가 없다면
      /// 일기 작성 화면
      
      let diaryInputOptionVC = DiaryInputOptionViewController.loadFromStoryboard()

      diaryInputOptionVC.hidesBottomBarWhenPushed = true
      
      self.show(diaryInputOptionVC, sender: nil)
      
      return
    }
    
    // FIXME: AlertVC 모듈화
    let alertVC = UIAlertController(title: "작성한 일기 있음", message: "오늘은 이미 일기를 작성하셨습니다. 보러가실래요?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "보러갈래요", style: .default) { action in
      
      /// 일기 상세 화면
      
      let readDiaryVC = ReadDiaryViewController.make(with: diary)
      
      self.show(readDiaryVC, sender: nil)
    }
    
    let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
    
    alertVC.addAction(okAction)
    alertVC.addAction(cancelAction)
    
    self.present(alertVC, animated: true, completion: nil)
  }
  
  func setUpEventsInCalendar() {
    
    datesWithDiray = []
    
    do {
      
      let realm = try Realm()
      
      realm.objects(Diary.self).forEach {
        self.datesWithDiray.append($0.date)
      }
      
    } catch {
      
      print(error.localizedDescription)
    }
  }
  
  
}

extension DiaryMainViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
    defer {
      calendar.deselect(date)
    }
    
    let realm = try! Realm()
    
    /// 선택한 날짜의 00시 00분
    let targetZero = date.timeToZero()
    
    /// DB 에서 해당날짜로 검색
    let target = realm.objects(Diary.self).where {
      $0.date == targetZero
    }
    
    /// 이미 일기를 작성 했는지 확인
    guard let diary = target.first else {
      
      let alertVC = UIAlertController(title: "일기 없음", message: "이 날짜에 작성된 일기가 없습니다.", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: nil)
      
      alertVC.addAction(okAction)
      
      self.present(alertVC, animated: true, completion: nil)
      
      return
    }
    
    /// 작성된 일기가 있다면
    /// 일기 상세 화면
    ///
    let readDiaryVC = ReadDiaryViewController.make(with: diary)
    
    self.show(readDiaryVC, sender: nil)
  }
  
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    
    return datesWithDiray.contains(date) ? 1 : 0
  }
  
}

