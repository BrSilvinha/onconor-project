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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/CrearCuentaServlet")
public class CrearCuentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Capturar los parámetros del formulario
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String contraseña = request.getParameter("contraseña");
        String dni = request.getParameter("dni"); // Capturar el DNI
        String telefono = request.getParameter("telefono"); // Capturar el teléfono
        String direccion = request.getParameter("direccion"); // Capturar la dirección

        // Validación simple de campos vacíos
        if (nombre == null || apellidos == null || correo == null || contraseña == null || dni == null || telefono == null || direccion == null ||
            nombre.isEmpty() || apellidos.isEmpty() || correo.isEmpty() || contraseña.isEmpty() || dni.isEmpty() || telefono.isEmpty() || direccion.isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
            return;
        }

        // Validar la longitud de la contraseña (mínimo 8 caracteres)
        if (contraseña.length() < 8) {
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres.");
            request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
            return;
        }

        // Validar que el DNI tenga exactamente 8 dígitos
        if (dni.length() != 8 || !dni.matches("\\d+")) {
            request.setAttribute("error", "El DNI debe tener exactamente 8 dígitos.");
            request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
            return;
        }

        // Validar que el teléfono tenga exactamente 9 dígitos
        if (telefono.length() != 9 || !telefono.matches("\\d+")) {
            request.setAttribute("error", "El teléfono debe tener exactamente 9 dígitos.");
            request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
            return;
        }

        // Intentar guardar el usuario en la base de datos
        try (Connection connection = ConexionDB.getConnection()) {
            // Verificar si el correo ya existe
            if (correoYaRegistrado(connection, correo)) {
                request.setAttribute("error", "El correo ya está registrado.");
                request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
                return;
            }

            // Verificar si el DNI ya existe
            if (dniYaRegistrado(connection, dni)) {
                request.setAttribute("error", "El DNI ya está registrado.");
                request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
                return;
            }

            // Insertar los datos de la persona (con teléfono y dirección)
            String sqlPersona = "INSERT INTO persona (dni, nombre, apellidos, correo, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement statementPersona = connection.prepareStatement(sqlPersona, PreparedStatement.RETURN_GENERATED_KEYS);
            statementPersona.setString(1, dni);
            statementPersona.setString(2, nombre);
            statementPersona.setString(3, apellidos);
            statementPersona.setString(4, correo);
            statementPersona.setString(5, telefono); // Insertar teléfono
            statementPersona.setString(6, direccion); // Insertar dirección

            int rowsInsertedPersona = statementPersona.executeUpdate();
            if (rowsInsertedPersona == 0) {
                request.setAttribute("error", "Error al crear la persona.");
                request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
                return;
            }

            // Obtener el ID de la persona insertada
            ResultSet generatedKeys = statementPersona.getGeneratedKeys();
            int personaId = -1;
            if (generatedKeys.next()) {
                personaId = generatedKeys.getInt(1);
            }

            // Insertar el usuario con el rol 'usuario' (id = 3 en la tabla 'rol')
            String sqlUsuario = "INSERT INTO usuario (persona_id, rol_id, contraseña) VALUES (?, 3, ?)";
            PreparedStatement statementUsuario = connection.prepareStatement(sqlUsuario);
            statementUsuario.setInt(1, personaId);
            statementUsuario.setString(2, encriptarContrasena(contraseña));

            int rowsInsertedUsuario = statementUsuario.executeUpdate();
            if (rowsInsertedUsuario > 0) {
                response.sendRedirect("index.jsp?mensaje=cuenta_creada");
            } else {
                request.setAttribute("error", "Error al crear la cuenta.");
                request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al conectarse a la base de datos: " + e.getMessage());
            request.getRequestDispatcher("crear_cuenta.jsp").forward(request, response);
        }
    }

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
            throw new RuntimeException("Error al encriptar la contraseña", e);
        }
    }

    private boolean correoYaRegistrado(Connection connection, String correo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM persona WHERE correo = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, correo);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    private boolean dniYaRegistrado(Connection connection, String dni) throws SQLException {
        String sql = "SELECT COUNT(*) FROM persona WHERE dni = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, dni);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }
}