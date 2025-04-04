<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo tài khoản</title>
        <link rel="stylesheet" href="css/styles.css">

    </head>
    <body class="register-page">
        <div class="success-fail"></div>
       <h4 style="color: red">${requestScope.exitmail}</h4>
       <h4 style="color: greenyellow">${requestScope.success}</h4>
       <h4 style="color: red">${requestScope.fail}</h4>
       </div>       
        <div class="register-container">
            <h2>Đặt lại mật khẩu</h2>
            <%-- Hiển thị thông báo thành công hoặc thất bại --%>


            <form action="MainController" method="post">
                <input type="hidden" name="action" value="register">          

                <input type="email" name="email" placeholder="Email" required>

                <button class="create-account" type="submit">Gửi</button>
            </form>
            <a href="login.jsp" class="back-login">Đăng nhập</a>
            <a href="MainController?action=loadProducts&page=1 " class="back-link">Quay lại cửa hàng</a>
        </div>
    </body>
</html>
