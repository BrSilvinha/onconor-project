<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/StyleTabla.css">
    <title>Bienvenido a Onconor</title>
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
            <div class="header"></div>
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

            <div id="menu">
                <h2 style="text-align: center; font-weight: bold; margin: 20px 0; font-size: 36px; color: black;">Onconor</h2> <!-- Título en negro -->
                <ul style="list-style-type: none; padding: 0; margin: 0;">
                    <li style="padding: 8px 12px;">
                        <a href="bienvenida.jsp">Inicio</a> <!-- Texto en mayúsculas y centrado -->
                    </li>
                </ul>
            </div>

            <div class="main-image" id="main-image" style="margin-left: 0; transition: margin-left 0.3s;">
                <h2 style="text-align: center; color: white;">Lista de Usuarios</h2> <!-- Título en blanco -->
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>DNI</th>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>Rol</th>
                            <th>Teléfono</th> <!-- Nueva columna para Teléfono -->
                            <th>Dirección</th> <!-- Nueva columna para Dirección -->
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="usuario" items="${usuarios}">
                            <tr>
                                <td>${usuario.id}</td>
                                <td>${usuario.dni}</td>
                                <td>${usuario.nombre}</td>
                                <td>${usuario.apellidos}</td>
                                <td>${usuario.rol}</td>
                                <td>${usuario.telefono}</td> <!-- Mostrar teléfono -->
                                <td>${usuario.direccion}</td> <!-- Mostrar dirección -->
                                <td class="table-actions">
                                    <form action="CambiarRolServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${usuario.id}">
                                        <select name="rol">
                                            <option value="admin" <c:if test="${usuario.rol == 'admin'}">selected</c:if>>Administrador</option>
                                            <option value="doctor" <c:if test="${usuario.rol == 'doctor'}">selected</c:if>>Doctor</option>
                                            <option value="usuario" <c:if test="${usuario.rol == 'usuario'}">selected</c:if>>Usuario</option>
                                        </select>
                                        <button type="submit">Cambiar</button> <!-- Botón cambiado a "Cambiar" -->
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
