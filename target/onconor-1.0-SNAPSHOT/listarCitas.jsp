<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Citas Pendientes</title>
</head>
<body>
    <h2>Lista de Citas Pendientes</h2>
<table border="1">
    <thead>
        <tr>
            <th>ID</th>
            <th>Usuario</th>
            <th>Doctor</th>
            <th>Especialidad</th>
            <th>Fecha</th>
            <th>Hora</th>
            <th>Estado</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="cita" items="${citas}">
            <tr>
                <td>${cita.id}</td>
                <td>${cita.usuarioNombre}</td>
                <td>${cita.doctorNombre}</td>
                <td>${cita.especialidadNombre}</td>
                <td>${cita.fecha}</td>
                <td>${cita.hora}</td>
                <td>${cita.estado}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
