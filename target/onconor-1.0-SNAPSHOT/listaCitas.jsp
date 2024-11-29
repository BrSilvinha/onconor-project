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
        let menuOpen = false;

        function toggleUserInfo() {
            var userInfo = document.getElementById("user-info");
            userInfo.style.display = userInfo.style.display === "none" || userInfo.style.display === "" ? "flex" : "none";
        }

        function toggleMenu() {
            var menu = document.getElementById("menu");
            var mainImage = document.getElementById("main-image");
            if (menuOpen) {
                menu.style.display = "none";
                mainImage.style.marginLeft = "0";
                menuOpen = false;
            } else {
                menu.style.display = "flex";
                mainImage.style.marginLeft = "300px";
                menuOpen = true;
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
                    &#9776;
                </div>
                <div class="logo-container">
                    <img src="img/Logo.png" alt="Logo" class="logo-image">
                </div>
            </div>

            <!-- Menú lateral -->
            <div id="menu">
                <h2 style="text-align: center; font-weight: bold; margin: 20px 0; font-size: 36px; color: black;">Onconor</h2>
                <ul style="list-style-type: none; padding: 0; margin: 0;">
                    <li style="padding: 8px 12px;">
                        <a href="bienvenida.jsp">Inicio</a>
                    </li>
                    <li style="padding: 8px 12px;">
                        <a href="listaCitas.jsp">Lista de Citas</a>
                    </li>
                </ul>
            </div>

            <!-- Contenido principal -->
            <div class="main-image" id="main-image" style="margin-left: 0; transition: margin-left 0.3s;">
                <h2 style="text-align: center; color: white;">Lista de Citas</h2>
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
                            String sql = "SELECT c.id, c.fecha, c.hora, e.nombre AS especialidad, " +
                                         "p.nombre AS doctor_nombre, p.apellidos AS doctor_apellidos, c.estado " +
                                         "FROM cita c " +
                                         "JOIN doctor d ON c.doctor_id = d.id " +
                                         "JOIN persona p ON d.usuario_id = p.id " +
                                         "JOIN especialidad e ON c.especialidad_id = e.id";

                            Connection connection = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            try {
                                connection = ConexionDB.getConnection();
                                stmt = connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                rs = stmt.executeQuery();

                                if (!rs.next()) {
                                    out.println("<tr><td colspan='6' style='text-align:center;'>No se encontraron citas.</td></tr>");
                                } else {
                                    rs.beforeFirst();
                                    while (rs.next()) {
                        %>
                                        <tr>
                                            <td><%= rs.getString("fecha") %></td>
                                            <td><%= rs.getString("hora") %></td>
                                            <td><%= rs.getString("especialidad") %></td>
                                            <td><%= rs.getString("doctor_nombre") + " " + rs.getString("doctor_apellidos") %></td>
                                            <td><%= rs.getString("estado") %></td>
                                            <td>
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
                                out.println("<tr><td colspan='6' style='text-align:center;'>Error en la consulta SQL: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (connection != null) connection.close();
                                } catch (SQLException e) {
                                    out.println("<tr><td colspan='6' style='text-align:center;'>Error cerrando recursos: " + e.getMessage() + "</td></tr>");
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
