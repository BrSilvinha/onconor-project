package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.db.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/CambioContrasenaServlet")
public class CambioContrasenaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los parámetros del formulario
        String usuarioId = request.getParameter("usuarioId");
        String nuevaContrasena = request.getParameter("nuevaContrasena");

        // Validación básica
        if (usuarioId == null || nuevaContrasena == null || nuevaContrasena.isEmpty()) {
            request.setAttribute("error", "Debe ingresar un usuario y una nueva contraseña.");
            request.getRequestDispatcher("cambiar_contrasena.jsp").forward(request, response);
            return;
        }

        // Validar que la nueva contraseña tenga al menos 8 caracteres
        if (nuevaContrasena.length() < 8) {
            request.setAttribute("error", "La nueva contraseña debe tener al menos 8 caracteres.");
            request.getRequestDispatcher("cambiar_contrasena.jsp").forward(request, response);
            return;
        }

        try (Connection connection = ConexionDB.getConnection()) {
            // Encriptar la nueva contraseña
            String contraseñaEncriptada = encriptarContrasena(nuevaContrasena);

            // Actualizar la contraseña en la base de datos
            String sql = "UPDATE usuario SET contraseña = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, contraseñaEncriptada);
            statement.setString(2, usuarioId);  // El id de la tabla 'usuario', no 'persona'

            int filasActualizadas = statement.executeUpdate();
            if (filasActualizadas > 0) {
                request.setAttribute("mensaje", "Contraseña cambiada con éxito.");
            } else {
                request.setAttribute("error", "No se pudo cambiar la contraseña.");
            }
            request.getRequestDispatcher("cambiar_contrasena.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al conectar con la base de datos.");
            request.getRequestDispatcher("cambiar_contrasena.jsp").forward(request, response);
        }
    }

    // Método para encriptar la contraseña
    private String encriptarContrasena(String contraseña) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(contraseña.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}