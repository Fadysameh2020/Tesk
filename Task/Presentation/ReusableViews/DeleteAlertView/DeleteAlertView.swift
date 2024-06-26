//
//  DeleteAlertView.swift
//  Task
//
//  Created by Fady Sameh on 6/26/24.
//

import UIKit
import Combine

class DeleteAlertView: NibLoadingView {

    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    
    private var deleteButtonRef: PassthroughSubject<Void, Never> = .init()
    private var cancelButtonRef: PassthroughSubject<Void, Never> = .init()
    
    var cancellables = Set<AnyCancellable>()

    var deleteButtonPublisher: AnyPublisher<Void, Never> {
        return deleteButtonRef.eraseToAnyPublisher()
    }
    
    var cancelButtonPublisher: AnyPublisher<Void, Never> {
        return cancelButtonRef.eraseToAnyPublisher()
    }
    
    func addObserver() {
        deleteButton
            .publisher(forEvent: .touchUpInside)
            .subscribe(deleteButtonRef)
            .store(in: &cancellables)
        
        cancelButton
            .publisher(forEvent: .touchUpInside)
            .subscribe(cancelButtonRef)
            .store(in: &cancellables)
    }
    
}
