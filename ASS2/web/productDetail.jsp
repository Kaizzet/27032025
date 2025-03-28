<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Product.ProductDTO" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>HELIOS - Mô tả Sản phẩm</title>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/motasanpham.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" 
          href="https://fonts.googleapis.com/css2?family=UnifrakturCook:wght@700&display=swap">
</head>
<body>
    <!-- HEADER -->
    <header class="header">
        <div class="logo">𝓗𝓔𝓛𝓘𝓸𝓢</div>
        <nav class="main-nav">
            <ul>
                <li><a href="MainController?action=loadProducts&page=1">MENU</a></li>
            </ul>
        </nav>
    </header>
    <%
        // Lấy đối tượng sản phẩm từ request với attribute "pro"
        ProductDTO pro = (ProductDTO) request.getAttribute("pro");
        if (pro == null) {
    %>
        <p>Sản phẩm không tồn tại hoặc có lỗi.</p>
    <%
        } else {
    %>
    <!-- Hiển thị chi tiết sản phẩm -->
    <section class="product-hero">
        <div class="product-image">
            <img src="<%= pro.getImageUrl() %>" alt="<%= pro.getName() %>">
        </div>
        <div class="product-info">
            <h1><%= pro.getName() %></h1>
            <p class="product-price"><%= String.format("%,.0f", pro.getPrice()) %> VND</p>
            <p class="product-rating">★★★★★ 72 đánh giá</p>
            <p class="product-variant"><strong>Kích cỡ:</strong> 48-18</p>
            <p class="product-variant"><strong>Chất liệu:</strong> Bạc 925, hợp kim Titanium</p>
            <div class="btn-group">
                <button class="btn-buy">Thêm vào giỏ hàng</button>
                <button class="btn-buy">Mua ngay</button>
            </div>
            <p class="product-desc">
                <%= pro.getDescription() %>
            </p>
        </div>
    </section>
    <!-- Hiển thị hình chi tiết sản phẩm -->
    <section class="product-detail-images">
        <img src="images/detail1.jpg" alt="Chi tiết sản phẩm 1">
        <img src="images/detail2.jpg" alt="Chi tiết sản phẩm 2">
        <img src="images/detail3.jpg" alt="Chi tiết sản phẩm 3">
    </section>
    <!-- Thông tin thêm -->
    <section class="crafting-info">
        <h2>8 NĂM HÀNH TRÌNH CHẾ TÁC THỦ CÔNG BẠC</h2>
        <p>
            Với sứ mệnh mang đến sự tinh xảo bền bỉ, Helios không chỉ chế tác thủ công bạc hoàn thiện nhất,
            mà còn truyền cảm hứng nghệ thuật vào từng chi tiết. Mỗi sản phẩm là một câu chuyện.
        </p>
        <img src="images/detail3.jpg" alt="Nghệ nhân đang chế tác">
    </section>
    <!-- Gợi ý sản phẩm -->
    <section class="recommend-section">
        <h2>You may also like</h2>
        <div class="recommend-container">
            <div class="recommend-card">
                <img src="images/recommend1.jpg" alt="Admah Helios Silver">
                <h3>Admah Helios Silver</h3>
                <p class="product-price">1.250.000 VND</p>
                <button class="btn-quickview">Xem nhanh</button>
            </div>
        </div>
    </section>
    <%
        }
    %>
    <footer class="footer">
        <p>© 2025 HELIOS - All rights reserved.</p>
    </footer>
</body>
</html>
