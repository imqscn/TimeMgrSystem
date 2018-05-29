package timemgrsystem

import grails.gorm.transactions.Transactional
import groovy.sql.Sql

@Transactional
class RzjProjectService {

    def dataSource
    def getAllProject() {
        def db = new Sql(dataSource)
        List list = new ArrayList()
        try{
            db.eachRow("SELECT ID,PRJ_NAME,ADD_DATE,STATE,DESCRIPTION FROM rzj_project"){
                row -> list.add([row.ID, row.PRJ_NAME,(row.ADD_DATE).toString(), row.STATE, row.DESCRIPTION])
            }
        }catch (Exception e){
            e.printStackTrace()
        }finally{
            if(db!=null)
                db.close()
        }
        return list
    }
}
