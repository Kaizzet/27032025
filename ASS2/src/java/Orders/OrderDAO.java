package Orders;

import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    // Lấy danh sách tất cả đơn hàng
    public List<OrderDTO> getAllOrders() {
        List<OrderDTO> orderList = new ArrayList<>();
        String sql = "SELECT o.*, COUNT(od.product_id) AS total_items " +
                     "FROM orders o " +
                     "LEFT JOIN order_details od ON o.order_id = od.order_id " +
                     "GROUP BY o.order_id, o.user_id, o.order_date, o.status, o.total_price, o.shipping_address";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderDTO order = new OrderDTO();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setCreatedAt(rs.getString("order_date"));
                order.setStatus(rs.getString("status"));
                order.setTotalPrice(rs.getDouble("total_price"));
                order.setTotalItems(rs.getInt("total_items"));
                order.setShippingAddress(rs.getString("shipping_address"));
                orderList.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }

    // Tạo đơn hàng mới và lưu chi tiết sản phẩm
    public int createOrder(int userId, HashMap<Integer, Integer> cart, double totalPrice, String shippingAddress) {
        int orderId = -1;
        String sqlInsertOrder = "INSERT INTO orders (user_id, order_date, status, total_price, shipping_address) " +
                                "VALUES (?, GETDATE(), 'Đã thanh toán', ?, ?)";
        String sqlInsertOrderItem = "INSERT INTO order_details (order_id, product_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement psOrder = conn.prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psOrderItem = conn.prepareStatement(sqlInsertOrderItem)) {
            conn.setAutoCommit(false);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, totalPrice);
            psOrder.setString(3, shippingAddress);
            int rowsAffected = psOrder.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
            if (orderId > 0) {
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    psOrderItem.setInt(1, orderId);
                    psOrderItem.setInt(2, entry.getKey());
                    psOrderItem.setInt(3, entry.getValue());
                    psOrderItem.executeUpdate();
                }
                conn.commit();
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            orderId = -1;
        }
        return orderId;
    }

    // Các phương thức khác: getOrderById, insertOrder, updateOrder, deleteOrder...
}
