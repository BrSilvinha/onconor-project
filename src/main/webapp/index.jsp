<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Aquí va la etiqueta viewport -->
    <title>Login - Onconor</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/Responsive.css">
</head>
<body>
    <div class="login-container">
        <!-- Parte izquierda con el logo -->
        <div class="left-section">
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo">
        </div>
        <div class="line"></div> <!-- Línea vertical -->
        <!-- Parte derecha con el formulario -->
        <div class="right-section">
            <!-- Mueve la imagen del logo aquí para que esté sobre el formulario -->
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo mobile-logo">
            <h2>LOGIN</h2>
            
            <!-- Mostrar mensaje de error si las credenciales son incorrectas -->
            <c:if test="${not empty error}">
                <p class="error-message">${error}</p>
            </c:if>

            <form action="LoginServlet" method="post">
                <div class="input-container">
                    <input type="email" name="correo" placeholder="Correo Electrónico" required>
                </div>
                <div class="input-container">
                    <input type="password" name="contraseña" placeholder="Contraseña" required>
                </div>
                <div class="options">
                    <a href="crear_cuenta.jsp">Crear cuenta</a>
                    <a href="recuperar_cuenta.jsp">Recuperar cuenta</a>
                </div>
                <div class="button-container">
                    <button type="submit" class="login-btn">Ingresar</button>
                </div>
            </form>
        </div>
    </div>
</body>

</html>