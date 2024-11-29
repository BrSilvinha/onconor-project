package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.db.ConexionDB;
import com.mycompany.onconor.servicios.PasswordUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String contraseña = request.getParameter("contraseña");

        // Validación de campos vacíos
        if (correo == null || correo.isEmpty() || contraseña == null || contraseña.isEmpty()) {
            request.setAttribute("error", "Por favor, ingrese su correo y contraseña.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Conectar a la base de datos y verificar credenciales
        try (Connection con = ConexionDB.getConnection()) {
            String sql = "SELECT u.id AS usuario_id, p.nombre, r.nombre AS rol, u.contraseña, d.id AS doctor_id " +
                         "FROM usuario u " +
                         "JOIN persona p ON u.persona_id = p.id " +
                         "JOIN rol r ON u.rol_id = r.id " +
                         "LEFT JOIN doctor d ON u.id = d.usuario_id " + 
                         "WHERE p.correo = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, correo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String hashedContraseña = rs.getString("contraseña");
                        String nombre = rs.getString("nombre");
                        String rol = rs.getString("rol");
                        int usuarioId = rs.getInt("usuario_id");
                        Integer doctorId = rs.getObject("doctor_id") != null ? rs.getInt("doctor_id") : null;

                        // Verificación de contraseña
                        if (PasswordUtils.verifyPassword(contraseña, hashedContraseña)) {
                            HttpSession session = request.getSession();
                            session.setAttribute("usuario_id", usuarioId);
                            session.setAttribute("correo", correo);
                            session.setAttribute("nombre", nombre);
                            session.setAttribute("rol", rol);

                            // Guardar doctorId si aplica
                            if ("Doctor".equalsIgnoreCase(rol) && doctorId != null) {
                                session.setAttribute("doctorId", doctorId);
                            }

                            // Redirigir a la página de bienvenida
                            response.sendRedirect("bienvenida.jsp");
                        } else {
                            request.setAttribute("error", "Correo o contraseña incorrectos.");
                            request.getRequestDispatcher("index.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("error", "Correo o contraseña incorrectos.");
                        request.getRequestDispatcher("index.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al procesar la solicitud. Inténtelo de nuevo más tarde.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
