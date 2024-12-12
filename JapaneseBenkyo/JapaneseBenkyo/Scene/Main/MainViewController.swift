//
//  Main2ViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.08.31.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var process: [String: [String: Bool]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BUILD LOG ====================
        NSLog("Build : 2024.02.15 18:16")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: HeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: IndexTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IndexTableViewCell.self))
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        #else
        bannerView.adUnitID = "ca-app-pub-2315411006767482/4288834062"
        #endif
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
            process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
        }
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionEnum.allCases[section] {
        case .hiraganakatagana :
            return SectionEnum.hiraganakatagana.indexs.count+1
        case .kanji :
            return SectionEnum.kanji.indexs.count+1
        case .vocabulary :
            return SectionEnum.vocabulary.indexs.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: HeaderTableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self), for: indexPath) as? HeaderTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: HeaderTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! HeaderTableViewCell
            }
            cell.initializeView(section: SectionEnum.allCases[indexPath.section])
            return cell
        } else {
            let cell: IndexTableViewCell
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: IndexTableViewCell.self), for: indexPath) as? IndexTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: IndexTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! IndexTableViewCell
            }
            cell.initializeView(index: SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1], process: process[SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1].rawValue]?["전체보기"])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        switch SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1] {
        case .bookmark:
            let vc = UIViewController.getViewController(viewControllerEnum: .study) as! StudyViewController
            vc.indexEnum = .bookmark
            vc.sectionEnum = SectionEnum.allCases[indexPath.section]
            
            switch SectionEnum.allCases[indexPath.section] {
            case .hiraganakatagana:
                break
            case .kanji:
                if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
                    vc.kanjisForCell = JSONManager.shared.decodeJSONtoKanjiArray(jsonData: jsonData).map { KanjiForCell(kanji: $0) }
                }
                navigationController?.pushViewController(vc, animated: true)
            case .vocabulary:
                if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.vocabularyBookmark) {
                    vc.vocabulariesForCell = JSONManager.shared.decodeJSONtoVocabularyArray(jsonData: jsonData).map { VocabularyForCell(vocabulary: $0) }
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        case .hiragana:
            let vc = UIViewController.getViewController(viewControllerEnum: .hiraganakatakana) as! HiraganaKatakanaViewController
            vc.indexEnum = .hiragana
            navigationController?.pushViewController(vc, animated: true)
        case .katakana:
            let vc = UIViewController.getViewController(viewControllerEnum: .hiraganakatakana) as! HiraganaKatakanaViewController
            vc.indexEnum = .katakana
            navigationController?.pushViewController(vc, animated: true)
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle, .n5, .n4, .n3, .n2, .n1:
            let vc = UIViewController.getViewController(viewControllerEnum: .day) as! DayViewController
            vc.indexEnum = SectionEnum.allCases[indexPath.section].indexs[indexPath.row-1]
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 50
    }
}
