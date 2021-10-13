//
//  ComposeViewController.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/13.
//

import UIKit

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var memoTextView: UITextView!
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) //dismiss -> view controller가 modal로 present한 view controller를 닫는다.
    } // modal -> 모달은 간단하게 말하면 사용자가 보고있던 화면 위에 다른 화면을 띄워서 시선을 끌게 만드는 방식
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text , memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        } // textview에 메모가 입력되어 있지 않으면 extension으로 추가한 alert 메소드를 실행시켜 경고 메시지를 화면에 출력 시킨다.
        // 만약 textview에 메시지가 입력되어 있으면 아래 문장들을 실행한다.
        let newMemo = Memo(content: memo) //새로운 Memo(model) 객체를 만들고
        Memo.dummyMemoList.append(newMemo) //Tableview에 각 cell로 표현되는 MemoList에 추가하고 dismiss한다.
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)// 등록된 observer 객체들에게 동시에! Notification을 전달하는 클래스이다.
        //Notification 을 전달한 obverser 를 처리할 때까지 대기 (동기적)
    
        dismiss(animated:true, completion: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func pr epare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "new MemoDidInsert")
} // 라디오 방송은 주파수로 방송을 구분 하듯이 Notification은 이름으로 구분한다.
//여기서 Notification.name 을 static으로 선언한 이유를 추측해보면
// 다른 view controller 에서 공용으로 접근하기 때문에 static를 사용한 거 같다.
// static으로 선언하지 않으면 ComposeViewController 객체를 선언하고 해당 인스턴스에서 프로퍼티를 초기화해서 사용하면 인스턴스마다 Notification.Name이 달라 질 수도 있다.
// 마지막으로 정리하자면 특정 타입의 모든 인스턴스에서 공용으로 사용될 프로퍼티를 타입 프로퍼티로 선언한다.
