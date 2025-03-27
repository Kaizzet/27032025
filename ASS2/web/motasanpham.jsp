<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>HELIOS - Mô tả Sản phẩm</title>
    <!-- Liên kết đến file CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/motasanpham.css">
    <!-- Font (giống Helios) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" 
          href="https://fonts.googleapis.com/css2?family=UnifrakturCook:wght@700&display=swap">
</head>
<body>
    <!-- HEADER -->
    <header class="header">
        <div class="logo">𝓗𝓔𝓛𝓘𝓞𝓢</div>
        <nav>
            <ul>
                <li class="dropdown">
                    <a href="#">MENU</a>
                    <ul class="dropdown-content">
                        <% if (categories != null && !categories.isEmpty()) {
                            for (CategoryDTO category : categories) { %>
                        <li>
                            <a href="MainController?action=loadCategory&category=<%= category.getCategoryId()%>&page=1">
                                <%= category.getCategoryName()%>
                            </a>
                        </li>
                        <%  }
                        } else { %>
                        <li><a href="#">Không có danh mục</a></li>
                        <% }%>
                    </ul>
                </li>
            </ul>
        </nav> 
    </header>

    <!-- PHẦN GIỚI THIỆU SẢN PHẨM CHÍNH -->
    <section class="product-hero">
        <div class="product-image">
            <!-- Ảnh chính của sản phẩm -->
            <img src="images/main-product.jpg" alt="Kính Rhodes - Charm Lotusgot">
        </div>
        <div class="product-info">
            <h1>Kính Rhodes - Charm Lotusgot</h1>
            <p class="product-price">2.200.000 VND</p>
            <p class="product-rating">★★★★★ 72 đánh giá</p>

            <p class="product-variant"><strong>Kích cỡ:</strong> 48-18</p>
            <p class="product-variant"><strong>Chất liệu:</strong> Bạc 925, hợp kim Titanium</p>

            <div class="btn-group">
                <button class="btn-buy">Thêm vào giỏ hàng</button>
                <button class="btn-buy">Mua ngay</button>
            </div>

            <p class="product-desc">
                Đối với các tách ly ngoại cỡ, sừng và kim loại nặng,<br>
                chúng tôi đã nghiên cứu, chế tác đính đá bền bỉ<br>
                cho sản phẩm. Đó là lý do vì sao Helios Jewel<br>
                luôn mang đến chất lượng tuyệt đối cho khách hàng.
            </p>
        </div>
    </section>

    <!-- PHẦN ẢNH CHI TIẾT SẢN PHẨM (4 ảnh chung 1 trang) -->
    <section class="product-detail-images">
        <img src="images/detail1.jpg" alt="Chi tiết sản phẩm 1">
        <img src="images/detail2.jpg" alt="Chi tiết sản phẩm 2">
        <img src="images/detail3.jpg" alt="Chi tiết sản phẩm 3">
        <!-- Ảnh thứ 4, bạn có thể thêm nếu muốn -->
        <!-- <img src=\"images/detail4.jpg\" alt=\"Chi tiết sản phẩm 4\"> -->
    </section>

    <!-- PHẦN THÔNG TIN THÊM / HÀNH TRÌNH THỦ CÔNG -->
    <section class="crafting-info">
        <h2>8 NĂM HÀNH TRÌNH CHẾ TÁC THỦ CÔNG BẠC</h2>
        <p>
            Với sứ mệnh mang đến sự tinh xảo bền bỉ, Helios không chỉ chế tác thủ công bạc hoàn thiện nhất,
            mà còn truyền cảm hứng nghệ thuật vào từng chi tiết. Mỗi sản phẩm là một câu chuyện.
        </p>
        <img src="images/detail3.jpg" alt="Nghệ nhân đang chế tác">
    </section>

    <!-- PHẦN GỢI Ý SẢN PHẨM (4 ảnh) -->
    <section class="recommend-section">
        <h2>You may also like</h2>
        <div class="recommend-container">
            <!-- Sản phẩm gợi ý 1 -->
            <div class="recommend-card">
                <img src="images/recommend1.jpg" alt="Admah Helios Silver">
                <h3>Admah Helios Silver</h3>
                <p class="product-price">1.250.000 VND</p>
                <button class="btn-quickview">Xem nhanh</button>
            </div>
            <!-- Sản phẩm gợi ý 2 -->
            <div class="recommend-card">
                <img src="images/recommend2.jpg" alt="Tom Tiêm Lưỡi Hổ">
                <h3>Tom Tiêm Lưỡi Hổ</h3>
                <p class="product-price">1.550.000 VND</p>
                <button class="btn-quickview">Xem nhanh</button>
            </div>
            <!-- Sản phẩm gợi ý 3 -->
            <div class="recommend-card">
                <img src="images/recommend3.jpg" alt="Pabe Helios Silver">
                <h3>Pabe Helios Silver</h3>
                <p class="product-price">1.350.000 VND</p>
                <button class="btn-quickview">Xem nhanh</button>
            </div>
            <!-- Sản phẩm gợi ý 4 -->
            <div class="recommend-card">
                <img src="images/recommend4.jpg" alt="Thiết kế Rồng Bạc">
                <h3>Thiết kế Rồng Bạc</h3>
                <p class="product-price">3.450.000 VND</p>
                <button class="btn-quickview">Xem nhanh</button>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <p>© 2025 HELIOS - All rights reserved.</p>
    </footer>
</body>
</html>
