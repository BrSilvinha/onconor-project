package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.db.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/CambiarRolServlet")
public class CambiarRolServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String rol = request.getParameter("rol");

        if (!rol.equals("admin") && !rol.equals("doctor") && !rol.equals("usuario")) {
            throw new IllegalArgumentException("El rol no es válido. Los roles permitidos son: admin, doctor, usuario.");
        }

        int id = Integer.parseInt(idStr);

        try {
            int rolId = getRolId(rol);

            String sql = "UPDATE usuario SET rol_id = ? WHERE persona_id = ?";
            try (Connection connection = ConexionDB.getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {

                statement.setInt(1, rolId);
                statement.setInt(2, id);
                statement.executeUpdate();

                if ("doctor".equals(rol)) {
                    response.sendRedirect("completarDoctor.jsp?usuarioId=" + id);
                } else {
                    response.sendRedirect("MostrarUsuariosServlet");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cambiar el rol: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private int getRolId(String rol) throws SQLException {
        String sql = "SELECT id FROM rol WHERE nombre = ?";
        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, rol);

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                } else {
                    throw new SQLException("Rol no encontrado en la base de datos.");
                }
            }
        }
    }
}
