import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    public func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        return Calendar.current.shortMonthSymbols[Int(value)]
    }
}
