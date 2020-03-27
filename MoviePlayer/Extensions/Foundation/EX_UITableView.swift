//
//  EX_UITableView.swift
//  joojoome_ios
//
//  Created by Nguyên Duy on 12/20/19.
//  Copyright © 2019 JOOJOOMEE. All rights reserved.
//

import UIKit


extension NSObject {
    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String(describing: self)
    }
}

extension UITableView {
    public func registerCell<T: UITableViewCell>(type: T.Type) {
        let nib = UINib(nibName: type.className, bundle: nil)
        register(nib, forCellReuseIdentifier: type.className)
    }
    
    public func registerCells<T: UITableViewCell>(types: [T.Type]) {
        types.forEach {
            registerCell(type: $0)
        }
    }
}

extension UICollectionView {
    public func registerCell<T: UICollectionViewCell>(type: T.Type) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
      
    public func registerCells<T: UICollectionViewCell>(types: [T.Type]) {
        types.forEach {
            registerCell(type: $0)
        }
    }
      
    public func registerReusableView<T: UICollectionReusableView>(type: T.Type, kind: String = UICollectionView.elementKindSectionHeader) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }

    public func registerReusableViews<T: UICollectionReusableView>(types: [T.Type], kind: String = UICollectionView.elementKindSectionHeader) {
        types.forEach {
            registerReusableView(type: $0, kind: kind)
        }
    }
}
