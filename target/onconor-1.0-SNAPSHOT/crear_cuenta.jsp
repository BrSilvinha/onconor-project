<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta - Onconor</title>
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
            <h2>Crear Cuenta</h2>
            <c:if test="${not empty error}">
                <p class="error-message">${error}</p>
            </c:if>
            <form action="CrearCuentaServlet" method="post">
                <div class="input-container">
                    <input type="text" name="nombre" placeholder="Nombres" required>
                </div>
                <div class="input-container">
                    <input type="text" name="apellidos" placeholder="Apellidos" required>
                </div>
                <div class="input-container">
                    <input type="email" name="correo" placeholder="Correo Electrónico" required>
                </div>
                <div class="input-container">
                    <input type="password" name="contraseña" placeholder="Contraseña" required>
                </div>
                <div class="input-container">
                    <input type="text" name="dni" placeholder="DNI" required>
                </div>
                <div class="input-container">
                    <input type="text" name="telefono" placeholder="Teléfono" required>
                </div>
                <div class="input-container">
                    <input type="text" name="direccion" placeholder="Dirección" required>
                </div>
                <div class="button-container">
                    <button type="submit" class="login-btn">Crear Cuenta</button>
                </div>
            </form>
            <div class="options">
                <a href="index.jsp">Volver al Login</a>
            </div>
        </div>
    </div>
</body>
</html>
