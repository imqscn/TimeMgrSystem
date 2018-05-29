package timemgrsystem

class RzjStaff {
    String staffName
    String username
    String password
    String phone
    int staffGroup
    static constraints = {
        staffName(unique: true)
        username(unique: true)
        phone(size:11..11,blank:false)
    }
    static mapping = {
        version false
    }
}
