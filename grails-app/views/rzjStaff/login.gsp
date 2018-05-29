<%--
  Created by IntelliJ IDEA.
  User: SAM
  Date: 2018/3/22
  Time: 10:03
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no">

    <asset:javascript src ="jquery-2.2.0.min.js"/>
    <asset:stylesheet src ="bootstrap.css"/>
    <asset:javascript src ="bootstrap.js"/>
    <asset:stylesheet src ="bootstrap-select.min.css"/>
    <asset:javascript src ="bootstrap-select.min.js"/>
    <asset:javascript src ="defaults-zh_CN.min.js"/>

    <title>
        登录
    </title>

    <style>
        body {
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #eee;
        }

        #signin {
            max-width: 330px;
            padding: 15px;
            margin: 0 auto;
        }
        #signin .form-signin-heading
        #signin .btn btn-link {
            margin-bottom: 10px;
        }
        #signin .btn btn-link {
            font-weight: normal;
        }
        #signin .form-control {
            position: relative;
            height: auto;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            padding: 10px;
            font-size: 16px;
        }
        #signin .form-control:focus {
            z-index: 2;
        }
        #signin input[type="text"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }
        #inputPassword {
            margin-bottom: 10px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
        #inputPasswordForSignUp {
            margin-bottom: -1px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
    </style>

    <script>
        <% session.setAttribute("userId","") %>
        <% session.setAttribute("userName","") %>
        function hideAlert() {
            $("#signInFailedAlert").hide()
            $("#signInErrorAlert").hide()
            $("#signUpFailedAlert").hide()
            $("#signUpErrorAlert").hide()
            $("#signUpErrorAlert2").hide()
            $("#signUpSuccessAlert").hide()
        }
        function pullGroupName() {
            $.ajax({
                url:'../RzjGroup/pullGroupInfo',
                cache:false,
                type:'post',
                success:function (data) {
                    for(var i = 0 ; i < data.length ;i++){
                        $("#spGroupName").append("<option>"+data[i].groupName+"</option>")
                        $("#spGroupName").selectpicker('refresh');
                        $('#spGroupName').selectpicker('val', '软件系统部');
                    }
                },
                error:function () {
                    alert("获取部门列表失败，如果网络正常，可能是因为数据库中没有部门表")
                }
            })
        }
        $(function () {
            hideAlert()

            $("#btnSignIn").click(function () {
                var dataReady = {
                    'username':$("#inputUserName").val(),
                    'password':$("#inputPassword").val()
                }
                $.ajax({
                    url:'signIn',
                    cache:false,
                    type:'post',
                    data:dataReady,
                    success:function (info) {
                        if(info == '0'){
                            hideAlert()
                            $("#signInFailedAlert").show()
                        }
                        else if(info == '1'){
                            hideAlert()
                            window.location.href='../'
                        }
                    },
                    error:function () {
                        hideAlert()
                        $("#signInErrorAlert").show()
                    }
                })
            })
            $("#btnSignUp").click(function () {
                $(this).attr("disabled",true);
                var dataReady = {
                    'username':$("#inputUserNameForSignUp").val(),
                    'password':$("#inputPasswordForSignUp").val(),
                    'personname':$("#inputPersonNameForSignUp").val(),
                    'phone':$("#inputPhoneForSignUp").val(),
                    'group':$(".selectpicker").find("option:selected").text()
                }
                $.ajax({
                    url:'signUp',
                    cache:false,
                    type:'post',
                    data:dataReady,
                    success:function (info) {
                        if(info=="1"){
                            hideAlert()
                            $("#signUpSuccessAlert").show()
                            $("#btnSignUp").attr("disabled",false);
                        }
                        else if(info=='0'){
                            hideAlert()
                            $("#signUpFailedAlert").show()
                            $("#btnSignUp").attr("disabled",false);
                        }
                        else if (info =="error"){
                            hideAlert()
                            $("#signUpFailedAlert2").show()
                            $("#btnSignUp").attr("disabled",false);
                        }
                    },
                    error:function () {
                        hideAlert()
                        $("#signUpErrorAlert").show()
                        $("#btnSignUp").attr("disabled",false);
                    }
                })
            })
        })
    </script>
</head>

<body>
<div class="container">

    <div id="signin">
        <h2  class="form-signin-heading">工时管理系统</h2>
        <label for="inputUserName" class="sr-only">用户名</label>
        <input type="text" id="inputUserName" class="form-control" placeholder="用户名" required autofocus>
        <label for="inputPassword" class="sr-only">密码</label>
        <input type="password" id="inputPassword" class="form-control" placeholder="密码" required>
        <button class="btn btn-lg btn-primary btn-block" id="btnSignIn" type="button">登录</button>
        <button type="button"   id="btnGotoSignUp" class="btn btn-link" data-toggle="modal" data-target=".bs-example-modal-sm" onclick="pullGroupName()">没有账号？点此注册</button>
        <div class="alert alert-warning" id="signInFailedAlert" role="alert">登录失败！用户名或密码有误</div>
        <div class="alert alert-warning" id="signInErrorAlert" role="alert">登录失败！未能成功发送数据</div>
        <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">注册</h4>
                        <div class="alert alert-success" id="signUpSuccessAlert" role="alert" style="margin-top: 15px;margin-bottom: -5px">注册成功！</div>
                        <div class="alert alert-warning" id="signUpFailedAlert" role="alert" style="margin-top: 15px;margin-bottom: -5px">注册失败！输入的信息格式有误或用户名重复</div>
                        <div class="alert alert-warning" id="signUpErrorAlert" role="alert" style="margin-top: 15px;margin-bottom: -5px">注册失败！未能成功发送数据</div>
                        <div class="alert alert-warning" id="signUpErrorAlert2" role="alert" style="margin-top: 15px;margin-bottom: -5px">注册失败！有内容未填写</div>

                    </div>
                    <div class="modal-body">
                        <input type="text" id="inputUserNameForSignUp" class="form-control" placeholder="用户名" required autofocus>
                        <input type="password" id="inputPasswordForSignUp" class="form-control" placeholder="密码" required>
                        <input type="text" id="inputPersonNameForSignUp" class="form-control" placeholder="姓名" required>
                        <input type="tel" id="inputPhoneForSignUp" class="form-control" placeholder="手机号" required>
                        <select class="selectpicker" id="spGroupName">
                        </select>
                        <button class="btn btn-lg btn-primary btn-block" id="btnSignUp" type="button">注册</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>

                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>