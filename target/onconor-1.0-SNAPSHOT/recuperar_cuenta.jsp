<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Cuenta - Onconor</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/Responsive.css">
</head>
<body>
    <div class="login-container">
        <div class="left-section">
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo">
        </div>
        <div class="line"></div> <!-- Línea vertical -->
        <div class="right-section">
             <!-- Mueve la imagen del logo aquí para que esté sobre el formulario -->
            <img src="img/onconor_logo.jpg" alt="Onconor Logo" class="logo mobile-logo">
            <h2>Recuperar Cuenta</h2>
            <form action="RecuperarCuentaServlet" method="post">
                <div class="input-container">
                    <input type="email" name="correo" placeholder="Correo Electrónico" required>
                </div>
                <div class="button-container">
                    <button type="submit" class="login-btn">Buscar</button>
                </div>
            </form>
            <div class="options">
                <a href="index.jsp">Volver al Login</a>
            </div>
        </div>
    </div>
    
</body>
</html>


