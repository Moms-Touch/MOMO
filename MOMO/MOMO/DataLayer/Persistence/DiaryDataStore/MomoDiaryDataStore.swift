//
//  MomoDiaryDataStore.swift
//  MOMO
//
//  Created by Jung peter on 2022/03/26.
//

import Foundation
import RxSwift
import RealmSwift

final class MomoDiaryDataStore: DiaryDataStore {

  init() {
    
  }
  
  // MARK: - Methods
  
  func create(diary: Diary) -> Observable<Diary> {
    do {
      let realm = try Realm()
      try realm.write({
        realm.add(diary)
      })
      return Observable.just(diary)
        .share()
    } catch {
      return Observable.error(error)
    }
  }
  
  func read(date: Date) -> Observable<Diary?> {
    let realm = try! Realm()
    let targetZero = date.timeToZero()
    let target = realm.objects(Diary.self).where {
      $0.date == targetZero
    }
    
    guard let diary = target.first else {
      return Observable.just(nil)
        .share()
    }
    
    return Observable.just(diary)
      .share()
    
  }
  
  func read(from fromDate: Date, to toDate: Date) -> Observable<[Diary]> {
    do {
      let realm = try Realm()
      let result = Array(realm.objects(Diary.self)
        .filter("date BETWEEN {%@, %@}", fromDate, toDate))
    
      return Observable.just(result)
        .share()
    } catch {
      return Observable.error(error)
    }
  }
  
  func delete(diaryId: String) -> Completable {
    return Completable.create { completable in
      
      guard let realm = try? Realm() else {
        return completable(.error(DataStoreError.realmFailure)) as! Disposable
      }
      
      do {
        try realm.write { [unowned self] in
          if let entity = self.selectById(id: diaryId) {
            realm.delete(entity)
            completable(.completed)
          } else {
            completable(.error(DataStoreError.deleteError))
          }
        }
      } catch {
        completable(.error(DataStoreError.deleteError))
      }
      return Disposables.create()
    }
  }
  
  // 주의사항: new의 primaryKey가 old의 것과 동일해야하기 때문에, 객체를 새로 만들고 저장이 아닌, 당시의 객체를 수정해서 넣어줘야함
  func update(with new: Diary) -> Observable<Diary> {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(new, update: .modified)
      }
      return Observable.just(new)
        .share()
    } catch {
      return Observable.error(error)
    }
  }
  
  
  private func selectById(id: String) -> Diary? {
    do {
      let realm = try Realm()
      let id = try ObjectId(string: id)
      let predicate = NSPredicate(format: "id == %s", id)
      return realm.objects(Diary.self).filter(predicate).first
    } catch {
        return nil
    }
  }


}
