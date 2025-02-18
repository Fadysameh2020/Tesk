//
//  NewMailBoxView.swift
//  Task
//
//  Created by Fady Sameh on 6/25/24.
//

import UIKit
import Combine

class NewMailBoxView: NibLoadingView {

    @IBOutlet private weak var doneButton: UIButton!

    private var doneButtonRef: PassthroughSubject<Void, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()

    var doneButtonPublisher: AnyPublisher<Void, Never> {
        return doneButtonRef.eraseToAnyPublisher()
    }
    
    func addObserver() {
        doneButton
            .publisher(forEvent: .touchUpInside)
            .subscribe(doneButtonRef)
            .store(in: &cancellables)
    }
    
}

extension UIControl {
    func publisher(forEvent event: Event = .primaryActionTriggered) -> Publishers.Control {
        .init(control: self, event: event)
    }
}

extension Publishers {
    struct Control: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            subscriber.receive(subscription: Subscription(subscriber, control, event))
        }
        
        private class Subscription<S>: NSObject, Combine.Subscription where S: Subscriber, S.Input == Void, S.Failure == Never {
            private var subscriber: S?
            private weak var control: UIControl?
            private let event: UIControl.Event
            private var unconsumedDemand = Subscribers.Demand.none
            private var unconsumedEvents = 0
            
            init(_ subscriber: S, _ control: UIControl, _ event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                self.event = event
                super.init()
                
                control.addTarget(self, action: #selector(onEvent), for: event)
            }
            
            deinit {
                control?.removeTarget(self, action: #selector(onEvent), for: event)
            }
            
            func request(_ demand: Subscribers.Demand) {
                unconsumedDemand += demand
                consumeDemand()
            }
            
            func cancel() {
                subscriber = nil
            }
            
            private func consumeDemand() {
                while let subscriber = subscriber, unconsumedDemand > 0, unconsumedEvents > 0 {
                    unconsumedDemand -= 1
                    unconsumedEvents -= 1
                    unconsumedDemand += subscriber.receive(())
                }
            }
            
            @objc private func onEvent() {
                unconsumedEvents += 1
                consumeDemand()
            }
        }
    }
}
