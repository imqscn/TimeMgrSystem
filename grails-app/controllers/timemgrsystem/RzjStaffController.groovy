package timemgrsystem
import grails.converters.JSON

class RzjStaffController {
    def rzjStaffService

    def changePassword(){
        RzjStaff rs = RzjStaff.findById(params.id)
        if(rs){
            rs.password = params.password.encodeAsMD5()
            if(rs.save(flush:true))
                render "1"
            else render "密码修改失败"
        }
        else render "密码修改失败"
    }
    def signIn(){
        RzjStaff rs = RzjStaff.findByUsernameAndPassword(params.username,params.password.encodeAsMD5())
        if(rs){
            session.setAttribute("userId",rs.id)
            session.setAttribute("userName",rs.staffName)
            render('1')
        }
        else render('0')
    }

    def signUp(){
        RzjStaff rs = new RzjStaff()
        try {
            rs.username = params.username
            rs.password = params.password.encodeAsMD5()
            rs.staffName = params.personname
            rs.phone = params.phone
            rs.staffGroup = RzjGroup.findByGroupName(params.group).getId()
            if(rs.save()){
                render("1")
            }
            else render("0")
        }catch (Exception ex){
            render "error"
        }

    }

    def addStaff(){
        RzjStaff rs = new RzjStaff()
        try {
            rs.staffName = params.name
            rs.phone = params.phone
            rs.staffGroup = RzjGroup.findByGroupName(params.group).getId()
            rs.username = params.name
            rs.password = "123456"
            if (rs.save()){
                render '1'
            }
            else render"有内容填写格式有误或员工名重复"
        }
        catch(Exception ex){
            render "有内容未填写，请检查"
        }
    }

    def pullStaff(){
        RzjStaff rs = RzjStaff.findById(params.id)
        if(rs){
            List list = new ArrayList()
            list.add([rs.staffName,rs.phone,RzjGroup.findById(rs.staffGroup).getGroupName()])
            render list as JSON
        }
        else render '0'
    }

    def editStaff(){
        RzjStaff rs = RzjStaff.findById(params.id)
        if(rs){
            try {
                rs.staffName = params.name
                rs.staffGroup = RzjGroup.findByGroupName(params.group).getId()
                rs.phone = params.phone
                if(rs.save(flush:true)){
                    render '1'
                }
                else render "有内容填写格式有误或员工名重复"
            }catch (Exception ex){
                render "有内容未填写，请检查"
            }
        }
    }

    def deleteStaff(){
        RzjStaff rs = RzjStaff.findByIdAndStaffName(params.id,params.name)
        if(rs){
            rs.delete(flush:true)
            render "1"
        }
        else render "ID与员工名不匹配"
    }

    def pullAllStaff(){
        def staffList = rzjStaffService.getAllStaff()
        try {
            render staffList as JSON
        }
        catch (Exception e){
            print e
            render 'failed'
        }
    }

    def index(){}
    def login(){}
}
