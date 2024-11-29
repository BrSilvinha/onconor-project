<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.onconor.db.ConexionDB" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/StyleTabla.css">
    <title>Listado de Doctores</title>
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

            <div id="menu">
                <h2 style="text-align: center; font-weight: bold; margin: 20px 0; font-size: 36px; color: black;">Onconor</h2>
                <ul style="list-style-type: none; padding: 0; margin: 0;">
                    <li style="text-align: center; padding: 8px 12px;">
                        <a href="bienvenida.jsp">Inicio</a>
                    </li>
                </ul>
            </div>

            <div class="main-image" id="main-image" style="margin-left: 0; transition: margin-left 0.3s;">
                <h2 style="text-align: center; color: white;">Listado de Doctores</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>Especialidad</th>
                            <th>Correo</th>
                            <th>Teléfono</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String sql = "SELECT p.nombre, p.apellidos, e.nombre AS especialidad, p.correo, p.telefono, d.id AS doctor_id " +
                                         "FROM doctor d " +
                                         "JOIN usuario u ON d.usuario_id = u.id " +
                                         "JOIN persona p ON u.persona_id = p.id " +
                                         "JOIN especialidad e ON d.especialidad_id = e.id";

                            try (Connection connection = ConexionDB.getConnection();
                                 Statement stmt = connection.createStatement();
                                 ResultSet rs = stmt.executeQuery(sql)) {

                                while (rs.next()) {
                        %>
                                    <tr>
                                        <td><%= rs.getString("nombre") %></td>
                                        <td><%= rs.getString("apellidos") %></td>
                                        <td><%= rs.getString("especialidad") %></td>
                                        <td><%= rs.getString("correo") %></td>
                                        <td><%= rs.getString("telefono") %></td>
                                        <td class="table-actions">
                                            <a href="editarDoctor.jsp?id=<%= rs.getInt("doctor_id") %>" style="text-decoration: none;">Editar</a> |
                                            <a href="eliminarDoctor.jsp?id=<%= rs.getInt("doctor_id") %>" style="text-decoration: none;">Eliminar</a>
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
