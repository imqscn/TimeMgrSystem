<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

        <asset:javascript src ="jquery-2.2.0.min.js"/>
        <asset:stylesheet src ="bootstrap.css"/>
        <asset:javascript src ="bootstrap.js"/>
        <asset:stylesheet src ="bootstrap-select.min.css"/>
        <asset:javascript src ="bootstrap-select.min.js"/>
        <asset:javascript src ="defaults-zh_CN.min.js"/>

		<title>工时管理系统</title>

        <script>
            currentUserName = "<%=session.getAttribute("userName")%>"
            currentUserId = "<%=session.getAttribute("userId")%>"
            var selectedID = null
            function logout() {
                window.location.href="RzjStaff/login"
            }
            function clearInput() {
                $("input[type='text']").val("")
                $("input[type='tel']").val("")
                $("input[type='number']").val("")
                $("#spAddJobDetailProject").selectpicker('val', '---请选择相关项目---')
                $("#spEditJobDetailProject").selectpicker('val', '---请选择相关项目---')
                $("#spAddJobDetailTaskType").selectpicker('val', '---请选择任务类型---')
                $("#spEditJobDetailTaskType").selectpicker('val', '---请选择任务类型---')
                $("#spAddJobDetailTaskInfo").selectpicker('val', '---请选择任务状态---')
                $("#spEditJobDetailTaskInfo").selectpicker('val', '---请选择任务状态---')
                $("#spAddStaffGroup").selectpicker('val', '软件系统部')
                $("#spEditStaffGroup").selectpicker('val', '软件系统部')
                $("select").selectpicker('refresh');
            }

            function pullAllStaff() {
                $.ajax({
                    url:'RzjStaff/pullAllStaff',
                    type:'post',
                    success:function (data) {
                        if(data == 'failed')
                            alert("获取列表失败")
                        else {
                            fillStaffTable(data)
                            $("#tableBodyOfStaff tr").dblclick(function () {
                                selectedID = $(this).children("td.idStaff").html()
                                if(selectedID != null){
                                    if(selectedID != '员工ID'){
                                        fillEditStaffModal()
                                        $("#modalEditStaff").modal('show')
                                    }
                                    else alert("如果您想编辑员工，请双击员工行")
                                }
                                else {
                                    alert("出错啦！未获取到点击行的ID项")
                                }
                            })
                            $("#btnSelectAllStaff").click(function () {
                                if($("#btnSelectAllStaff").html()=="全选") {
                                    $("#tableBodyOfStaff input[type=\"checkbox\"]").prop("checked",true)
                                    $("#btnSelectAllStaff").html("反选")
                                }
                                else {
                                    $("#tableBodyOfStaff input[type=\"checkbox\"]").prop("checked",false)
                                    $("#btnSelectAllStaff").html("全选")
                                }
                            })
                        }
                    },
                    error:function () {
                        alert("连接异常")
                    }
                })
            }
            function pullAllProject() {
                $.ajax({
                    url:'RzjProject/pullAllProject',
                    type:'post',
                    success:function (data) {
                        if(data == 'failed')
                            alert("获取列表失败")
                        else {
                            fillProjectTable(data)
                            $("#tableBodyOfProject tr").dblclick(function () {
                                selectedID = $(this).children("td.idProject").html()
                                if(selectedID != null){
                                    if(selectedID != '项目ID'){
                                        fillEditProjectModal()
                                        $("#modalEditProject").modal('show')
                                    }
                                    else alert("如果您想编辑项目，请双击项目行")
                                }
                                else {
                                    alert("出错啦！未获取到点击行的ID项")
                                }
                            })
                            $("#btnSelectAllProject").click(function () {
                                if($("#btnSelectAllProject").html()=="全选") {
                                    $("#tableBodyOfProject input[type=\"checkbox\"]").prop("checked",true)
                                    $("#btnSelectAllProject").html("反选")
                                }
                                else {
                                    $("#tableBodyOfProject input[type=\"checkbox\"]").prop("checked",false)
                                    $("#btnSelectAllProject").html("全选")
                                }
                            })
                        }
                    },
                    error:function () {
                        alert("连接异常")
                    }
                })
            }
            function pullAllJobDetail() {
                $.ajax({
                    url:'RzjJobDetail/pullAllJobDetail',
                    type:'post',
                    success:function (data) {
                        if(data == 'failed')
                            alert("获取列表失败")
                        else {
                            fillJobDetailTable(data)
                            $("#tableBodyOfJobDetail tr").dblclick(function () {
                                selectedID = $(this).children("td.idJobDetail").html()
                                if (selectedID != null) {
                                    if ($(this).children("td.idJobDetail").next().html() == currentUserName || currentUserName == "admin") {
                                        fillEditJobDetailModal()
                                        $("#modalEditJobDetail").modal('show')
                                    }
                                    else alert("您只能编辑自己的工时记录")
                                }
                                else {
                                    alert("出错啦！未获取到点击行的ID项")
                                }
                            })
                            $("#btnSelectAllJobDetail").click(function () {
                                if ($("#btnSelectAllJobDetail").html() == "全选") {
                                    $("#tableBodyOfJobDetail input[type=\"checkbox\"]").prop("checked", true)
                                    $("#btnSelectAllJobDetail").html("反选")
                                }
                                else {
                                    $("#tableBodyOfJobDetail input[type=\"checkbox\"]").prop("checked", false)
                                    $("#btnSelectAllJobDetail").html("全选")
                                }
                            })
                            $(".page").html("")
                            var currentPage = 0
                            var pageSize = 10
                            var $table = $("#jobDetailTable")
                            $table.bind('paging', function () {
                                $table.find('tbody tr').hide().slice(currentPage*pageSize,(currentPage+1)*pageSize).show();
                            });
                            var sumRows=$table.find('tbody tr').length;//获取数据总行数
                            var sumPages=Math.ceil(sumRows/pageSize);//得到总页数
                            var $pager=$('<div class="page"></div>');
                            for(var pageIndex=0;pageIndex<sumPages;pageIndex++){
                                $('<a href="#"><span>'+(pageIndex+1)+'</span></a>').bind("click",{"newPage":pageIndex},function(event){
                                    currentPage=event.data["newPage"];
                                    console.log(currentPage)
                                    $table.trigger("paging");
                                }).appendTo($pager);
                                $pager.append(" ");
                            }
                            $pager.insertAfter($table);
                            $table.trigger("paging");

                        }

                    },
                    error:function () {
                        alert("连接异常")
                    }
                })
            }
            function pullAllNameOfTaskType() {
                $.ajax({
                    url:'RzjJobDetail/pullAllNameOfTaskType',
                    type:'post',
                    success:function (data) {
                        if(data == 'failed')
                            alert("获取任务类型失败")
                        else {
                            fillSpTaskType(data)
                            }
                    },
                    error:function () {
                        alert("连接异常")
                    }
                })
            }
            function pullAllNameOfTaskInfo() {
                $.ajax({
                    url:'RzjJobDetail/pullAllNameOfTaskInfo',
                    type:'post',
                    success:function (data) {
                        if(data == 'failed')
                            alert("获取任务状态失败")
                        else {
                            fillSpTaskInfo(data)
                        }
                    },
                    error:function () {
                        alert("连接异常")
                    }
                })
            }
            //初始化
            $(function () {
                if(currentUserId == ""){
                    window.location.href="RzjStaff/login"
                }
                else {

                    if(currentUserName != "admin"){
                        $("#inputDeleteJobDetailStaffName").val(currentUserName)
                        $("#inputDeleteJobDetailStaffName").attr("disabled",true)
                    }
                    pullAllStaff()
                    pullAllProject()
                    pullAllJobDetail()
                    pullAllNameOfTaskType()
                    pullAllNameOfTaskInfo()



                    //员工操作
                    $("#btnAddStaff").click(function () {
                        $("#modalAddStaff").modal('show')
                    })
                    $("#btnDeleteStaff").click(function () {
                        if($("#tableBodyOfStaff input[type=\"checkbox\"]").is(':checked'))
                            $("#modalDeleteMoreStaff").modal('show')
                        else
                            $("#modalDeleteStaff").modal('show')
                    })
                    $("#btnSubmitAddStaff").click(function () {
                        var dataReady = {
                            'name':$("#inputAddStaffName").val(),
                            'phone':$("#inputAddStaffPhone").val(),
                            'group':$("#spAddStaffGroup").find("option:selected").text()
                        }
                        $.ajax({
                                url:'RzjStaff/addStaff',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("添加成功")
                                        pullAllStaff()
                                        clearInput()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("添加失败，网络连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitEditStaff").click(function () {
                        var dataReady = {
                            'id':$("#inputEditStaffId").val(),
                            'name':$("#inputEditStaffName").val(),
                            'phone':$("#inputEditStaffPhone").val(),
                            'group':$("#spEditStaffGroup").find("option:selected").text()
                        }
                        $.ajax({
                                url:'RzjStaff/editStaff',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("修改成功")
                                        pullAllStaff()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteStaff").click(function () {
                        var dataReady = {
                            'id':$("#inputDeleteStaffId").val(),
                            'name':$("#inputDeleteStaffName").val(),
                        }
                        $.ajax({
                                url:'RzjStaff/deleteStaff',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("删除成功")
                                        pullAllStaff()
                                        clearInput()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("删除失败，网络连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteMoreStaff").click(function () {
                        var dataReady
                        var countFailed = 0
                        $("#tableBodyOfStaff :checked").each(function () {
                            dataReady = {
                                'id':$(this).parent().next().html(),
                                'name':$(this).parent().next().next().html()
                            }
                            $.ajax({
                                    url:'RzjStaff/deleteStaff',
                                    data:dataReady,
                                    type:'post',
                                    success:function (data) {
                                        if(data=='1'){
                                            countFailed = (countFailed + 1)
                                            pullAllStaff()
                                            clearInput()
                                        }
                                    },
                                    error:function () {
                                    }
                                }
                            )
                            console.log($(this).parent().next().html())
                        })
                        alert("删除完成，"+countFailed+"个员工删除成功")
                    })
                    //项目操作
                    $("#btnAddProject").click(function () {
                        $("#inputAddProjectDate").attr('value',new Date().toJSON().substr(0,10))
                        $("#modalAddProject").modal('show')
                    })
                    $("#btnDeleteProject").click(function () {
                        if($("#tableBodyOfProject input[type=\"checkbox\"]").is(':checked'))
                            $("#modalDeleteMoreProject").modal('show')
                        else $("#modalDeleteProject").modal('show')
                    })
                    $("#btnSubmitAddProject").click(function () {
                        var dataReady = {
                            'name':$("#inputAddProjectName").val(),
                            'date':$("#inputAddProjectDate").val(),
                            'state':$("#inputAddProjectState").val(),
                            'description':$("#inputAddProjectDescription").val()
                        }
                        $.ajax({
                                url:'RzjProject/addProject',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("添加成功")
                                        pullAllProject()
                                        clearInput()
                                    }
                                    else {
                                        alert("添加失败")
                                    }
                                },
                                error:function () {
                                    alert("添加失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitEditProject").click(function () {
                        var dataReady = {
                            'id':$("#inputEditProjectId").val(),
                            'name':$("#inputEditProjectName").val(),
                            'date':$("#inputEditProjectDate").val(),
                            'state':$("#inputEditProjectState").val(),
                            'description':$("#inputEditProjectDescription").val()
                        }
                        $.ajax({
                                url:'RzjProject/editProject',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("修改成功")
                                        pullAllProject()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteProject").click(function () {
                        var dataReady = {
                            'id':$("#inputDeleteProjectId").val(),
                            'name':$("#inputDeleteProjectName").val()
                        }
                        $.ajax({
                                url:'RzjProject/deleteProject',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("删除成功")
                                        pullAllProject()
                                        clearInput()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteMoreProject").click(function () {
                        var dataReady
                        var countFailed = 0
                        $("#tableBodyOfProject :checked").each(function () {
                            dataReady = {
                                'id':$(this).parent().next().html(),
                                'name':$(this).parent().next().next().html()
                            }
                            $.ajax({
                                    url:'RzjProject/deleteProject',
                                    data:dataReady,
                                    type:'post',
                                    success:function (data) {
                                        if(data=='1'){
                                            countFailed = countFailed + 1
                                            pullAllProject()
                                            clearInput()
                                        }
                                    },
                                    error:function () {
                                    }
                                }
                            )
                            console.log($(this).parent().next().html())
                        })
                        alert("删除完成，"+countFailed+"个项目删除成功")
                    })
                    //工时操作
                    $("#btnAddJobDetail").click(function () {
                        $("#inputAddJobDetailDate").attr('value',new Date().toJSON().substr(0,10))
                        $("#modalAddJobDetail").modal('show')
                    })
                    $("#btnDeleteJobDetail").click(function () {
                        if($("#tableBodyOfJobDetail input[type=\"checkbox\"]").is(':checked'))
                            $("#modalDeleteMoreJobDetail").modal('show')
                        else $("#modalDeleteJobDetail").modal('show')
                    })
                    $("#btnSubmitAddJobDetail").click(function () {
                        var dataReady = {
                            'staffId':$("#inputAddJobDetailStaffId").val(),
                            'projectName':$("#spAddJobDetailProject").find("option:selected").text(),
                            'type':$("#spAddJobDetailTaskType").find("option:selected").text(),
                            'info':$("#spAddJobDetailTaskInfo").find("option:selected").text(),
                            'workHour':$("#inputAddJobDetailWorkHour").val(),
                            'date':$("#inputAddJobDetailDate").val(),
                            'remark':$("#inputAddJobDetailRemark").val()
                        }
                        $.ajax({
                                url:'RzjJobDetail/addJobDetail',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("添加成功")
                                        pullAllJobDetail()
                                        clearInput()
                                        $("#inputAddJobDetailStaffId").val(currentUserId)
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitEditJobDetail").click(function () {
                        var dataReady = {
                            'id':$("#inputEditJobDetailId").val(),
                            'staffId':$("#inputEditJobDetailStaffId").val(),
                            'projectName':$("#spEditJobDetailProject").find("option:selected").text(),
                            'type':$("#spEditJobDetailTaskType").find("option:selected").text(),
                            'info':$("#spEditJobDetailTaskInfo").find("option:selected").text(),
                            'workHour':$("#inputEditJobDetailWorkHour").val(),
                            'date':$("#inputEditJobDetailDate").val(),
                            'remark':$("#inputEditJobDetailRemark").val()
                        }
                        $.ajax({
                                url:'RzjJobDetail/editJobDeail',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("修改成功")
                                        pullAllJobDetail()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteJobDetail").click(function () {
                        var dataReady = {
                            'id':$("#inputDeleteJobDetailId").val(),
                            'staffName':$("#inputDeleteJobDetailStaffName").val()
                        }
                        $.ajax({
                                url:'RzjJobDetail/deleteJobDetail',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("删除成功")
                                        pullAllJobDetail()
                                        clearInput()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            }
                        )
                    })
                    $("#btnSubmitDeleteMoreJobDetail").click(function () {
                        var dataReady
                        var countFailed = 0
                        $("#tableBodyOfJobDetail :checked").each(function () {
                            dataReady = {
                                'id':$(this).parent().next().html(),
                                'staffName':$(this).parent().next().next().html()
                            }
                            $.ajax({
                                    url:'RzjJobDetail/deleteJobDetail',
                                    data:dataReady,
                                    type:'post',
                                    success:function (data) {
                                        if(data=='1'){
                                            countFailed = countFailed + 1
                                            pullAllJobDetail()
                                            clearInput()
                                        }
                                    },
                                    error:function () {
                                    }
                                }
                            )
                            console.log($(this).parent().next().html())
                        })
                        alert("删除完成，"+countFailed+"个工时记录删除成功")
                    })

                    //修改密码
                    $("#btnSubmitNewPassword").click(function () {
                        if($("#inputNewPassword").val() == $("#inputRepeatNewPassword").val()){
                            var dataReady = {
                                'id': currentUserId,
                                'password':$("#inputRepeatNewPassword").val()
                            }
                            $.ajax({
                                url:'RzjStaff/changePassword',
                                data:dataReady,
                                type:'post',
                                success:function (data) {
                                    if(data=='1'){
                                        alert("密码修改成功")
                                        $("#inputNewPassword").val("")
                                        $("#inputRepeatNewPassword").val("")
                                        logout()
                                    }
                                    else alert(data)
                                },
                                error:function () {
                                    alert("修改失败，连接异常")
                                }
                            })
                        }
                        else alert("密码不一致")
                    })
                }
            })

            function showChangPasswordModal() {
                $("#modalChangePassword").modal('show')
            }
            function fillEditStaffModal() {
                var dataReady = {
                    'id':selectedID
                }
                $.ajax({
                    url:'RzjStaff/pullStaff',
                    type:'post',
                    data:dataReady,
                    success:function (data) {
                        if(data=='0'){
                            alert("未能找到与此ID匹配的员工")
                        }
                        else{
                            $("#inputEditStaffId").val(selectedID)
                            $("#inputEditStaffName").val(data[0][0])
                            $("#inputEditStaffPhone").val(data[0][1])
                            $("#spEditStaffGroup").selectpicker('val', data[0][2])
                            selectedID = null
                        }
                    },
                    error:function () {
                        alert("网络连接异常")
                    }
                })
            }
            function fillEditProjectModal() {
                var dataReady = {
                    'id':selectedID
                }
                $.ajax({
                    url:'RzjProject/pullProject',
                    type:'post',
                    data:dataReady,
                    success:function (data) {
                        if(data==0){
                            alert("未能找到与此ID匹配的项目")
                            return
                        }

                        $("#inputEditProjectId").val(selectedID)
                        $("#inputEditProjectName").val(data[0][0])
                        $("#inputEditProjectDate").attr('value',data[0][1])
                        $("#inputEditProjectState").val(data[0][2])
                        $("#inputEditProjectDescription").val(data[0][3])
                        selectedID = null
                    },
                    error:function () {
                        alert("网络连接异常")
                    }
                })
            }
            function fillEditJobDetailModal() {
                var dataReady = {
                    'id':selectedID
                }
                $.ajax({
                    url:'RzjJobDetail/pullJobDetail',
                    type:'post',
                    data:dataReady,
                    success:function (data) {
                        if(data=='0'){
                            alert("未能找到与此ID匹配的项目")
                        }
                        else{
                            $("#inputEditJobDetailId").val(selectedID)
                            $("#inputEditJobDetailStaffId").val(data[0][0])
                            $("#spEditJobDetailProject").selectpicker('val',data[0][1]);
                            $("#spEditJobDetailTaskType").selectpicker('val',data[0][2]);
                            $("#spEditJobDetailTaskInfo").selectpicker('val',data[0][3]);
                            $("#inputEditJobDetailWorkHour").val(data[0][4])
                            $("#inputEditJobDetailDate").attr('value',data[0][5])
                            $("#inputEditJobDetailRemark").val(data[0][6])
                            selectedID = null
                        }
                    },
                    error:function () {
                        alert("网络连接异常")
                    }
                })
            }
            function fillStaffTable(data) {
                $("#tableBodyOfStaff").html("")
                for(var i=0;i<data.length;i++){
                    $("#tableBodyOfStaff").append(
                        "<tr><td><input type=\"checkbox\" class=\"cbStaff\"></td>" +
                        "<td class=\"idStaff\">" + data[i][0] + "</td>" +
                        "<td>" + data[i][1] + "</td>" +
                        "<td>" + data[i][2] + "</td>" +
                        "<td>" + data[i][3] + "</td></tr>"
                    )
                }
            }
            function fillProjectTable(data) {
                $("#tableBodyOfProject").html("")
                for(var i=0;i<data.length;i++){
                    $("#tableBodyOfProject").append(
                        "<tr><td><input type=\"checkbox\"class=\"cbProject\"></td>" +
                        "<td class=\"idProject\">" + data[i][0] + "</td>" +
                        "<td>" + data[i][1] + "</td>" +
                        "<td>" + data[i][2] + "</td>" +
                        "<td>" + data[i][3] + "</td>" +
                        "<td>" + data[i][4] +"</td></tr>"
                    )
                    $("#spAddJobDetailProject").append("<option>"+data[i][1]+"</option>")
                    $("#spAddJobDetailProject").selectpicker('refresh');
                    $("#spEditJobDetailProject").append("<option>"+data[i][1]+"</option>")
                    $("#spEditJobDetailProject").selectpicker('refresh');
                }
            }
            function fillJobDetailTable(data) {
                $("#tableBodyOfJobDetail").html("")
                for(var i=0;i<data.length;i++){
                    $("#tableBodyOfJobDetail").append(
                        "<tr>%{--<g:if test="${session.getAttribute('userName')=='admin'}">--}%<td><input type=\"checkbox\"class=\"cbJobDetail\"></td>%{--</g:if>--}%" +
                        "<td class=\"idJobDetail\">" + data[i][0] + "</td>" +
                        "<td>" + data[i][1] + "</td>" +
                        "<td>" + data[i][2] + "</td>" +
                        "<td>" + data[i][3] + "</td>" +
                        "<td>" + data[i][4] + "</td>" +
                        "<td>" + data[i][5] + "</td>" +
                        "<td>" + data[i][6] + "</td>" +
                        "<td>" + data[i][7]+"</td></tr>"
                    )
                }
            }
            function fillSpTaskType(data) {
                for(var i=1;i<data.length;i++){
                    $("#spAddJobDetailTaskType").append("<option>"+data[i].name+"</option>")
                    $("#spAddJobDetailTaskType").selectpicker('refresh');
                    $("#spEditJobDetailTaskType").append("<option>"+data[i].name+"</option>")
                    $("#spEditJobDetailTaskType").selectpicker('refresh');
                }
            }

            function fillSpTaskInfo(data) {
                for(var i=1;i<data.length;i++){
                    $("#spAddJobDetailTaskInfo").append("<option>"+data[i].name+"</option>")
                    $("#spAddJobDetailTaskInfo").selectpicker('refresh');
                    $("#spEditJobDetailTaskInfo").append("<option>"+data[i].name+"</option>")
                    $("#spEditJobDetailTaskInfo").selectpicker('refresh');
                }
            }

        </script>
        <style>
            input {
                margin-bottom: -1px;
                border-bottom-right-radius: 0;
                border-bottom-left-radius: 0;
            }
            .pos_fixed_left{
                position:fixed;
                height: 100%;
                border-right-style:solid;
                border-color: #DCDCDC;
            }
            .container{
                width: 100%;
            }
            .form-control {
                position: relative;
                height: auto;
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                padding: 10px;
                font-size: 16px;
            }
            .form-control:focus {
                z-index: 2;
            }
        </style>
	</head>
  <body >
  <!-- 操作员工模态框-->
  <div class="modal fade" id="modalAddStaff" tabindex="-1" role="dialog" aria-labelledby="addStaffModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <h4 class="modal-title" id="addStaffModalLabal">添加员工</h4>
              </div>
              <label for="inputEditStaffName" class="col-sm-2 control-label" style="margin-top: 10px ">员工名:</label>
              <div class="col-sm-10">
              <input type="text" class="form-control" id="inputAddStaffName" placeholder="员工名" required autofocus>
              </div>
              <label for="inputEditStaffName" class="col-sm-2 control-label" style="margin-top: 10px ">手机号:</label>
              <div class="col-sm-10 ">
              <input type="tel" class="form-control" id="inputAddStaffPhone" placeholder="手机号" required>
              </div>
              <label for="inputEditStaffName" class="col-sm-2 control-label" style="margin-top: 10px ">所属部门:</label>
              <div class="col-sm-10">
              <select class="selectpicker" id="spAddStaffGroup">
                  <option>软件系统部</option>
                  <option>行政</option>
                  <option>财务部门</option>
                  <option>硬件部</option>
              </select>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" id="btnSubmitAddStaff" data-dismiss="modal" class="btn btn-primary">提交</button>
              </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalEditStaff" tabindex="-1" role="dialog" aria-labelledby="editStaffModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <h4 class="modal-title" id="editStaffModalLabal">修改员工信息</h4>
              </div>
              <label for="inputEditStaffId" class="col-sm-2 control-label" style="margin-top: 10px ">员工ID:</label>
              <div class="col-sm-10">
              <input type="text" class="form-control" id="inputEditStaffId"  placeholder="员工ID" required disabled>
              </div>
              <label for="inputEditStaffName" class="col-sm-2 control-label" style="margin-top: 10px ">员工名:</label>
              <div class="col-sm-10">
              <input type="text" class="form-control" id="inputEditStaffName" placeholder="员工名" required autofocus>
              </div>
              <label for="inputEditStaffPhone" class="col-sm-2 control-label" style="margin-top: 10px ">手机号:</label>
              <div class="col-sm-10">
              <input type="tel" class="form-control" id="inputEditStaffPhone" placeholder="手机号" required>
              </div>
              <label for="spEditStaffGroup" class="col-sm-2 control-label" style="margin-top: 10px ">部门:</label>
              <div class="col-sm-10">
              <select class="selectpicker" id="spEditStaffGroup">
                  <option>软件系统部</option>
                  <option>行政</option>
                  <option>财务部门</option>
                  <option>硬件部</option>
              </select>
              </div>

              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" id="btnSubmitEditStaff" data-dismiss="modal" class="btn btn-primary">提交</button>
              </div>
          </div><!-- /.modal-content -->
      </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalDeleteStaff" tabindex="-1" role="dialog" aria-labelledby="deleteStaffModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="deleteStaffModalLabal">删除员工信息</h4>
          </div>
              <label for="inputDeleteStaffId" class="col-sm-2 control-label" style="margin-top: 10px">员工ID:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputDeleteStaffId"  placeholder="员工ID" required autofocus>
              </div>
              <label for="inputDeleteStaffName" class="col-sm-2 control-label" style="margin-top: 10px">员工名:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputDeleteStaffName" placeholder="员工名" required>
              </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitDeleteStaff" data-dismiss="modal" class="btn btn-danger">删除</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade bs-example-modal-sm"  id="modalDeleteMoreStaff" tabindex="-1" role="dialog" aria-labelledby="deleteMoreStaffModalLabal">
      <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="deleteMoreStaffModalLabal">确认删除</h4>
              </div>
              <div class="modal-body">
                  <p>确认要删除选中的员工吗？</p>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" class="btn btn-danger" id="btnSubmitDeleteMoreStaff" data-dismiss="modal">确认删除</button>
              </div>

          </div>
      </div>
  </div>
  <!-- 操作项目模态框-->
  <div class="modal fade" id="modalAddProject" tabindex="-1" role="dialog" aria-labelledby="addProjectModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="addProjectModalLabal">添加项目</h4>
          </div>
              <label class="col-sm-2 control-label"  for="inputAddProjectName" style="margin-top: 10px ">项目名:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputAddProjectName" placeholder="项目名" required autofocus>
              </div>
              <label class="col-sm-2 control-label"  for="inputAddProjectDate" style="margin-top: 10px ">创建日期:</label>
              <div class="col-sm-10">
                  <input type="date" class="form-control" id="inputAddProjectDate" placeholder="创建日期" required>
              </div>
              <label class="col-sm-2 control-label"  for="inputAddProjectState" style="margin-top: 10px ">状态:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputAddProjectState" placeholder="状态" required>
              </div>
              <label class="col-sm-2 control-label"  for="inputAddProjectDescription" style="margin-top: 10px ">描述:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputAddProjectDescription" placeholder="描述" required>
              </div>

          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitAddProject" data-dismiss="modal" class="btn btn-primary">提交</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalEditProject" tabindex="-1" role="dialog" aria-labelledby="editProjectModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="editProjectModalLabal">修改项目信息</h4>
          </div>

              <form class="form-horizontal" role="form">
                  <br>
                  <div class="form-group">
                      <label class="col-sm-2 control-label"  for="inputEditProjectId">项目ID:</label>
                      <div class="col-sm-10">
                          <input type="tel" class="form-control" id="inputEditProjectId"  placeholder="项目ID" required disabled>
                      </div>
                  </div>

                  <div class="form-group">
                      <label class="col-sm-2 control-label" for="inputEditProjectName">项目名:</label>
                      <div class="col-sm-10">
                          <input type="text" class="form-control" id="inputEditProjectName"  placeholder="项目名" required autofocus>
                      </div>
                  </div>


                  <div class="form-group">
                      <label class="col-sm-2 control-label" for="inputEditProjectDate">创建日期:</label>
                      <div class="col-sm-10">
                          <input type="date" class="form-control" id="inputEditProjectDate" placeholder="创建日期" required>
                      </div>
                  </div>

                  <div class="form-group">
                      <label class="col-sm-2 control-label" for="inputEditProjectState">状态:</label>
                      <div class="col-sm-10">
                          <input type="text" class="form-control" id="inputEditProjectState" placeholder="状态" required>
                      </div>
                  </div>


                  <div class="form-group">
                      <label class="col-sm-2 control-label" for="inputEditProjectDescription">描述:</label>
                      <div class="col-sm-10">
                          <input type="text" class="form-control" id="inputEditProjectDescription" placeholder="描述" required>
                      </div>
                  </div>

              </form>
          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitEditProject" data-dismiss="modal" class="btn btn-primary">提交</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalDeleteProject" tabindex="-1" role="dialog" aria-labelledby="deleteProjectModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="deleteProjectModalLabal">删除员工信息</h4>
          </div>
              <label for="inputDeleteProjectId" class="col-sm-2 control-label" style="margin-top: 10px ">员工ID:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputDeleteProjectId"  placeholder="项目ID" required autofocus>
              </div>
              <label for="inputDeleteProjectName" class="col-sm-2 control-label" style="margin-top: 10px ">员工ID:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputDeleteProjectName" placeholder="项目名" required>
              </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitDeleteProject" data-dismiss="modal" class="btn btn-danger">删除</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade bs-example-modal-sm"  id="modalDeleteMoreProject" tabindex="-1" role="dialog" aria-labelledby="deleteMoreProjectModalLabal">
      <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="deleteMoreProjectModalLabal">确认删除</h4>
              </div>
              <div class="modal-body">
                  <p>确认要删除选中的项目吗？</p>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" class="btn btn-danger" id="btnSubmitDeleteMoreProject" data-dismiss="modal">确认删除</button>
              </div>

          </div>
      </div>
  </div>
  <!-- 操作工时模态框-->
  <div class="modal fade" id="modalAddJobDetail" tabindex="-1" role="dialog" aria-labelledby="addJobDetailModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h3 class="modal-title" id="addJobDetailModalLabal">添加工时信息</h3>
          </div>

            <form class="form-horizontal" role="form">
              <br>
              <div class="form-group">
                <label class="col-sm-2 control-label">员工ID：</label>
                <div class="col-sm-10">
                  <input type="tel" class="form-control" value="<%=session.getAttribute("userId")%>" id="inputAddJobDetailStaffId" placeholder="员工ID" required disabled>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label">所属项目：</label>
                <div class="col-sm-10">
                  <select class="selectpicker" id="spAddJobDetailProject">
                    <option>---请选择相关项目---</option>
                  </select>
                </div>
              </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">任务类型：</label>
                    <div class="col-sm-10">
                        <select class="selectpicker" id="spAddJobDetailTaskType">
                            <option>---请选择相关任务类型---</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">任务状态：</label>
                    <div class="col-sm-10">
                        <select class="selectpicker" id="spAddJobDetailTaskInfo">
                            <option>---请选择相关任务状态---</option>
                        </select>
                    </div>
                </div>

              <div class="form-group">
                <label class="col-sm-2 control-label">工时：</label>
                <div class="col-sm-10">
                  <input type="number" class="form-control" id="inputAddJobDetailWorkHour" placeholder="工时" required>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label">日期：</label>
                <div class="col-sm-10">
                  <input type="date" class="form-control" id="inputAddJobDetailDate" placeholder="日期" required>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label">描述：</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputAddJobDetailRemark" placeholder="描述" required>
                </div>
              </div>

            </form>

          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitAddJobDetail" data-dismiss="modal" class="btn btn-primary">提交</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalEditJobDetail" tabindex="-1" role="dialog" aria-labelledby="editJobDetailModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h3 class="modal-title" id="editJobDetailModalLabal">修改工时信息</h3>
          </div>
            <form class="form-horizontal" role="form">
              <br>
            <div class="form-group">
              <label class="col-sm-2 control-label"  for="inputEditJobDetailId">工时记录ID:</label>
              <div class="col-sm-10">
                <input type="tel" class="form-control" id="inputEditJobDetailId"  placeholder="工时记录ID" required disabled>
              </div>
            </div>

              <div class="form-group">
                <label class="col-sm-2 control-label" for="inputEditJobDetailStaffId">员工ID:</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputEditJobDetailStaffId"  placeholder="员工ID" required autofocus disabled>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label" for="spEditJobDetailProject">所属项目:</label>
                <div class="col-sm-10">
                  <select class="selectpicker" id="spEditJobDetailProject">
                    <option>---请选择相关项目---</option>
                  </select>
                </div>
              </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label" for="spEditJobDetailTaskType">任务类型：</label>
                    <div class="col-sm-10">
                        <select class="selectpicker" id="spEditJobDetailTaskType">
                            <option>---请选择相关任务类型---</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label" for="spEditJobDetailTaskInfo" >任务状态：</label>
                    <div class="col-sm-10">
                        <select class="selectpicker" id="spEditJobDetailTaskInfo">
                            <option>---请选择相关任务状态---</option>
                        </select>
                    </div>
                </div>

              <div class="form-group">
                <label class="col-sm-2 control-label" for="inputEditJobDetailWorkHour">工时:</label>
                <div class="col-sm-10">
                  <input type="tel" class="form-control" id="inputEditJobDetailWorkHour" placeholder="工时" required>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label" for="inputEditJobDetailDate">日期:</label>
                <div class="col-sm-10">
                  <input type="date" class="form-control" id="inputEditJobDetailDate" placeholder="日期" required>
                </div>
              </div>

              <div class="form-group">
                <label class="col-sm-2 control-label" for="inputEditJobDetailRemark">描述:</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="inputEditJobDetailRemark" placeholder="描述" required>
                </div>
              </div>

            </form>

          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitEditJobDetail" data-dismiss="modal" class="btn btn-primary">提交</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade" id="modalDeleteJobDetail" tabindex="-1" role="dialog" aria-labelledby="deleteJobDetailModalLabal" aria-hidden="true">
      <div class="modal-dialog">
          <div class="modal-content">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="deleteJobDetailModalLabal">删除员工信息</h4>
          </div>

              <label for="inputDeleteJobDetailId" class="col-sm-3 control-label" style="margin-top: 10px ">工时记录ID:</label>
              <div class="col-sm-9">
                  <input type="tel" class="form-control" id="inputDeleteJobDetailId"  placeholder="工时记录ID" required autofocus>
              </div>

              <label for="inputDeleteJobDetailStaffName" class="col-sm-3 control-label" style="margin-top: 10px">相关员工名:</label>
              <div class="col-sm-9">
                  <input type="text" class="form-control" id="inputDeleteJobDetailStaffName" placeholder="相关员工名" required>
              </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
              <button type="button" id="btnSubmitDeleteJobDetail" data-dismiss="modal" class="btn btn-danger">删除</button>
          </div>
      </div><!-- /.modal-content -->
  </div><!-- /.modal -->
  </div>
  <div class="modal fade bs-example-modal-sm"  id="modalDeleteMoreJobDetail" tabindex="-1" role="dialog" aria-labelledby="deleteMoreJobDetailModalLabal">
      <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="deleteMoreJobDetailModalLabal">确认删除</h4>
              </div>
              <div class="modal-body">
                  <p>确认要删除选中的工时记录吗？</p>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" class="btn btn-danger" id="btnSubmitDeleteMoreJobDetail" data-dismiss="modal">确认删除</button>
              </div>

          </div>
      </div>
  </div>

  <div class="modal fade bs-example-modal-sm" id="modalChangePassword" tabindex="-1" role="dialog" aria-labelledby="changePasswordModalLabal">
      <div class="modal-dialog modal-sm" role="document">
          <div class="modal-content">
              <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="changePasswordModalLabal">修改密码</h4>
              </div>
              <form class="form-horizontal" role="form">
                  <br>
                  <div class="form-group">
                      <label class="col-sm-3 control-label"  for="inputNewPassword">新密码:</label>
                      <div class="col-sm-9">
                          <input type="password" class="form-control" id="inputNewPassword"  placeholder="新密码" required autofocus>
                      </div>
                  </div>

                  <div class="form-group">
                      <label class="col-sm-3 control-label" for="inputRepeatNewPassword">重复新密码:</label>
                      <div class="col-sm-9">
                          <input type="password" class="form-control" id="inputRepeatNewPassword"  placeholder="重复新密码" required >
                      </div>
                  </div>

              </form>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                  <button type="button" class="btn btn-success" id="btnSubmitNewPassword" data-dismiss="modal">提交</button>
              </div>

          </div>
      </div>
  </div>

    <div class="container">
      <div class="row clearfix">
          <div class="col-md-12 column">
              <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
                  <div class="navbar-header">
                      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"> <span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button> <a class="navbar-brand" href="#">融智捷工时管理系统</a>
                  </div>

                  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                      <ul class="nav navbar-nav navbar-right">
                          <li>
                              <a>你好，<%=session.getAttribute("userName")%>。</a>
                          </li>
                          <li class="dropdown" style="margin-right: 15px">
                              <a href="#" class="dropdown-toggle" data-toggle="dropdown">更多<strong class="caret"></strong></a>
                              <ul class="dropdown-menu">
                                  <li>
                                      <a href="javascript:showChangPasswordModal()">修改密码</a>
                                  </li>
                                  <li>
                                      <a href="#">设置</a>
                                  </li>
                                  <li class="divider">
                                  </li>
                                  <li>
                                      <a href="javascript:logout()">退出登录</a>
                                  </li>
                              </ul>
                          </li>
                      </ul>
                  </div>
              </nav>
          </div>
      </div>
  </div>
	<div class="container" style="margin: 50px 0px 0px 0px;">
        <div class="row clearfix">
			<div class="col-md-2 column  pos_fixed_left">
                <ul class="nav nav-pills nav-stacked" style="margin-top: 20px;text-align: center">
                    <g:if test="${session.getAttribute('userName')=='admin'}">
                        <li>
                            <a href="#staff" data-toggle="tab">员工</a>
                        </li>
                        <li>
                            <a href="#project" data-toggle="tab">项目</a>
                        </li>
                    </g:if>
                    <li>
                        <a href="#jobDetail" data-toggle="tab">工时</a>
                    </li>
                </ul>
            </div>
			<div class="col-md-10 column col-md-offset-2 ">
				<div id="tabContent" class="tab-content">
					<div class="tab-pane fade" id="staff">
                        <div align="left" >
                            <button id="btnAddStaff" class="btn btn-primary" style="margin-top: 15px;width: 60px">添加</button>
                            <button id="btnDeleteStaff" class="btn btn-danger" style="margin-top: 15px;width: 60px">删除</button>
                        </div>
                        <table id="staffTable" class="table table-hover">
                            <caption>员工表</caption>
                            <thead>
                            <tr>
                                <th><button type="button" class="btn btn-link" id="btnSelectAllStaff">全选</button></th>
                                <th>员工ID</th>
                                <th>员工名</th>
                                <th>手机号码</th>
                                <th>所属部门</th>
                            </tr>
                            </thead>
                            <tbody id="tableBodyOfStaff">
                            </tbody>
                        </table>
                    </div>
					<div class="tab-pane fade" id="project">
                        <div align="left" >
                            <button id="btnAddProject" class="btn btn-primary" style="margin-top: 15px;width: 60px">添加</button>
                            <button id="btnDeleteProject" class="btn btn-danger" style="margin-top: 15px;width: 60px">删除</button>
                        </div>
                        <table id="projectTable" class="table table-hover">
                            <caption>项目表</caption>
                            <thead>
                            <tr>
                                <th><button type="button" class="btn btn-link" id="btnSelectAllProject">全选</button></th>
                                <th>项目ID</th>
                                <th>项目名</th>
                                <th>创建日期</th>
                                <th>状态</th>
                                <th>描述</th>
                            </tr>
                            </thead>
                            <tbody id="tableBodyOfProject">
                            </tbody>
                        </table>
                    </div>
					<div class="tab-pane fade" id="jobDetail">
                        <div align="left" >
                            <button id="btnAddJobDetail" class="btn btn-primary" style="margin-top: 15px;width: 60px">添加</button>
                            <button id="btnDeleteJobDetail" class="btn btn-danger" style="margin-top: 15px;width: 60px">删除</button>
                        </div>
                        <table id="jobDetailTable" class="table table-hover">
                            <caption>工时明细表</caption>
                            <thead>
                            <tr>
                                <g:if test="${session.getAttribute('userName')=='admin'}">
                                <th style="width:9.6%"><button type="button" class="btn btn-link" id="btnSelectAllJobDetail">全选</button></th>
                                </g:if>
                                <g:else>
                                    <th style="width:9.6%"></th>
                                </g:else>
                                <th style="width:8%">记录ID</th>
                                <th style="width:8%">员工名</th>
                                <th style="width:8%">相关项目</th>
                                <th style="width:8%">任务类型</th>
                                <th style="width:8%">任务状态</th>
                                <th style="width:5%">工时</th>
                                <th style="width:12.5%">日期</th>
                                <th style="width:42.5%">详细信息</th>
                            </tr>
                            </thead>
                            <tbody id="tableBodyOfJobDetail">
                            </tbody>
                        </table>
                    </div>
				</div>
			</div>
		</div>
    </div>
  </body>

</html>
