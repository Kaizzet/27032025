<%@ page import="Users.UserDAO"%>
<%@ page import="Users.UserDTO"%>
<%@ page import="java.util.Map, java.util.HashMap, Product.ProductDAO, Product.ProductDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán - Helios</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/thanhtoan.css">
    <style>
        .disabled-btn {
            background-color: gray !important;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<%
    // Lấy giỏ hàng và thông tin user từ session
    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) {
        cart = new HashMap<>();
    }
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

    // Tính tổng tiền
    ProductDAO productDAO = new ProductDAO();
    double totalPrice = 0;
    for(Map.Entry<Integer, Integer> entry : cart.entrySet()){
        int productId = entry.getKey();
        int quantity = entry.getValue();
        ProductDTO product = productDAO.getProductById(productId);
        if(product != null){
            totalPrice += product.getPrice() * quantity;
        }
    }
    
    // Lấy thông báo từ MainController
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<div class="checkout-container">
    <div class="checkout-left">
        <section class="section-contact">
            <h2>Liên hệ</h2>
            <div class="input-group">
                <label for="contactInput">Email</label>
                <input type="text" id="contactInput" placeholder="Email"
                       value="<%= (loggedInUser != null) ? loggedInUser.getEmail() : "" %>">
            </div>
            <div class="checkbox-group">
                <input type="checkbox" id="subscribe">
                <label for="subscribe">Giữ tôi cập nhật các ưu đãi qua email</label>
            </div>
        </section>
        <section class="section-shipping">
            <h2>Giao hàng</h2>
            <div class="input-group">
                <label for="country">Quốc gia/Khu vực</label>
                <select id="country">
                    <option value="vn">Việt Nam</option>
                    <option value="us">Hoa Kỳ</option>
                    <option value="jp">Nhật Bản</option>
                </select>
            </div>
            <div class="input-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" placeholder="Số nhà, tên đường...">
            </div>
            <div class="input-group">
                <label for="phone">Điện thoại</label>
                <input type="text" id="phone" placeholder="Số điện thoại">
            </div>
            <section class="section-delivery">
                <h3>Phương thức vận chuyển</h3>
                <!-- Form gửi dữ liệu lên MainController (action = completeOrder) -->
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="completeOrder" />
                    <!-- Input ẩn chứa dữ liệu giao hàng -->
                    <input type="hidden" name="address" id="hiddenAddress" />
                    <input type="hidden" name="phone" id="hiddenPhone" />
                    <input type="hidden" name="email" id="hiddenEmail" />
                    <button type="submit" class="checkout-btn" id="payButton">Thanh toán ngay</button>
                </form>
            </section>
        </section>
    </div>
    <div class="checkout-right">
        <div class="order-summary">
            <% for(Map.Entry<Integer, Integer> entry : cart.entrySet()){
                int productId = entry.getKey();
                int quantity = entry.getValue();
                ProductDTO product = productDAO.getProductById(productId);
                if(product != null){
            %>
            <div class="summary-item">
                <img class="cart-item" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                <div class="item-info">
                    <p class="item-name"><%= product.getName() %> <%= (quantity > 1) ? " x" + quantity : "" %></p>
                    <p class="item-price"><%= String.format("%,.0f", product.getPrice()) %> đ</p>
                </div>
            </div>
            <hr>
            <% } } %>
            <div class="summary-fee">
                <div class="fee-row">
                    <span>Tổng phụ</span>
                    <span><%= String.format("%,.0f", totalPrice) %> đ</span>
                </div>
                <div class="fee-row">
                    <span>Vận chuyển</span>
                    <span>MIỄN PHÍ</span>
                </div>
            </div>
            <hr>
            <div class="summary-total">
                <div class="fee-row">
                    <span class="total-label">Tổng</span>
                    <span class="total-amount"><%= String.format("%,.0f", totalPrice) %> đ</span>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <p>© 2025 HELIOS - All rights reserved.</p>
        </div>
    </div>
</footer>

<% if(successMessage != null){ %>
    <script>
        alert("<%= successMessage %>");
    </script>
<% } %>
<% if(errorMessage != null){ %>
    <script>
        alert("<%= errorMessage %>");
    </script>
<% } %>

<script>
document.addEventListener("DOMContentLoaded", function(){
    const payButton = document.getElementById("payButton");
    
    // Nếu đã có successMessage, đổi nút sang "Đã thanh toán", màu xám và disable
    <% if(successMessage != null){ %>
        payButton.textContent = "Đã thanh toán";
        payButton.style.backgroundColor = "gray";
        payButton.disabled = true;
        payButton.classList.add("disabled-btn");
    <% } %>
    
    payButton.addEventListener("click", function(){
        const addressVal = document.getElementById("address").value;
        const phoneVal = document.getElementById("phone").value;
        const emailVal = document.getElementById("contactInput") ? document.getElementById("contactInput").value : "";
        document.getElementById("hiddenAddress").value = addressVal;
        document.getElementById("hiddenPhone").value = phoneVal;
        document.getElementById("hiddenEmail").value = emailVal;
    });
});
</script>
</body>
</html>
