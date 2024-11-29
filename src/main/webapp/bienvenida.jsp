<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/Responsive.css">
    <title>Bienvenido a Onconor</title>
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
                        <c:choose>
                            <c:when test="${not empty sessionScope.nombre}">
                                <!-- Obtener la primera letra del nombre y convertirla a mayúscula -->
                                <c:out value="${sessionScope.nombre.substring(0, 1).toUpperCase()}" />
                            </c:when>
                            <c:otherwise>
                                ?
                            </c:otherwise>
                        </c:choose>
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
                        <% 
                            String rol = (String) session.getAttribute("rol");
                            if ("admin".equals(rol)) {
                        %>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="MostrarUsuariosServlet" style="text-decoration: none;">Lista de Usuarios</a>
                            </li>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="listarDoctores.jsp" style="text-decoration: none;">Lista de Doctores</a>
                            </li>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="listaCitas.jsp" style="text-decoration: none;">Lista de Citas</a>
                            </li>
                        <% 
                            } else if ("usuario".equals(rol)) {
                        %>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="misCitas.jsp" style="text-decoration: none;">Mis Citas</a>
                            </li>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="agendarCita.jsp" style="text-decoration: none;">Agendar Cita</a>
                            </li>
                        <% 
                            } else if ("doctor".equals(rol)) {
                        %>
                            <li style="text-align: center; text-transform: uppercase; padding: 8px 12px;">
                                <a href="listaCitasPendientes.jsp" style="text-decoration: none;">Lista de Citas Pendientes</a>
                            </li>
                        <% 
                            }
                        %>
                    </ul>
            </div>

            <div class="main-image" id="main-image" style="margin-left: 0; transition: margin-left 0.3s;">
                <h2 style="text-align: center; color: white;">
                    <%
                        if ("admin".equals(rol)) {
                            out.print("Bienvenido Administrador");
                        } else if ("doctor".equals(rol)) {
                            out.print("Bienvenido Doctor");
                        } else {
                            out.print("Bienvenido a Onconor");
                        }
                    %>
                </h2>
                <img src="img/Onconor_inicio.png" alt="Onconor Inicio" style="width: 100%; height: auto;">
            </div>
        </div>
    </div>
</body>
</html>
