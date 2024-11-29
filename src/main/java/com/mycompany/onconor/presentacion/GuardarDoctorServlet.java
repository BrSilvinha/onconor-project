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

@WebServlet("/GuardarDoctorServlet")
public class GuardarDoctorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el texto del CV desde el formulario
        String cv = request.getParameter("cv"); // Recibe el resumen del CV (en texto)

        // Obtener la especialidad seleccionada
        String especialidadId = request.getParameter("especialidad"); // Recibe la especialidad seleccionada

        // Obtener el usuario_id (deberías pasar este dato desde la sesión o el formulario)
        Long usuarioId = Long.parseLong(request.getParameter("usuarioId")); // Asegúrate de pasar el usuario_id

        // Verificar que el campo de CV no esté vacío
        if (cv == null || cv.trim().isEmpty()) {
            request.setAttribute("error", "El campo de CV no puede estar vacío.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Verificar que la especialidad no esté vacía
        if (especialidadId == null || especialidadId.trim().isEmpty()) {
            request.setAttribute("error", "Debe seleccionar una especialidad.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Aquí la lógica para insertar el nuevo doctor en la base de datos
        try {
            String sql = "INSERT INTO doctor (usuario_id, especialidad_id, cv) VALUES (?, ?, ?)";

            try (Connection conn = ConexionDB.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setLong(1, usuarioId); // Usar Long en lugar de int para el usuario_id
                stmt.setInt(2, Integer.parseInt(especialidadId)); // Convertir especialidadId a Integer
                stmt.setString(3, cv); // Establecer el CV

                // Ejecutar la inserción en la base de datos
                stmt.executeUpdate();
            }

            // Redirigir a la lista de usuarios
            response.sendRedirect("MostrarUsuariosServlet");

        } catch (Exception e) {
            // Manejo de excepciones (si algo sale mal)
            e.printStackTrace();
            request.setAttribute("error", "Hubo un error al guardar la información del doctor.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
