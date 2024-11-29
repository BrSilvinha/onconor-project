package com.mycompany.onconor.datos;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import java.io.Serializable;
import java.sql.Timestamp;
import com.mycompany.onconor.servicios.PasswordUtils; // Importación del utilitario de contraseñas

@Entity
public class Usuario implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Estrategia para auto-incremento
    private Long id;

    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private String apellidos;

    @Column(nullable = false, unique = true)
    private String correo; // Validación de correo como único

    @Column(nullable = false, unique = true)
    private String dni; // Validación de DNI como único

    @Column(nullable = false)
    private String contraseña; // Almacena la contraseña hasheada

    @Column(nullable = false)
    private String rol; // Campo de rol

    @Column(nullable = true)
    private String telefono; // Campo opcional

    @Column(nullable = true)
    private String direccion; // Campo opcional

    @Column(nullable = false)
    private Timestamp fechaRegistro; // Fecha de registro

    // Constructor por defecto
    public Usuario() {
        this.fechaRegistro = new Timestamp(System.currentTimeMillis()); // Inicializa fechaRegistro al momento actual
    }

    // Constructor con parámetros
    public Usuario(Long id, String nombre, String apellidos, String correo, String dni, String contraseña, String rol, String telefono, String direccion) {
        this.id = id;
        this.nombre = nombre;
        this.apellidos = apellidos;
        setCorreo(correo); // Validación de correo
        setDni(dni); // Validación de DNI
        setContraseña(contraseña); // Hasheado de contraseña
        setRol(rol); // Validación de rol
        this.telefono = telefono;
        this.direccion = direccion;
        this.fechaRegistro = new Timestamp(System.currentTimeMillis()); // Inicializa fechaRegistro al momento actual
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        if (correo != null && correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            this.correo = correo;
        } else {
            throw new IllegalArgumentException("El correo electrónico no es válido.");
        }
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        if (dni != null && dni.matches("\\d{8}")) {
            this.dni = dni;
        } else {
            throw new IllegalArgumentException("El DNI no es válido. Debe tener 8 dígitos.");
        }
    }

    public String getContraseña() {
        return contraseña;
    }

    public void setContraseña(String contraseña) {
        if (contraseña == null || contraseña.isEmpty()) {
            throw new IllegalArgumentException("La contraseña no puede estar vacía.");
        }
        this.contraseña = PasswordUtils.hashPassword(contraseña); // Hasheado de contraseña utilizando PasswordUtils
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        if (rol == null || (!rol.equals("admin") && !rol.equals("doctor") && !rol.equals("usuario"))) {
            throw new IllegalArgumentException("El rol no es válido. Los roles permitidos son: admin, doctor, usuario.");
        }
        this.rol = rol;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        if (telefono != null && !telefono.matches("\\+?\\d{7,15}")) {
            throw new IllegalArgumentException("El número de teléfono no es válido.");
        }
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", correo='" + correo + '\'' +
                ", dni='" + dni + '\'' +
                ", rol='" + rol + '\'' +
                ", telefono='" + telefono + '\'' +
                ", direccion='" + direccion + '\'' +
                ", fechaRegistro=" + fechaRegistro +
                '}';
    }
}
