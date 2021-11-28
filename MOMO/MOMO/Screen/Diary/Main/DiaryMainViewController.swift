//
//  DiaryMainViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/14.
//

import UIKit
import FSCalendar
import Kingfisher

class DiaryMainViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var calendarView:
  FSCalendar!
  
  @IBOutlet weak var showReportButton: UIButton! {
    didSet {
      showReportButton.layer.borderColor = Asset.Colors.borderYellow.color.cgColor
      showReportButton.layer.borderWidth = 1
      
      showReportButton.layer.cornerRadius = 5
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    setUpCalendar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    calendarView.appearance.titleOffset = CGPoint(x: -((calendarView.frame.width / 7) / 2) + 6.5, y: -((calendarView.collectionView.frame.height / 7) / 2) + 3.5)
    
  }
  
  
  private func setUpCalendar() {
    
    calendarView.dataSource = self
    calendarView.delegate = self
    
    calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
    
    calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    calendarView.appearance.headerTitleColor = Asset.Colors._45.color
    
    calendarView.appearance.headerDateFormat = "yyyy.M"
    
    calendarView.appearance.caseOptions = .weekdayUsesUpperCase
    
    calendarView.appearance.weekdayTextColor = Asset.Colors._71.color
    
    calendarView.appearance.borderRadius = 0
    
    
//    calendarView.appearance.calendar.tintColor = .black
    
    calendarView.appearance.todayColor = .clear
    
    calendarView.appearance.titleSelectionColor = .black
    
    calendarView.appearance.selectionColor = .clear
  }
  
  @IBAction func showDiaryReport(_ sender: UIButton) {
    
    print(#function)
  }
}

extension DiaryMainViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
}

