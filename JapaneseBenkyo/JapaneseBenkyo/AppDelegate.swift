//
//  AppDelegate.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit
import AVFoundation
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // For splash launchscreen.
        sleep(1)
        
        let screen = UIScreen.main
        let bounds = screen.bounds
        
        self.window = UIWindow(frame: bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            
            navigationController = UINavigationController.init(rootViewController:viewController)
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            // Without this block, the music will stop when you play TTS.
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print("Error : \(error), \(error.userInfo)")
            }
        }
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Temp =============================================
        let processKeyDiff: [(String, String)] = [
            ("JLPT N5", "N5"),
            ("JLPT N4", "N4"),
            ("JLPT N3", "N3"),
            ("JLPT N2", "N2"),
            ("JLPT N1", "N1"),
        ]
        
        for i in processKeyDiff {
            if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.process) {
                var process = JSONManager.shared.decodeProcessJSON(jsonData: jsonData)
                if let temp = process[i.0] {
                    process.removeValue(forKey: i.0)
                    process[i.1] = temp
                }
                UserDefaultManager.shared.process = JSONManager.shared.encodeProcessJSON(process: process)
            }
        }
        
        if let jsonData = JSONManager.shared.convertStringToData(jsonString: UserDefaultManager.shared.kanjiBookmark) {
            if let oldKanjis = try? JSONDecoder().decode([OldKanji].self, from: jsonData) {
                var result: [Kanji] = []
                let files: [IndexEnum] = [.elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle]
                for file in files {
                    if let jsonData = JSONManager.shared.openJSON(path: file.getFileName()) {
                        let kanjis: Set<Kanji> = JSONManager.shared.decodeJSONtoKanjiSet(jsonData: jsonData)
                        for oldkanji in oldKanjis {
                            for kanji in kanjis {
                                if kanji.kanji == oldkanji.kanji {
                                    result.append(kanji)
                                }
                            }
                        }
                    }
                }
                UserDefaultManager.shared.kanjiBookmark = JSONManager.shared.encodeKanjiJSON(kanjis: Set(result))
            }
        }
        // Temp =============================================
        return true
    }
    
    // Hold the screen vertically.
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    // Prevent the rootviewcontroller from being popped.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
