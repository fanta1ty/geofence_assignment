//
//  HomeVM.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import TSwiftHelper
import RxSwift
import RxCocoa

protocol HomeInput {
    var onAddAction: AnyObserver<()> { get }
    var onListAction: AnyObserver<()> { get }
}

protocol HomeOutput {
    var onStartAddAction: Driver<()> { get }
    var onStartListAction: Driver<()> { get }
}

final class HomeVM {
    var input: HomeInput {
        return self
    }
    
    var output: HomeOutput {
        return self
    }
    
    private var disposeBag: DisposeBag?
    
    private let addSubject = PublishSubject<()>()
    private let listSubject = PublishSubject<()>()
    
    init() {
        disposeBag = DisposeBag()
    }
    
    deinit {
        disposeBag = nil
    }
}

// MARK: - HomeInput
extension HomeVM: HomeInput {
    var onAddAction: AnyObserver<()> {
        return addSubject.asObserver()
    }
    
    var onListAction: AnyObserver<()> {
        return listSubject.asObserver()
    }
}

// MARK: - HomeOutput
extension HomeVM: HomeOutput {
    var onStartAddAction: Driver<()> {
        return addSubject.asDriver(onErrorJustReturn: ())
    }
    
    var onStartListAction: Driver<()> {
        return listSubject.asDriver(onErrorJustReturn: ())
    }
}

extension HomeVM {
    
}
