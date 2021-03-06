import UIKit

Calendar.current.component(.weekday, from: Date())

var score: Int = 0 {
    willSet(newScore) {
        print("---> did \(score), now \(newScore)")
    }
}

score = 30

let nowDate = Date()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"

var resultString = dateFormatter.string(from: nowDate)
resultString.insert("T", at: resultString.index(resultString.startIndex, offsetBy: 10))

var date = "2022-03-04T00:00:00"

let date2 = date.index(date.startIndex, offsetBy: 5)...date.index(date.startIndex, offsetBy: 7)
print(date2)
