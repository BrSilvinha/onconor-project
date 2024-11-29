<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados de Recuperación - Onconor</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/Responsive.css">
    <style>
        /* Estilo para el contenedor del usuario */
        .user-item {
            display: flex; /* Usar flexbox para alinear en línea */
            align-items: center; /* Centrar verticalmente */
            margin-bottom: 10px; /* Espacio entre los usuarios */
        }
        
        .user-icon {
            width: 30px; /* Ancho del ícono */
            height: 30px; /* Alto del ícono */
            background-color: #007bff; /* Color de fondo del ícono (ajustar según el diseño) */
            color: white; /* Color de la inicial */
            border-radius: 50%; /* Hacer que el ícono sea redondo */
            display: flex; /* Usar flexbox para centrar el texto */
            justify-content: center; /* Centrar horizontalmente */
            align-items: center; /* Centrar verticalmente */
            margin-right: 10px; /* Espacio entre el ícono y el nombre */
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Parte izquierda con el logo -->
        <div class="left-section">
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo">
        </div>
        <div class="line"></div> <!-- Línea vertical -->
        <!-- Parte derecha con los resultados -->
        <div class="right-section">
             <!-- Mueve la imagen del logo aquí para que esté sobre el formulario -->
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo mobile-logo">
            <h2>Cuentas encontradas</h2>
            
            <c:if test="${not empty error}">
                <p class="error-message">${error}</p>
            </c:if>

            <c:if test="${not empty usuario}">
                <div class="user-item">
                    <div class="user-icon">
                        ${usuario.nombre.toUpperCase().charAt(0)} <!-- Muestra la inicial del usuario -->
                    </div>
                    <span>${usuario.nombre} ${usuario.apellidos}</span> <!-- Muestra el nombre y apellidos -->
                    <span>- ${usuario.rol}</span> <!-- Muestra el rol -->
                    <a href="cambiar_contrasena.jsp?usuarioId=${usuario.id}" style="margin-left: 10px; color: #007bff; text-decoration: underline;">Cambiar Contraseña</a> <!-- Hipervínculo para cambiar contraseña -->
                </div>
            </c:if>
            
            <c:if test="${empty usuario}">
                <p>No se encontraron cuentas para el correo ingresado.</p>
            </c:if>
                
            <div class="options">
                <a href="recuperar_cuenta.jsp">Volver a buscar otra cuenta</a>
            </div>
        </div>
    </div>
</body>
</html>
