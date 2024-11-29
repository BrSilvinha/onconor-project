<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Destruir la sesión
    response.sendRedirect("index.jsp"); // Redirigir a la página de inicio de sesión
%>
