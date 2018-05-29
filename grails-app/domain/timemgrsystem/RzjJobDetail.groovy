package timemgrsystem

class RzjJobDetail {
    BigDecimal staffId
    Date workDate
    BigDecimal projectId
    int taskInfo
    BigDecimal workHour
    int taskType
    String remark
    static constraints = {
    }
    static mapping = {
        version false
    }
}
