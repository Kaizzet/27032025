package Main;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Product.ProductDAO;
import Product.ProductDTO;
import Orders.OrderDAO;
import Orders.OrderDTO;
import Users.UserDAO;
import Users.UserDTO;
import Category.CategoryDAO;
import Category.CategoryDTO;

@WebServlet(name = "MainController", urlPatterns = {"/MainController", "/"})
public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            response.sendRedirect("MainController?action=loadProducts&page=1");
            return;
        }
        
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO = new UserDAO();
        HttpSession session = request.getSession();
        
        try {
            switch (action) {
                case "login": {
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    UserDTO user = new UserDAO().checkLogin(email, password);
                    if (user != null) {
                        session.setAttribute("loggedInUser", user);
                        if ("Quản trị viên".equalsIgnoreCase(user.getRole())) {
                            response.sendRedirect("Homepageadmin.jsp");
                        } else {
                            response.sendRedirect("MainController?action=loadProducts&page=1");
                        }
                    } else {
                        request.setAttribute("ERROR", "Sai email hoặc mật khẩu!");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                    break;
                }
                case "logout": {
                    session.invalidate();
                    response.sendRedirect("MainController?action=loadProducts&page=1");
                    break;
                }
                case "register": {
                    String name = request.getParameter("name");
                    String emails = request.getParameter("email");
                    String passwords = request.getParameter("password");
                    String phone = request.getParameter("phone");
                    String address = "";
                    String role = "Khách hàng";
                    Timestamp createdAt = new Timestamp(System.currentTimeMillis());
                    UserDTO users = new UserDTO(0, name, emails, phone, address, role, createdAt, passwords);
                    UserDAO userDAOs = new UserDAO();
                    if (userDAOs.isEmailExists(emails)) {
                        request.setAttribute("exitmail", "Email đã tồn tại!");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                    boolean isRegistered = userDAOs.insertUser(users);
                    if (isRegistered) {
                        request.setAttribute("success", "Đăng ký thành công!");
                    } else {
                        request.setAttribute("fail", "Đăng ký thất bại!");
                    }
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    break;
                }
                case "search": {
                    String keyword = request.getParameter("keyword");
                    List<ProductDTO> searchResults = new ProductDAO().searchProducts(keyword);
                    request.setAttribute("products", searchResults);
                    request.getRequestDispatcher("search.jsp").forward(request, response);
                    break;
                }
                case "loadProducts": {
                    int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                    int productsPerPage = 12;
                    List<ProductDTO> products = productDAO.getProductsByPage(page, productsPerPage);
                    int totalProducts = productDAO.getTotalProducts();
                    int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
                    List<CategoryDTO> categories = new CategoryDAO().getAllCategories();
                    request.setAttribute("products", products);
                    request.setAttribute("categories", categories);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.getRequestDispatcher("Main.jsp").forward(request, response);
                    break;
                }
                case "loadCategory": {
                    String categoryId = request.getParameter("category");
                    int categoryPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                    int productsPerPageCategory = 12;
                    List<ProductDTO> categoryProducts = productDAO.getProductsByCategoryAndPage(categoryId, categoryPage, productsPerPageCategory);
                    int totalProductsInCategory = productDAO.getTotalProductsByCategory(categoryId);
                    int totalPagesCategory = (int) Math.ceil((double) totalProductsInCategory / productsPerPageCategory);
                    List<CategoryDTO> allCategories = new CategoryDAO().getAllCategories();
                    request.setAttribute("products", categoryProducts);
                    request.setAttribute("categories", allCategories);
                    request.setAttribute("selectedCategory", categoryId);
                    request.setAttribute("currentPage", categoryPage);
                    request.setAttribute("totalPages", totalPagesCategory);
                    request.getRequestDispatcher("category.jsp").forward(request, response);
                    break;
                }
                case "viewProduct": {
                    int productId = Integer.parseInt(request.getParameter("id"));
                    ProductDTO product = productDAO.getProductById(productId);
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("Main.jsp").forward(request, response);
                    break;
                }
                case "viewCart": {
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    break;
                }
                case "addToCart": {
                    int cartProductId = Integer.parseInt(request.getParameter("productId"));
                    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }
                    cart.put(cartProductId, cart.getOrDefault(cartProductId, 0) + 1);
                    session.setAttribute("cart", cart);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"success\"}");
                    break;
                }
                case "removeFromCart": {
                    int removeProductId = Integer.parseInt(request.getParameter("productId"));
                    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
                    if (cart != null && cart.containsKey(removeProductId)) {
                        cart.remove(removeProductId);
                        session.setAttribute("cart", cart);
                    }
                    response.sendRedirect("MainController?action=viewCart");
                    break;
                }
                case "getCart": {
                    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
                    response.setContentType("application/json");
                    StringBuilder json = new StringBuilder("{");
                    if (cart != null && !cart.isEmpty()) {
                        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                            json.append("\"").append(entry.getKey()).append("\":").append(entry.getValue()).append(",");
                        }
                        json.deleteCharAt(json.length() - 1);
                    }
                    json.append("}");
                    response.getWriter().write(json.toString());
                    break;
                }
                case "checkout": {
                    request.getRequestDispatcher("checkout.jsp").forward(request, response);
                    break;
                }
                case "manageOrders": {
                    List<OrderDTO> orders = orderDAO.getAllOrders();
                    request.setAttribute("orders", orders);
                    request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
                    break;
                }
                case "manageUsers": {
                    List<UserDTO> users = userDAO.getAllUsers();
                    request.setAttribute("users", users);
                    request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
                    break;
                }
                case "deleteUser": {
                    try {
                        int userId = Integer.parseInt(request.getParameter("userId"));
                        boolean deleted = userDAO.deleteUser(userId);
                        if (deleted) {
                            response.sendRedirect("MainController?action=manageUsers");
                        } else {
                            request.setAttribute("error", "Không thể xóa người dùng.");
                            request.getRequestDispatcher("Users.jsp").forward(request, response);
                        }
                    } catch (Exception e) {
                        request.setAttribute("error", "Lỗi khi xóa người dùng: " + e.getMessage());
                        request.getRequestDispatcher("Users.jsp").forward(request, response);
                    }
                    break;
                }
                case "productDetail": {
                    // Lấy tham số sản phẩm từ request (sử dụng tên "proid")
                    String productIdStr = request.getParameter("proid");
                    ProductDTO pro = null;
                    try {
                        int proid = Integer.parseInt(productIdStr);
                        pro = productDAO.getProductById(proid);
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "ID sản phẩm không hợp lệ.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                        break;
                    }
                    if (pro != null) {
                        request.setAttribute("pro", pro);
                        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy sản phẩm.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                    }
                    break;
                }
                case "completeOrder": {
                    // 1) Lấy thông tin từ form
                    String address = request.getParameter("address");
                    String phone = request.getParameter("phone");
                    String email = request.getParameter("email");
                    // 2) Lấy user đang đăng nhập
                    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
                    // 3) Lấy giỏ hàng
                    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
                    if (cart == null || cart.isEmpty()) {
                        request.setAttribute("errorMessage", "Giỏ hàng trống, không thể thanh toán!");
                        request.getRequestDispatcher("checkout.jsp").forward(request, response);
                        break;
                    }
                    // 4) Tính tổng tiền
                    double totalPrice = 0;
                    ProductDAO prodDAO = new ProductDAO();
                    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                        ProductDTO product = prodDAO.getProductById(entry.getKey());
                        if (product != null) {
                            totalPrice += product.getPrice() * entry.getValue();
                        }
                    }
                    // 5) Tạo đơn hàng và lưu vào DB
                    // Sử dụng phương thức createOrder(int userId, HashMap<Integer,Integer> cart, double totalPrice, String shippingAddress)
                    int generatedOrderId = orderDAO.createOrder(
                            loggedInUser != null ? loggedInUser.getUserId() : 0,
                            cart,
                            totalPrice,
                            address
                    );
                    if (generatedOrderId > 0) {
                        session.removeAttribute("cart");
                        request.setAttribute("successMessage", "Thanh toán thành công! Mã đơn hàng: " + generatedOrderId);
                        request.getRequestDispatcher("checkout.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Thanh toán thất bại!");
                        request.getRequestDispatcher("checkout.jsp").forward(request, response);
                    }
                    break;
                }
                default: {
                    request.getRequestDispatcher("Main.jsp").forward(request, response);
                    break;
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
  
    @Override
    public String getServletInfo() {
        return "Main Controller - Quản lý tất cả các chức năng chính";
    }
}
