//
//  File.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/13.
//

import Foundation
import CoreData

class DataManager
{
    // MARK: - Core Data stack
    static let shared = DataManager()
    private init(){
        
    } // singleton pattern
    // static 으로 선언해서 다른 곳에서 하나의 인스턴스를 공유해서 사용
    //생성자를 private 로 접근제어하여 외부에서 객체 생성 금지
    
    
    var mainContext : NSManagedObjectContext{
        return persistentContainer.viewContext
    }//NSManagedObjectContext -> NSManagedObject(스키마) 를가져오고 생성하고 저장하는 역활
    
    var memoList = [Memo]() // fetch한 데이터들을 저장할 배열
    
    func fetchMemo(){
        let request : NSFetchRequest<Memo> = Memo.fetchRequest() //Memo 클래스를 만들지 않았지만 사용 할 수 있는 이유는 core data에서 알아서 클래스를 만들어주고 인스펙터창에서 class definition 설정하면 클래스 파일이 보이지 않는다. fetchrequest는 말 그대로 가져올 때 요구사항이다.
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc] // 가져 올 때 날짜순으로 내림차순으로 가져 온다고 지정하였다.
        
        do{
            memoList = try mainContext.fetch(request) // 요구사항대로 fetch해서 memoList에 저장
            // fetch는 throw가 날 수 있기 때문에 do try catch안에서 호출
        }catch{
            print(error)
        }
    }
    func addNewMemo(_ memo:String?){
        let newMemo = Memo(context: mainContext) // entity 클래스를 생성할 때 생성자에다가 context를 넣어야한다.
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        memoList.insert(newMemo, at: 0) //바로 배열에 저장하는 이유는 저장할 때마다 fetch를 통해 값을 가져오고 그것을 통해 table을 reload시키는 것 보다 필요할 때만 fetch하고 아닌 경우에는 바로 배열에다가 저장하고 reload하는 것이 더 효율 적이다.
        saveContext() // core data에 저장
    }
    
    func deleteMemo(_ memo: Memo?){
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Z0Memo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }() //NSPersistentContainer는 관리 개체 모델(NSManagedObjectModel), 영구 저장소 코디네이터(NSPersistentStoreCoordinator) 및 관리 개체 컨텍스트(NSManagedObjectContext)를 처리하여 코어 데이터 스택 생성 및 관리를 단순화합니다. - developer.apple.com

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
