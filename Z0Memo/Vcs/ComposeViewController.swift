//
//  ComposeViewController.swift
//  Z0Memo
//
//  Created by 재영신 on 2021/10/13.
//

import UIKit

class ComposeViewController: UIViewController {

    var editMemo : Memo?
    var originalText : String?
    
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
        //let newMemo = Memo(content: memo) //새로운 Memo(model) 객체를 만들고
        //Memo.dummyMemoList.append(newMemo) //Tableview에 각 cell로 표현되는 MemoList에 추가하고 dismiss한다.
        
        if let target = editMemo{
            target.content = memo //segue를 통해 값이 전달 되었을때 reference 가 넘어온거라 생각하고 따라서 이렇게 값만 변경해주고 savaContext하면 값이 저장되는 것 같다.
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.MemoDidEdit, object: nil)
        }else{
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)// 등록된 observer 객체들에게 동시에! Notification을 전달하는 클래스이다.
            //Notification 을 전달한 obverser 를 처리할 때까지 대기 (동기적)
        }//editMemo의 nil인지 아닌지를 따져서 수정인지 새로운 메모 작성인지를 판단하여 서로 다른 메시지를 post한다.
        
        
      
    
        dismiss(animated:true, completion: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = editMemo{
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalText = memo.content
        }else{
            navigationItem.title = "새 메모"
            memoTextView.text = " "
        }
        // DetailViewController 에서 segue를 통해 화면전환이 이루어 졌을경우는 editMemo가 nil이 아니게 된다.
        //따라서 nil이 아니면 네비게이션 아이템의 타이플을 바까주고 textview의 text를 세팅해준다.
        
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
    }
   

}

extension ComposeViewController{
    static let MemoDidEdit = Notification.Name(rawValue: "MemoDidEdit")
    static let newMemoDidInsert = Notification.Name(rawValue: "new MemoDidInsert")
} // 라디오 방송은 주파수로 방송을 구분 하듯이 Notification은 이름으로 구분한다.
//여기서 Notification.name 을 static으로 선언한 이유를 추측해보면
// 다른 view controller 에서 공용으로 접근하기 때문에 static를 사용한 거 같다.
// static으로 선언하지 않으면 ComposeViewController 객체를 선언하고 해당 인스턴스에서 프로퍼티를 초기화해서 사용하면 인스턴스마다 Notification.Name이 달라 질 수도 있다.
// 마지막으로 정리하자면 특정 타입의 모든 인스턴스에서 공용으로 사용될 프로퍼티를 타입 프로퍼티로 선언한다.



extension ComposeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalText, let edited = textView.text{
            isModalInPresentation = original != edited
        } // text가 수정된 부분이 있으면 isModalInPresentation 값을 true로 줌으로써 pull-down으로 닫지 못하게 한다.
    }
}

extension ComposeViewController : UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) { // 사용자가 시작한 dismiss 시도가 차단되었음을 대리자에게 알립니다.
        let alert = UIAlertController(title: "알림", message: "편집할 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "저장", style: .default) { [weak self] (action) in
            self?.save(action)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.close(action)
        }
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    } // iisModalInPresentation 값이 true 일 때 pull-down을 하게 되면 alert 창이 화면에 나타나게 되고 저장과 수정한 것을 취소 할 수 있다.
}
