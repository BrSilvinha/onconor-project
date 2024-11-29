<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.onconor.db.ConexionDB" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Completa los Datos del Doctor</title>
    <link rel="stylesheet" href="css/StyleCDoc.css"> <!-- Vincula el archivo CSS separado -->
</head>
<body>
    <div class="form-container">
        <!-- Logo centrado justo arriba del título -->
        <img src="img/onconor_logo.jpg" alt="Logo" class="logo-imagen">
        <h2>Completa los datos del Doctor</h2>
        <form action="GuardarDoctorServlet" method="post">
            <input type="hidden" name="usuarioId" value="${param.usuarioId}">
            
            <label for="especialidad">Especialidad:</label>
            <select name="especialidad" required>
                <% 
                    // Obtener las especialidades de la base de datos
                    String sql = "SELECT id, nombre FROM especialidad";
                    try (Connection connection = ConexionDB.getConnection();
                         Statement stmt = connection.createStatement();
                         ResultSet rs = stmt.executeQuery(sql)) {
                        
                        while (rs.next()) {
                %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
            
            <br><br>
            <label for="cv">Resumen del CV:</label>
            <textarea name="cv" rows="4" cols="50" required></textarea>
            
            <br><br>
            <input type="submit" value="Guardar">
        </form>
    </div>
</body>
</html>
