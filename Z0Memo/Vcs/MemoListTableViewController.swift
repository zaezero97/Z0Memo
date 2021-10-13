//
//  MemoListTableViewController.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/12.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr") // xcode가 기본적으로 생성한 프로젝트는 다국어를 지원하지 않아 영어로 표시된다. 따라서 한국 날짜로 표현하고 싶으면 이렇게 지정한다.
        return f
    }() // DateFormatter 객체를 클로저로 초기화
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchMemo()
        tableView.reloadData() // 프레젠테이션 스타일이 full screen이면 save버튼을 클릭하여 dismiss 후에 해당 vc로 돌아오면 ViewWillAppear함수가 호출되고 여기서 reloadData함수를 호출하여 새로운 데이터로 기존 테이블을 다시 reload한다.
        print(#function) // ios 13부터 modal의 프레젠테이션 스타일 기본값이 sheet가 그전에는 full screen
        // 스타일이 sheet 일때는 dismiss로 해당 View Controller로 돌아와도 viewWillAppear 함수가 호출이 되지 않는다.
        // 따라서 이 앱에서는 Notification을 통해서 save 기능 을 구현한다.
    }
    var token : NSObjectProtocol?
    
    deinit{
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad(){
        
        super.viewDidLoad()
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main)
        {
            [weak self] (noti) in // 클로저 안에서 self를 캡쳐하기 때문에 weak self 선언 순환참조로 인한 메모리 누수 방지
            self?.tableView.reloadData()
        }
        // Notification을 받을 Observer 를 등록
        // forName : 해당 Notification.Name 의 메시지를 받는다는 의미
        // object : 특정 sender에게 수신 받을 때 sender입력
        // queue: 쓰레드를 지정 여기서는 ui를 설정하기 떄문에 무조건 main쓰레드에서 헤야한다.
        // addObserver함수 반환값으로 옵저버를 해제할 때 사용하는 토큰을 리턴해줌
        // 메모리가 낭비되는 걸 방지하기 위해 뷰가 사라지거나 소멸 하기 전에 해제 시켜줘야한다.
    }

    // MARK: - Table view data source
    // 이 두개 메소드는 필수 메소드 이다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
        // 몇개의 셀을 테이블에 표현 할 지 테이블에게 알려주는 메소드
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // 사욜 할 cell 디자인을 가져온다.
        // storyboard에서 identifier을 cell로 지정한 cell을 가져와서 생성해준다.
        // cell 상수에 저장한다. 생성한 cell은 내용이 비어져 있다.
        // indexPath의 row를 통해 몇번 째 셀인지 확인 할 수 있다.
        // 따라서 배열에서 row번째 데이터를 가져와서 cell에 표시한다.

        // Configure the cell...
        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate) // from 데이터를 formate해서 string으로 반환해준다.
        // 지정한 cell의 subtitle 스타일은 두가지 Label이 있고 각각의 text에다가 배열에서 꺼낸 값으로 설정해준다.
        return cell
    }
    

}


extension MemoListTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell , let indexPath = tableView.indexPath(for: cell)
        {
            let vc = segue.destination as? DetailViewController
            vc?.memo =  DataManager.shared.memoList[indexPath.row]
        }
    }
} // segue 를 통해 화면 전환이 이루어지기 전에 prepare함수가 호출된다 sender는 segue객체를 만드는 대상 즉 화면전환을 발생시키는 객체이다
//segue는 전환 될 view controller를 생성하고 출발지과 도착지를 저장하고 있다.
// 출발지 - segue.source , 도착지 - segue.destination
//segue.destination은  UIViewController 이기때문에 다운캐스팅을 통해 DetailViewController로 변경해주고 데이터를 전달 하였다.
