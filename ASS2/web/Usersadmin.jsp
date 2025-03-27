<%@ page import="java.util.List" %>
<%@ page import="Users.UserDAO" %>
<%@ page import="Users.UserDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
        <head>
        <meta charset="UTF-8">
        <title>Users Admin</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <head>
        <meta charset="UTF-8">
        <title>Users Admin</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-left">
                <h2 class="logo">HELIOS</h2>
                <ul class="nav-menu">
                    <li><a href="Homepageadmin.jsp">Home</a></li>
                    <li><a href="Ordersadmin.jsp">Orders</a></li>
                    <li><a href="Productsadmin.jsp">Products</a></li>
                    <li><a href="Usersadmin.jsp" class="active">Users</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <img src="../images/avatar.png" alt="Avatar" class="avatar">
            </div>
        </nav>

 <div class="sub-header">
            <h1>Users</h1>
            <form method="GET" action="Usersadmin.jsp">
                <input type="text" name="keyword" placeholder="Nhập từ khóa..." 
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : ""%>">
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>
       

              <div class="content">
            <section class="page-section">
                <div class="table-container">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>USER ID</th>
                                <th>NAME</th>
                                <th>EMAIL</th>
                                <th>PHONE</th>
                                <th>ADDRESS</th>
                                <th>CREATED_AT</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int pageUser = 1;
                                int usersPerPage = 5;
                                if (request.getParameter("page") != null) {
                                    pageUser = Integer.parseInt(request.getParameter("page"));
                                }


                               UserDAO userDAO = new UserDAO();
                                String keyword = request.getParameter("keyword");

                                 List<UserDTO> userList;
                                int totalUsers;
                                int totalPages;
                                if (keyword != null && !keyword.trim().isEmpty()) {
                                    userList = userDAO.searchUsers(keyword);
                                    totalUsers = userList.size();
                                } else {
                                    userList = userDAO.getUsersByPage(pageUser, usersPerPage);
                                    totalUsers = userDAO.getTotalUsers();
                                }
                                    totalPages = (int) Math.ceil((double) totalUsers / usersPerPage);

                                if (userList.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" style="text-align:center;">Không tìm thấy người dùng</td>
                            </tr>
                            <% } else {
                            for (UserDTO user : userList) {%>
                            <tr id="userRow-<%= user.getUserId()%>">
                                <td><%= user.getUserId()%></td>
                                <td><%= user.getName()%></td>
                                <td><%= user.getEmail()%></td>
                                <td><%= user.getPhone()%></td>
                                <td><%= user.getAddress()%></td>
                                <td><%= user.getCreatedAt()%></td>
                                <td>
                                    <span class="material-icons delete-icon" onclick="confirmDelete(<%= user.getUserId()%>)">delete</span>
                                </td>
                            </tr>
                            <% }
                                } %>
                        </tbody>
                    </table>
                </div>

                  <!-- Phân trang (chỉ hiển thị khi không tìm kiếm) -->
                <% if (keyword == null || keyword.trim().isEmpty()) { %>
                <div class="pagination">
                    <% if (pageUser > 1) {%>
                    <a href="Usersadmin.jsp?page=<%= pageUser - 1%>">&laquo; Previous</a>
                    <% }%>
                    <span>Page <%= pageUser%> of <%= totalPages%></span>
                    <% if (pageUser < totalPages) {%>
                    <a href="Usersadmin.jsp?page=<%= pageUser + 1%>">Next &raquo;</a>
                    <% } %>
                </div>
                <% }%>

            </section>
        </div>

        <script>
            function confirmDelete(userId) {
                if (confirm("Bạn có chắc chắn muốn xóa người dùng này không?")) {
                    fetch("MainController?action=deleteUser&userId=" + userId, {
                        method: "GET"
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.status === "success") {
                                    document.getElementById("userRow-" + userId).remove();
                                } else {
                                    alert("Xóa thất bại: " + data.message);
                                }
                            })
                            .catch(error => console.error("Lỗi khi gửi yêu cầu xóa:", error));
                }
            }
        </script>

    </body>
</html>