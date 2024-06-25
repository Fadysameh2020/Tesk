//
//  CustomSegmentControl.swift
//  Task
//
//  Created by Fady Sameh on 6/24/24.
//

import UIKit
import Combine

class CustomSegmentControl: NibLoadingView {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
}


//NNow

extension UISegmentedControl {
    struct Publisher: Combine.Publisher {
        typealias Output = Int
        typealias Failure = Never

        private let segmentedControl: UISegmentedControl

        init(segmentedControl: UISegmentedControl) {
            self.segmentedControl = segmentedControl
        }

        func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, segmentedControl: segmentedControl)
            subscriber.receive(subscription: subscription)
        }

        private final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Int {
            private var subscriber: S?
            private weak var segmentedControl: UISegmentedControl?

            init(subscriber: S, segmentedControl: UISegmentedControl) {
                self.subscriber = subscriber
                self.segmentedControl = segmentedControl
                self.segmentedControl?.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
            }

            func request(_ demand: Subscribers.Demand) {
                // We do nothing here since the subscription is controlled by the control events.
            }

            func cancel() {
                subscriber = nil
            }

            @objc private func valueChanged() {
                _ = subscriber?.receive(segmentedControl?.selectedSegmentIndex ?? 0)
            }
        }
    }

    func publisher() -> Publisher {
        return Publisher(segmentedControl: self)
    }
}
