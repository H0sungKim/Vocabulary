//
//  KanjiTestResultViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 3/16/24.
//

import UIKit

class KanjiTestResultViewController: UIViewController {

    var kanjisForCell: [KanjiForCell] = []
    var level: String = ""
    var day: String = ""
    var kanjiCount: Int?
    var wrongKanjiCount: Int?
    
    private var kanjiTableDataSource: KanjiTableViewHandler?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnReTest: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbSubScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kanjiTableDataSource = KanjiTableViewHandler(kanjisForCell: kanjisForCell, tableView: tableView)
        
        tableView.delegate = kanjiTableDataSource
        tableView.dataSource = kanjiTableDataSource
        tableView.register(UINib(nibName: String(describing: KanjiTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: KanjiTableViewCell.self))
        
        lbTitle.text = "\(level) \(day) 테스트 결과"
        lbScore.text = "\(Int((kanjiCount! - wrongKanjiCount!) * 100 / kanjiCount!))점"
        lbSubScore.text = "\(kanjiCount! - wrongKanjiCount!)/\(kanjiCount!)"
        
        if wrongKanjiCount == 0 {
            btnBookmark.isEnabled = false
            btnReTest.isEnabled = false
            saveProcess()
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBookmark(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        kanjiTableDataSource?.addBookmarkAll()
        sender.isEnabled = false
        tableView.reloadData()
    }
    @IBAction func onClickReTest(_ sender: UIButton) {
        let vc = UIViewController.getViewController(viewControllerEnum: .kanjitest) as! KanjiTestViewController
        vc.kanjis = kanjisForCell.map { $0.kanji }
        vc.level = level
        vc.day = day
        navigationController?.replaceViewController(viewController: vc, animated: true)
    }
    @IBAction func onClickFinishTest(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private func saveProcess() {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            var process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
            if process[level] == nil {
                process[level] = [:]
            }
            process[level]?[day] = true
            
            UserDefaultManager.shared.process = JSONManager.shared.encodeProcessJSON(process: process)
        }
    }


}
