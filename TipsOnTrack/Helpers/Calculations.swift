
import Foundation
import UIKit

class Calculations{
    
    func findTotal(using hoursWorkedInStore: Double,_ hoursWorkedOnRoad: Double,_ hourlyPayInStore: Double,_ hourlyPayOnRoad: Double,_ milesDriven: Double,_ payPerMile: Double,_ tipsEarned: Double,and vehicleCost: Double) -> Double{
        let inStore = hourlyPay(hoursWorkedInStore, hourlyPayInStore)
        let onRoad = hourlyPay(hoursWorkedOnRoad, hourlyPayOnRoad)
        let miles = milesDriven * payPerMile
        let mileageCostTotal = vehicleCost * milesDriven

        return inStore + onRoad + miles + tipsEarned - mileageCostTotal
    }
    
    func hourlyPay(_ hoursWorked: Double,_ hourlyPay: Double) -> Double {
        let hrs = Int(hoursWorked/100)
        let min = Int(hoursWorked)%100
        let minToDecimal = Double(min)/60
        let totalTime = Double(hrs) + minToDecimal
        return totalTime * hourlyPay
    }
    
    func averageTipPerRun(using tipsEarned: Double, and numberOfDeliveries: Double) -> Double{
        let averageEarned = tipsEarned/numberOfDeliveries
        return roundToPlaces(value: averageEarned, places: 2)
    }

    func hourlyPayAverage(using totalEarned: Double,_ hoursWorkedInStore: Double,and hoursWorkedOnRoad: Double) -> Double {
        let inStoreHrs = Int(hoursWorkedInStore/100)
        let onRoadHrs = Int(hoursWorkedOnRoad/100)
        let inStoreMin = Double(Int(hoursWorkedInStore)%100)/60
        let OnRoadMin = Double(Int(hoursWorkedOnRoad)%100)/60
        let payAverage = totalEarned/(Double(inStoreHrs) + Double(onRoadHrs) + inStoreMin + OnRoadMin)
        return roundToPlaces(value: payAverage, places: 2)
    }
    
    func hourlyPayAverageForHome(income: Double, hours: Double) -> Double{
            let hrs = Int(hours/1)
            let min = hours - Double(hrs)
            let minToDecimal = Double(min)/0.6
            let totalTime = Double(hrs) + minToDecimal
            let answer = income / totalTime
        return roundToPlaces(value: answer, places: 2)
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func findTime(hours: Double) -> String {
        var days = 0
        var newHours = 0.0
        var finalHours = 0
        var minutesHelper = 0.0
        var newMin = 0.0
        let hoursInt = Int(hours)
        
        if hours/24 > 1 {
            days = Int(hours/24)
        }
        if (Double(hours) - Double(24 * days)) > 0 {
            newHours = (Double(hours) - Double(24 * days))
            finalHours = Int(newHours)
        }
        if (hours - Double(hoursInt)) > 0 {
            minutesHelper = ((hours-Double(hoursInt)))
            newMin = (roundToPlaces(value: minutesHelper, places: 2)) * 100
            if(newMin - 60 >= 0){
                newMin = newMin - 60
                finalHours = finalHours + 1
            }
        }
        return "\(days) Days \(finalHours) Hours \(Int(newMin)) Min"
        
    }
}
