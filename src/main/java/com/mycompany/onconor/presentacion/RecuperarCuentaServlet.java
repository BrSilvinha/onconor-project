package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.datos.Usuario;
import com.mycompany.onconor.db.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/RecuperarCuentaServlet")
public class RecuperarCuentaServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RecuperarCuentaServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");

        // Validación del correo
        if (correo == null || correo.isEmpty() || !correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("error", "Debe ingresar un correo válido.");
            request.getRequestDispatcher("recuperar_cuenta.jsp").forward(request, response);
            return;
        }

        // Usar JDBC para realizar la consulta a la base de datos
        try (Connection conn = ConexionDB.getConnection()) {
            // Crear la consulta SQL para recuperar los datos del usuario
            String sql = "SELECT p.id, p.nombre, p.apellidos, p.correo, r.nombre AS rol " +
                         "FROM persona p " +
                         "JOIN usuario u ON p.id = u.persona_id " +
                         "JOIN rol r ON u.rol_id = r.id " +
                         "WHERE p.correo = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, correo);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Crear un objeto Usuario con los datos recuperados
                        Usuario usuario = new Usuario();
                        usuario.setId(rs.getLong("id"));
                        usuario.setNombre(rs.getString("nombre"));
                        usuario.setApellidos(rs.getString("apellidos"));
                        usuario.setCorreo(rs.getString("correo"));
                        usuario.setRol(rs.getString("rol"));
                        usuario.setFechaRegistro(new Timestamp(System.currentTimeMillis())); // Este campo se puede ajustar si es necesario

                        // Enviar el usuario encontrado como atributo
                        request.setAttribute("usuario", usuario);
                        request.getRequestDispatcher("resultados_recuperar_cuenta.jsp").forward(request, response);
                    } else {
                        // No se encontraron usuarios para el correo proporcionado
                        request.setAttribute("error", "No se encontraron cuentas para el correo ingresado.");
                        request.getRequestDispatcher("recuperar_cuenta.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al recuperar cuenta con JDBC: ", e);
            request.setAttribute("error", "Error al conectar con la base de datos. Por favor, inténtalo de nuevo más tarde.");
            request.getRequestDispatcher("recuperar_cuenta.jsp").forward(request, response);
        }
    }
}

