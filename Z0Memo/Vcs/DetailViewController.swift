//
//  DetailViewController.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/13.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    var memo: Memo?
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr") // xcode가 기본적으로 생성한 프로젝트는 다국어를 지원하지 않아 영어로 표시된다. 따라서 한국 날짜로 표현하고 싶으면 이렇게 지정한다.
        return f
    }() // DateFormatter 객체를 클로저로 초기화
    
    
    var token : NSObjectProtocol?

    deinit{
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: ComposeViewController.MemoDidEdit, object: nil, queue: OperationQueue.main) {
            [weak self] Notification in
            self?.detailTableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
}

extension DetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            // memo가 optional이기 때문에 string(from:)을 사용안하고 for를 사용해야한다.
            return cell
        default:
            fatalError()
        }
    }
    
}


extension DetailViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController
        {
            vc.editMemo = memo
        } // toolbar 의 버튼을 클릭하면 ComposeViewController로 이동하는데 Navigation Controller로 이동하고 그 Navigation Controller가 ComposeViewController를 가르키고 있는 것이다.
        //따라서 segue.destination은 Navigation Controller이고 자식의 첫번째가 ComposeViewController가 된다.
        
    }
}



