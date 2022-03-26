//
//  DiaryDataStore.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/25.
//

import Foundation
import RxSwift

protocol DiaryDataStore {
  
  @discardableResult
  func create(diary: Diary) -> Observable<Diary>
  
  @discardableResult
  func read(date: Date) -> Observable<Diary?>
  
  @discardableResult
  func read(from fromDate: Date, to toDate: Date) -> Observable<[Diary]>
  
  @discardableResult
  func delete(diary: Diary) -> Completable
  
  @discardableResult
  func update(with new: Diary) -> Observable<Diary>
  
}
