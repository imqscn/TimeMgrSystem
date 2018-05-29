package timemgrsystem

import grails.gorm.transactions.Transactional
import groovy.sql.Sql

@Transactional
class RzjStaffService {

    def dataSource
    def getAllStaff() {
        def db = new Sql(dataSource)
        List list = new ArrayList()
      try{
        db.eachRow("""
          select  s.ID,s.STAFF_NAME,s.PHONE,g.GROUP_NAME
          from  rzj_group g, rzj_staff s
          where g.ID=s.STAFF_GROUP
          ORDER BY 1 asc;
       """){
          row -> list.add([row.ID,row.STAFF_NAME,row.PHONE,row.GROUP_NAME])
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
