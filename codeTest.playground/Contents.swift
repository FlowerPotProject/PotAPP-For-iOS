import UIKit

Calendar.current.component(.weekday, from: Date())

var score: Int = 0 {
    willSet(newScore) {
        print("---> did \(score), now \(newScore)")
    }
}

score = 30
