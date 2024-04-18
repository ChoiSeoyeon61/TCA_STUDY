//
//  DateExtension.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import Foundation

extension Date {
  func addingDay(_ day: Double) -> Date {
    let date = addingTimeInterval(86400 * day)
    return date
  }
}

extension Date {
  enum Format: String {
    /// yyyy.MM.dd
    case dotDateOnly = "yyyy.MM.dd"

    /// HH:mm
    case regularTimeOnly = "HH:mm"

    /// HH:mm:ss
    case fullTimeOnly = "HH:mm:ss"

    /// yyyy-MM-dd
    case regularDateOnly = "yyyy-MM-dd"

    /// yyyyMMdd
    case regularDateOnlyNoDash = "yyyyMMdd"

    /// yyyy-MM-dd HH:mm:ss
    case regularDate = "yyyy-MM-dd HH:mm:ss"

    /// yyyy-MM-dd HH:mm
    case regularDateNoSecond = "yyyy-MM-dd HH:mm"

    /// yyyy-MM-dd (HH:mm)
    case regularDateNoSecondParenthesis = "yyyy-MM-dd (HH:mm)"

    /// yyyy-MM-dd HHmm
    case noneTimeSeparator = "yyyy-MM-dd HHmm"

    /// yyyy
    case year = "yyyy"

    /// 8월 1일 12:38
    case inspectionLimitAtKo = "MM'월' dd'일' HH:mm"

    /// 04월 14일
    case monthAndDayOnlyAtKo = "MM'월' dd'일'"

    /// 4월 14일
    case monthSmallAndDayOnlyAtKo = "M'월' dd'일'"

    /// yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX
    case longDate = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

    /// 2022/01/23
    case slashDateOnly = "yyyy/MM/dd"

    /// 오후 2시
    case amPmHour = "a h'시'"

    /// 오후 2:30
    case amPmHourMinute = "a h:mm"

    /// 목
    case dayNameOnly = "E"
    
    /// 2022. 11. 21 (월)
    case dotDateDayName = "yyyy. MM. dd (E)"

    /// 20/01/01
    case shortYearSlashDateOnly = "yy/MM/dd"
    
    /// 2022. 11. 21 (월) 22:11
    case dotDateDayNameHourMinute = "yyyy. MM. dd (E) HH:mm"
    
  }

  func toString(_ format: Format, _ locale: Locale = Locale(identifier: "ko")) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateFormat = format.rawValue
    formatter.timeZone = TimeZone.autoupdatingCurrent

    return formatter.string(from: self)
  }
  
  func toUtcString(_ format: Format, _ locale: Locale = Locale(identifier: "ko")) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateFormat = format.rawValue
    formatter.timeZone = TimeZone(abbreviation: "UTC")

    return formatter.string(from: self)
  }

  static func fromString(_ string: String, format: Format) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    formatter.locale = Locale(identifier: "ko")
    let date = formatter.date(from: string)

    return date
  }
  
  static func fromUtcString(_ string: String, format: Format) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    formatter.locale = Locale(identifier: "ko")
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = formatter.date(from: string)

    return date
  }


  /// date는 yyyy-MM-dd. time은 HH:mm
  static func fromString(date: String, time: String) -> Date? {
    return fromString(date + " " + time, format: .regularDateNoSecond)
  }

  static func fromString(date: String, dateFormat: Format, time: String, timeFormat: Format) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat.rawValue + timeFormat.rawValue
    let date = formatter.date(from: date + time)

    return date
  }

  func addMonth(add: Int) -> Date? {
    return Calendar.current.date(byAdding: .month, value: add, to: self)
  }

  /// 24시간을 10분 단위로 나누어 해당 날짜의 값을 출력 (예: 00시 10분 -> 1
  func toCgfloat() -> CGFloat {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: self) * 60
    let minute = calendar.component(.minute, from: self)
    let currentHour = CGFloat((hour + minute) / 10)

    return currentHour
  }

  /// 날짜 더하기. 내일은 1, 어제는 -1
  func addDay(add: Int) -> Date? {
    return Calendar.current.date(byAdding: .day, value: add, to: self)
  }

  /// n시간 더하기. 1시간 뒤는 1, 2시간 전은  -2
  func addHour(add: Int) -> Date? {
    return Calendar.current.date(byAdding: .hour, value: add, to: self)
  }

  /// n분 더하기. 1분 뒤는 1, 2분 전은  -2
  mutating func addminute(add: Int) {
    self = Calendar.current.date(byAdding: .minute, value: add, to: self) ?? Date()
  }

  func addingMinute(add: Int) -> Date? {
    return Calendar.current.date(byAdding: .minute, value: add, to: self)
  }

  /// 24시간 전
  func yesterday() -> Date {
    return Date().addDay(add: -1)!
  }

  /// 24시간 후
  func tomorrow() -> Date {
    return Date().addDay(add: 1)!
  }

  /// Date의 시/분/초 날리기
  func timeRemoved() -> Date {
    return Date.fromString(toString(.regularDateOnly) + "T00:00:00.000+0900", format: .longDate)!
  }

  /// HH와 mm만 비교함
  public func isLessTimeThan(_ date: Date) -> Bool {
    guard let lessTime = Date.fromString("\(hour):\(minute)", format: .regularTimeOnly),
          let greatTime = Date.fromString("\(date.hour):\(date.minute)", format: .regularTimeOnly) else { return false }

    let result = Calendar.current.compare(lessTime, to: greatTime, toGranularity: .minute)
    return result.rawValue == -1
  }

  public var year: Int {
    return Calendar.current.component(.year, from: self)
  }

  public var month: Int {
    return Calendar.current.component(.month, from: self)
  }

  public var day: Int {
    return Calendar.current.component(.day, from: self)
  }

  public var hour: Int {
    return Calendar.current.component(.hour, from: self)
  }

  public var minute: Int {
    return Calendar.current.component(.minute, from: self)
  }

  public var startOfDay: Date {
    return Calendar.current.startOfDay(for: self)
  }

  public var firstDayOfMonth: Date {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month], from: self)

    return calendar.date(from: components)!
  }

  public var endOfDay: Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return Calendar.current.date(byAdding: components, to: startOfDay)!
  }

  public var endOfMonth: Date {
    var components = DateComponents()
    components.month = 1
    components.second = -1
    return Calendar(identifier: .gregorian).date(byAdding: components, to: firstDayOfMonth)!
  }

  private func isMonday() -> Bool {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: self)
    return components.weekday == 2
  }

  public static func from(year: Int = 2000, month: Int = 1, day: Int = 1) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.timeZone = TimeZone.current
    let date = Calendar.current.date(from: dateComponents)
    return date
  }

  public static func from(date: Date, time: Date) -> Date? {
    let dateTime = date.startOfDay
      .addHour(add: time.hour)?
      .addingMinute(add: time.minute)
    return dateTime
  }
}
