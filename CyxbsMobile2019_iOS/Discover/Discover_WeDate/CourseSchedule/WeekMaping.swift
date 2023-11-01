//
//  WeekMaping.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/9/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

/// 数组映射
class WeekMaping {
    
    /// 返回一个映射某人某周课程安排的二维数组
    /// - Parameters:
    ///   - stuNum: 学号
    ///   - weekNum: 周数（展示整学期则传入0
    /// - Returns: 二维数组
    private static func mapPersonWeekToAry(stuNum: String, weekNum: Int, completion: @escaping ([[StudentResultItem]]) -> Void) {
        /// 一个七列十二行的二维数组，映射某人某周或整学期的课程安排
        var perHeadAry = [[StudentResultItem]](repeating: [StudentResultItem](repeating: StudentResultItem(dictionary: [:]), count: 12), count: 7)
        CourseScheduleModel.requestWithStuNum(stuNum) { courseScheduleModel in
            let student = courseScheduleModel.student
            // 为整学期
            if weekNum == 0 {
                for course in courseScheduleModel.courseAry {
                    for i in 0..<course.period {
                        perHeadAry[course.dayNum - 1][course.beginLesson - 1 + i] = student
                    }
                }
            // 为某周
            } else {
                for course in courseScheduleModel.courseAry {
                    if course.inWeeks.contains(weekNum) {
                        for i in 0..<course.period {
                            perHeadAry[course.dayNum - 1][course.beginLesson - 1 + i] = student
                        }
                    }
                }
            }
            completion(perHeadAry)
        } failure: { error in
            print(error)
        }
    }
    
    /// 返回一个映射所有人某周课程安排的三维数组
    /// - Parameters:
    ///   - stuNumAry: 学号数组
    ///   - weekNum: 周数（展示整学期则传入0
    ///   - completion: 三维数组
    private static func mapWeekToAry(stuNumAry: [String], weekNum: Int, completion: @escaping ([[[StudentResultItem]]]) -> Void) {
        /// 一个三维数组，映射所有人某周或整学期的课程安排
        var weekAry = [[[StudentResultItem]]](repeating: [[StudentResultItem]](repeating: [StudentResultItem](), count: 12), count: 7)
        let group = DispatchGroup()
        for stuNum in stuNumAry {
            group.enter()
            mapPersonWeekToAry(stuNum: stuNum, weekNum: weekNum) { personWeekAry in
                for i in 0..<personWeekAry.count {
                    for j in 0..<personWeekAry[i].count {
                        if !personWeekAry[i][j].studentID.isEmpty {
                            weekAry[i][j].append(personWeekAry[i][j])
                        }
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(weekAry)
        }
    }
    
    /// 返回一个映射所有人所有周课程安排的三维数组
    /// - Parameters:
    ///   - stuNumAry: 学号数组
    ///   - completion: 三维数组（内为字典
    static func mapAry(stuNumAry: [String], completion: @escaping ([[[String: Any]]]) -> Void) {
        /// 一个三维数组，映射所有人所有周的课程安排
        var array: [[[String: Any]]] = []
        /// 标识时间数组
        let timeAry = [
            "8:00", "8:45", "8:55", "9:40", "10:15", "11:00", "11:10", "11:55", "14:00", "14:45", "14:55", "15:40", "16:15", "17:00", "17:10", "17:55", "19:00", "19:45", "19:55", "20:40", "20:50", "21:35", "21:45", "22:30"
        ]
        let group = DispatchGroup()
        for weekNum in 0...25 {
            group.enter()
            if weekNum >= array.count {
                array.append([])
            }
            mapWeekToAry(stuNumAry: stuNumAry, weekNum: weekNum) { weekAry in
                weekAry.enumerated().forEach { dayIndex, lessons in
                    var j = 0
                    
                    while j < lessons.count {
                        let lesson = lessons[j]
                        let beginLesson = j + 1
                        var count = 1
                        var endLesson: Int
                        
                        if let nextLessonIndex = (j + 1..<lessons.count).first(where: { !lessons[$0].isEmpty }) {
                            endLesson = nextLessonIndex + 1
                            count = endLesson - beginLesson
                        } else {
                            endLesson = (beginLesson % 4 == 0) ? beginLesson : (beginLesson / 4 + 1) * 4
                        }
                        
                        let startTime = timeAry[beginLesson * 2 - 2]
                        let endTime = timeAry[endLesson * 2 - 1]
                        
                        let element: [String: Any] = [
                            "beginLesson": beginLesson,
                            "student": lesson,
                            "length": count,
                            "dayNum": dayIndex + 1,
                            "timePeriod": "\(startTime)-\(endTime)"
                        ]
                        
                        array[weekNum].append(element)
                        
                        j = endLesson
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(array)
        }
    }
}
