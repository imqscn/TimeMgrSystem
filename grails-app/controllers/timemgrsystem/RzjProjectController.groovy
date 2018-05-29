package timemgrsystem

import grails.converters.JSON

import java.text.SimpleDateFormat

class RzjProjectController {
    def  rzjProjectService

    def addProject(){
        RzjProject rp = new RzjProject()
        try {
            rp.prjName = params.name
            rp.image = ''
            rp.addDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.date)
            rp.state = params.state
            rp.description = params.description
            if (rp.save()){
                render '1'
            }
            else render"有内容填写有误"
        }catch (Exception ex){
            render "有内容未填写，请检查"
        }
    }

    def pullProject(){
        RzjProject rp = RzjProject.findById(params.id)
        if(rp){
            List list = new ArrayList()
            if(rp.addDate != null)list.add([rp.prjName,rp.addDate.toString()[0..9],rp.state,rp.description])
            else list.add([rp.prjName,rp.addDate.toString(),rp.state,rp.description])
            render list as JSON
        }
        else render '0'
    }
    def editProject(){
        RzjProject rp = RzjProject.findById(params.id)
        try {
            if(rp){
                rp.prjName = params.name
                rp.addDate = new SimpleDateFormat("yyyy-MM-dd").parse(params.date)
                rp.state = params.state
                rp.description = params.description
                if(rp.save(flush:true)){
                    render '1'
                }
                else render "有内容填写有误"
            }
        }catch (Exception ex){
            render "有内容未填写，请检查"
        }

    }
    def deleteProject(){
        RzjProject rp = RzjProject.findByIdAndPrjName(params.id,params.name)
        if(rp){
            rp.delete(flush:true)
            render "1"
        }
        else render "ID与项目名不匹配"
    }
    def pullAllProject(){
        def projectList = rzjProjectService.getAllProject()
        try {
            render projectList as JSON
        }
        catch (Exception e){
            print e
            render 'failed'
        }
    }
    def index() { }
}
