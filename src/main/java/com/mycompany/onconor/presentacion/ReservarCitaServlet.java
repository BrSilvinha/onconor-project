package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.db.ConexionDB;
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

@WebServlet("/ReservarCitaServlet")
public class ReservarCitaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los parámetros enviados desde el formulario
        String doctorId = request.getParameter("doctorId");
        String especialidad = request.getParameter("especialidad");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");

        // Obtener el usuarioId de la sesión
        HttpSession session = request.getSession();
        Integer usuarioId = (Integer) session.getAttribute("usuario_id");

        if (usuarioId == null) {
            // Manejar el caso cuando el usuario no ha iniciado sesión
            request.setAttribute("error", "Debe iniciar sesión para agendar una cita.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Convertir el valor de especialidad a su ID correspondiente
        int especialidadId = obtenerEspecialidadId(especialidad);

        if (especialidadId == -1) {
            request.setAttribute("error", "Especialidad no válida.");
            request.getRequestDispatcher("bienvenida.jsp").forward(request, response);
            return;
        }

        // Consulta SQL para insertar la cita
        String sql = "INSERT INTO cita (usuario_id, doctor_id, especialidad_id, fecha, hora, estado) VALUES (?, ?, ?, ?, ?, 'Pendiente')";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, usuarioId);
            ps.setInt(2, Integer.parseInt(doctorId));
            ps.setInt(3, especialidadId);
            ps.setDate(4, java.sql.Date.valueOf(fecha));
            ps.setTime(5, java.sql.Time.valueOf(hora + ":00"));

            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                request.setAttribute("success", "Cita agendada exitosamente.");
            } else {
                request.setAttribute("error", "No se pudo agendar la cita. Intente nuevamente.");
            }

            request.getRequestDispatcher("bienvenida.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al procesar su solicitud.");
            request.getRequestDispatcher("bienvenida.jsp").forward(request, response);
        }
    }

    private int obtenerEspecialidadId(String especialidadNombre) {
        String sql = "SELECT id FROM especialidad WHERE nombre = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, especialidadNombre);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Retornar -1 si no se encuentra la especialidad
    }
}
