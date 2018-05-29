package timemgrsystem

import grails.converters.JSON
import java.text.SimpleDateFormat

class RzjJobDetailController {
    def rzjJobDetailService
    def pullAllJobDetail(){
        int userId =  session.getAttribute("userId") as java.lang.Integer
        String userName = (String)session.getAttribute("userName")
        List list = rzjJobDetailService.getAllJobDetails(userId,userName)
        try {
            if(list)
                render list as JSON
        }
        catch (Exception e){
            print e
            render 'failed'
        }
    }
    def pullAllNameOfTaskType(){
        List list = TaskType.list()
        render list as JSON
    }
    def pullAllNameOfTaskInfo(){
        List list = TaskInfo.list()
        render list as JSON
    }
    def addJobDetail(){
        RzjJobDetail rjd = new RzjJobDetail()
        try {
            rjd.staffId = params.staffId as BigDecimal
            rjd.projectId = RzjProject.findByPrjName(params.projectName).getId()
            rjd.taskType = TaskType.findByName(params.type).getId()
            rjd.taskInfo = TaskInfo.findByName(params.info).getId()
            rjd.workHour = params.workHour as BigDecimal
            rjd.workDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.date)
            rjd.remark = params.remark
            if (rjd.save()){
                render '1'
            }
            else render"有内容填写有误"
        }catch (Exception ex){
            render "有内容未填写，或工时超出范围，请检查"
        }
    }

    def pullJobDetail(){
        int id = params.id as Integer
        RzjJobDetail rjd = RzjJobDetail.findById(id)
        if(rjd){
            List list = new ArrayList()
            list.add([rjd.staffId,RzjProject.findById(rjd.projectId).getPrjName(),TaskType.findById(rjd.taskType).getName(),TaskInfo.findById(rjd.taskInfo).getName(),rjd.workHour,rjd.workDate.toString()[0..9],rjd.remark])
            render list as JSON
        }
        else render '0'
    }

    def editJobDeail(){
        RzjJobDetail rjd = RzjJobDetail.findById(params.id)
        try {
            if(rjd){
                rjd.staffId = params.staffId as BigDecimal
                rjd.projectId = RzjProject.findByPrjName(params.projectName).getId()
                rjd.taskType = TaskType.findByName(params.type).getId()
                rjd.taskInfo = TaskInfo.findByName(params.info).getId()
                rjd.workHour = params.workHour as BigDecimal
                rjd.workDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.date)
                rjd.remark = params.remark
                if(rjd.save(flush:true)){
                    render '1'
                }
                else render "有内容填写有误"
            }
        }catch (Exception ex){
            render "有内容未填写，请检查"
        }
    }

    def deleteJobDetail(){
        RzjJobDetail rjd = RzjJobDetail.findByIdAndStaffId(params.id,RzjStaff.findByStaffName(params.staffName).getId() as BigDecimal)
        if(rjd){
            rjd.delete(flush:true)
            render "1"
        }
        else render "ID与项目名不匹配"
    }
    def index() { }
}
