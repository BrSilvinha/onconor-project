package com.mycompany.onconor.presentacion;

import com.mycompany.onconor.datos.Usuario;
import com.mycompany.onconor.db.ConexionDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/MostrarUsuariosServlet")
public class MostrarUsuariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar si el usuario tiene rol de administrador
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");

        // Si no es administrador, redirigir a la página de bienvenida o a un error
        if (rol == null || !rol.equals("admin")) {
            response.sendRedirect("bienvenida.jsp"); // O redirigir a una página de error
            return;
        }

        List<Usuario> usuarios = new ArrayList<>();

        // Consulta SQL para obtener los usuarios desde la tabla 'usuario' y unirla con 'persona'
        // Incluimos los campos telefono y direccion
        String sql = "SELECT u.id, p.dni, p.nombre, p.apellidos, r.nombre AS rol, p.telefono, p.direccion " +
                     "FROM usuario u " +
                     "JOIN persona p ON u.persona_id = p.id " +
                     "JOIN rol r ON u.rol_id = r.id";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            // Recorrer el ResultSet y agregar los usuarios a la lista
            while (resultSet.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(resultSet.getLong("id")); // Usar Long para 'id'
                usuario.setDni(resultSet.getString("dni"));
                usuario.setNombre(resultSet.getString("nombre"));
                usuario.setApellidos(resultSet.getString("apellidos"));
                usuario.setRol(resultSet.getString("rol"));
                usuario.setTelefono(resultSet.getString("telefono"));  // Añadir telefono
                usuario.setDireccion(resultSet.getString("direccion"));  // Añadir direccion
                usuarios.add(usuario);
            }

            // Pasar la lista de usuarios a la página JSP
            request.setAttribute("usuarios", usuarios);
            request.getRequestDispatcher("lista_usuarios.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al recuperar los usuarios de la base de datos: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
