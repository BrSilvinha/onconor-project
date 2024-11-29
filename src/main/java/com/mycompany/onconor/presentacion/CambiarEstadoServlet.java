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
import java.sql.SQLException;


@WebServlet("/CambiarEstadoServlet")
public class CambiarEstadoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int citaId = Integer.parseInt(request.getParameter("citaId"));
        String estado = request.getParameter("estado");

        Connection connection = null;
        PreparedStatement stmt = null;
        try {
            connection = ConexionDB.getConnection();
            String sql = "UPDATE cita SET estado = ? WHERE id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, estado);
            stmt.setInt(2, citaId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("listaCitas.jsp"); // Redirigir a la lista de citas después de actualizar el estado
            } else {
                response.getWriter().println("Error al actualizar el estado.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error en la actualización de la base de datos.");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}