//
//  Presenter.swift
//  PensadorAppiOS
//
//  Created by Gabriel Silva on 21/03/19.
//  Copyright © 2019 Gabriel Silva. All rights reserved.
//

protocol PensadorDelegate: class {
    func onSuccessCategories(category: [Thinker])
    func onFailure(message: String?)
}

import Foundation

final class MainPresenter {
    
    weak var view: PensadorDelegate?
    
    init() {}
    
    init(_ view: PensadorDelegate) {
        self.view = view
    }
    
    func getCategory() {
       ServiceAPI.sharedInstance.getCategories( success: { category in
            self.view?.onSuccessCategories(category: category)
        }, fail: { error in
            self.view?.onFailure(message: error)
        })
    }
}