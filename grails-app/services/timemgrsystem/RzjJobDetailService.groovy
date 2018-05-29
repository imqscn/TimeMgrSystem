package timemgrsystem

import grails.gorm.transactions.Transactional
import groovy.sql.Sql


@Transactional
class RzjJobDetailService {

    def dataSource
    def getAllJobDetails(int userId,String userName) {
      def db = new Sql(dataSource)
      List list = new ArrayList()
      try{
        StringBuilder sb = new StringBuilder();
        sb.append("select d.ID,s.STAFF_NAME,p.PRJ_NAME,t.NAME as TYPE,i.NAME as INFO,d.WORK_HOUR,d.WORK_DATE,d.REMARK \n" +
          "          from  rzj_job_detail d, rzj_project p, rzj_staff s,task_type t,task_info i \n" +
          "          where d.STAFF_ID=s.ID and d.PROJECT_ID=p.id and d.task_type=t.id and d.task_info=i.id ")
        if(!userName.equalsIgnoreCase("admin")){
          sb.append("AND s.ID =").append(userId)
        }
        sb.append(" ORDER BY 1 desc;")
        db.eachRow(sb.toString()){
          row -> list.add([row.ID, row.STAFF_NAME, row.PRJ_NAME, row.TYPE,row.INFO,row.WORK_HOUR, (row.WORK_DATE).toString(), row.REMARK])
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
