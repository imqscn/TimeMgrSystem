package timemgrsystem

import grails.converters.JSON

class RzjGroupController {
    def pullGroupInfo(){
        List list = RzjGroup.list()
        render list as JSON
    }
    def index() { }
}
