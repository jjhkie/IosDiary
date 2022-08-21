

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary](){
        didSet{
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
    }
    
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    ///Write 에서 등록 버튼을 누른 후 정보를 받는 코드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wireDiaryViewController = segue.destination as? WriteDiaryViewController{
            wireDiaryViewController.delegate = self
        }
    }
    
    ///app을 종료해도 데이터가 저장되도록 하는 코드
    private func saveDiaryList(){
        let date = self.diaryList.map{
            [
                "title" : $0.title,
                "contents" : $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
    
    ///app을 종료한 후 저장된 값을 불러오는 코드
    private func loadDiaryList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else{ return}
        
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil}
            guard let contents = $0["contents"] as? String else { return nil}
            guard let date = $0["date"] as? Date else { return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        self.diaryList = self.diaryList.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
    }
    
    ///Date -> String 으로
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell()}
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension ViewController: WriteDiaryViewDelegate{
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        self.collectionView.reloadData()
    }
}
