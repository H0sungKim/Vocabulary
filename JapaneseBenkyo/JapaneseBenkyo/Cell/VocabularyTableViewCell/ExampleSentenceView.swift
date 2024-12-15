//
//  CustomView.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.03.28.
//

import UIKit
import SkeletonView

class ExampleSentenceView: UIView {
    
    var onClickLink: (() -> Void)?
    
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var lbSentence: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        initializeView()
    }
    
    func initializeView() {
        lbSentence.clipsToBounds = true
        lbSentence.skeletonTextNumberOfLines = 1
        let title = "- Tatoeba"
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: title.count))
        btnLink.setAttributedTitle(attributedString, for: .normal)
    }
    @IBAction func onClickLink(_ sender: UIButton) {
        onClickLink?()
    }
}