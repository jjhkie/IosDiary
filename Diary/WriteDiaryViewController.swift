
import UIKit

///delegate 를 통해 다이어리 화면에 일기장 객체를 전달한다.

protocol WriteDiaryViewDelegate: AnyObject{
    func didSelectRegister(diary: Diary)
}


class WriteDiaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.confirmButton.isEnabled = false
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    weak var delegate: WriteDiaryViewDelegate?
    
    /// textView Border 설정 코드
    private func configureContentsTextView(){
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    ///dateTextField 클릭 시 Date Sheet가 나오도록 하는 코드
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
        
    }
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy 년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    ///빈화면을 클릭 시 키보드 & Picker가 사라지도록 하는 코드
    ///해당 코드는 유저가 화면을 터치했을 떄 실행한다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///
    private func configureInputField(){
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
    
    ///등록 버튼을 눌렀을 때 실행하는 코드
    @IBAction func tapConfirmBUtton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return}
        guard let date = self.diaryDate else { return}
        
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectRegister(diary: diary)
        //전 화면으로 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    ///등록 버튼 활성화 판단 코드
    private func validateInputField(){
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}


extension WriteDiaryViewController: UITextViewDelegate{
    //해당 텍스트뷰에 입력될 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
