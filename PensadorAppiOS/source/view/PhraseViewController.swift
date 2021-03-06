//
//  FraseViewController.swift
//  PensadorAppiOS
//
//  Created by Gabriel Silva on 22/03/19.
//  Copyright © 2019 Gabriel Silva. All rights reserved.
//

import UIKit
import Lottie

class PhraseViewController: UIViewController {

    var presenter: PhrasePresenter?
    var param = ""
    var phrases: [Phrase] = []
    var phraseSelected: Phrase?
    var page = 1
    var titleMainView: String?
    var alreadyPassed: Bool = false
    var fromCategory = false
    var fromSearch = false
    var loading: Loading?
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PhrasePresenter(self)
        
        if fromCategory {
            presenter?.getPrasesCategoryResult(param: param, page: page)
        }
        
        if fromSearch {
            presenter?.getSearchResult(param: param, page: page)
        }
        
        loading = Loading(frame: self.view.frame, center: self.view.center)
        
        if let lndg = loading {
            self.view.addSubview(lndg)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let titleFromMainView = titleMainView {
            lblTitle?.text = titleFromMainView
        } else {
            lblTitle?.text = param
        }
    }
    
    @objc func tapBtnCopy(sender: UIButton) {
        let buttonTag = sender.tag
        if let text = phrases[buttonTag].text, text != "" {
            UIPasteboard.general.string = text
            showToast(message: "Copied successfully!", mode: .success )
        } else {
            showToast(message: "Failed to copy, please try again!", mode: .error)
        }
    }
    
    @objc func tapBtnShare(sender: UIButton) {
        let buttonTag = sender.tag
        if let text = phrases[buttonTag].text {
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            present(vc, animated: true)
        }
    }

}

extension PhraseViewController: UITableViewDelegate {}

extension PhraseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = PhrasesCell.identifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PhrasesCell {
            cell.prepareCell(phrases: phrases[indexPath.row])
            cell.btnCopy?.addTarget(self, action: #selector(tapBtnCopy(sender:)), for: .touchUpInside)
            cell.btnCopy?.tag = indexPath.row
            cell.btnShare?.addTarget(self, action: #selector(tapBtnShare(sender:)), for: .touchUpInside)
            cell.btnShare?.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (!alreadyPassed) {
            alreadyPassed = true
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.loading?.alpha = 0.0
            }, completion: {(isCompleted) in
                self.tableView?.isHidden = false
                self.loading?.removeFromSuperview()

            })
        }
        
        if indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 3 {
            if fromCategory {
                presenter?.getPrasesCategoryResult(param: param, page: page+1)
            }
            if fromSearch {
                presenter?.getSearchResult(param: param, page: page+1)
            }
            
            page = page+1
        }
    }

    
}

extension PhraseViewController: PhraseDelegate {
    func onSuccessSearch(phrases: List) {
        print("")
        for item in phrases.list {
            self.phrases.append(item)
        }
        tableView?.reloadData()
    }
    
    func onFailure(message: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.showToast(message: "Failed to request", mode: .error)
            self.loading?.removeFromSuperview()
            self.tableView?.isHidden = true
        }
        print(message)
    }
}
