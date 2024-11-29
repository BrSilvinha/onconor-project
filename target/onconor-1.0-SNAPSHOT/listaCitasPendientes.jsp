<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.onconor.db.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/StyleTabla.css">
    <title>Lista de Citas</title>
    <script>
        let menuOpen = false; // Estado del menú

        function toggleUserInfo() {
            var userInfo = document.getElementById("user-info");
            userInfo.style.display = userInfo.style.display === "none" || userInfo.style.display === "" ? "flex" : "none"; // Alternar visibilidad
        }

        function toggleMenu() {
            var menu = document.getElementById("menu");
            var mainImage = document.getElementById("main-image");
            if (menuOpen) {
                menu.style.display = "none"; // Oculta el menú
                mainImage.style.marginLeft = "0"; // Restaura el margen
                menuOpen = false; // Cambia el estado del menú
            } else {
                menu.style.display = "flex"; // Muestra el menú
                mainImage.style.marginLeft = "300px"; // Deja espacio para el menú
                menuOpen = true; // Cambia el estado del menú
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <!-- Barra superior con icono y logo -->
            <div class="bar-rectangular">
                <div class="user-info-inside">
                    <div id="user-info" style="display: none; flex-direction: column; align-items: flex-start;">
                        <span id="user-name">
                            <%= session.getAttribute("nombre") != null ? session.getAttribute("nombre") : "Invitado" %>
                        </span>
                        <a href="logout.jsp" class="logout">Cerrar sesión</a>
                    </div>

                    <div class="user-icon" onclick="toggleUserInfo()" style="cursor: pointer;">
                        <%= session.getAttribute("nombre") != null ? ((String) session.getAttribute("nombre")).toUpperCase().charAt(0) : "?" %>
                    </div>
                </div>

                <div class="menu-icon" onclick="toggleMenu()" style="cursor: pointer;">
                    &#9776; <!-- Símbolo de tres rayas -->
                </div>
                <div class="logo-container">
                    <img src="img/Logo.png" alt="Logo" class="logo-image">
                </div>
            </div>

            <!-- Menú lateral -->
            <div id="menu">
                <h2 style="text-align: center; font-weight: bold; margin: 20px 0; font-size: 36px; color: black;">Onconor</h2> <!-- Título en negro -->
                <ul style="list-style-type: none; padding: 0; margin: 0;">
                    <li style="padding: 8px 12px;">
                        <a href="bienvenida.jsp">Inicio</a> <!-- Texto en mayúsculas y centrado -->
                    </li>
                    <li style="padding: 8px 12px;">
                        <a href="listaCitas.jsp">Lista de Citas</a> <!-- Enlace a la página de citas -->
                    </li>
                </ul>
            </div>

            <!-- Contenido principal -->
            <div class="main-image" id="main-image" style="margin-left: 0; transition: margin-left 0.3s;">
                <h2 style="text-align: center; color: white;">Lista de Citas</h2> <!-- Título en blanco -->
                <table>
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Especialidad</th>
                            <th>Doctor</th>
                            <th>Estado</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Obtener el ID del doctor de la sesión
                            Integer doctorId = (Integer) session.getAttribute("doctorId");

                            // Asegúrate de que el doctorId esté disponible en la sesión
                            if (doctorId == null) {
                                out.println("No se encuentra el doctor logueado.");
                                return;
                            }

                            // Consulta SQL para obtener las citas del doctor logueado
                            String sql = "SELECT c.id, c.fecha, c.hora, e.nombre AS especialidad, p.nombre AS doctor_nombre, p.apellidos AS doctor_apellidos, c.estado " +
                                         "FROM cita c " +
                                         "JOIN doctor d ON c.doctor_id = d.id " +
                                         "JOIN persona p ON d.usuario_id = p.id " +
                                         "JOIN especialidad e ON c.especialidad_id = e.id " +
                                         "WHERE d.id = ?"; // Filtramos por el doctor logueado
                            
                            Connection connection = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            try {
                                connection = ConexionDB.getConnection();
                                stmt = connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                stmt.setInt(1, doctorId); // Establecemos el ID del doctor en la consulta
                                rs = stmt.executeQuery();
                                
                                if (!rs.next()) {
                                    out.println("No se encontraron citas.");
                                } else {
                                    rs.beforeFirst(); // Volver al inicio para mostrar los resultados en la tabla
                                    while (rs.next()) {
                        %>
                                        <tr>
                                            <td><%= rs.getString("fecha") %></td>
                                            <td><%= rs.getString("hora") %></td>
                                            <td><%= rs.getString("especialidad") %></td>
                                            <td><%= rs.getString("doctor_nombre") + " " + rs.getString("doctor_apellidos") %></td>
                                            <td><%= rs.getString("estado") %></td>
                                            <td>
                                                <!-- Formulario para cambiar el estado de la cita -->
                                                <form action="CambiarEstadoServlet" method="POST">
                                                    <input type="hidden" name="citaId" value="<%= rs.getInt("id") %>">
                                                    <select name="estado">
                                                        <option value="Pendiente" <%= rs.getString("estado").equals("Pendiente") ? "selected" : "" %>>Pendiente</option>
                                                        <option value="Confirmada" <%= rs.getString("estado").equals("Confirmada") ? "selected" : "" %>>Confirmada</option>
                                                        <option value="Cancelada" <%= rs.getString("estado").equals("Cancelada") ? "selected" : "" %>>Cancelada</option>
                                                    </select>
                                                    <button type="submit">Actualizar</button>
                                                </form>
                                            </td>
                                        </tr>
                        <%
                                    }
                                }
                            } catch (SQLException e) {
                                out.println("Error en la consulta SQL: " + e.getMessage());
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (connection != null) connection.close();
                                } catch (SQLException e) {
                                    out.println("Error cerrando recursos: " + e.getMessage());
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
