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
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    // 이 두개 메소드는 필수 메소드 이다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
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
        let target = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.insertDate) // from 데이터를 formate해서 string으로 반환해준다.
        // 지정한 cell의 subtitle 스타일은 두가지 Label이 있고 각각의 text에다가 배열에서 꺼낸 값으로 설정해준다.
        return cell
    }
    

}
