//
//  CategoryTableViewCell.swift
//  PensadorAppiOS
//
//  Created by Gabriel Silva on 22/03/19.
//  Copyright © 2019 Gabriel Silva. All rights reserved.
//

import UIKit

protocol CallPhrasesDelegate {
    func callPhrasesInView(urlApi: String, title: String)
}

class CategoryCell: UITableViewCell {
    static let identifier = "CategoryCell"

    @IBOutlet weak var imgExpand: UIImageView?
    @IBOutlet weak var lblCategory: UILabel?
    @IBOutlet weak var insideTableView: UITableView? {
        didSet {
            insideTableView?.isScrollEnabled = false
        }
    }
    var listCat: [ListCat] = []
    var delegateSend: CallPhrasesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(category: Thinker) {
        lblCategory?.text = String(format: "- %@", category.name ?? "")
        insideTableView?.delegate = self
        insideTableView?.dataSource = self
    }

}

extension CategoryCell: UITableViewDelegate {}

extension CategoryCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = CategoryInsideCell.identifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryInsideCell {
            cell.lblListCategory?.text = listCat[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = listCat[indexPath.row].urlAPI, let name = listCat[indexPath.row].name {
            self.delegateSend?.callPhrasesInView(urlApi: url, title: name)
        }
    }
}
