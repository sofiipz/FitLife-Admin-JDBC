import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Scanner;

public class Principal {
    private static final String URL_MYSQL = "jdbc:mysql://localhost:3306/FitLife";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static void main(String[] args) {
        Scanner entrada = new Scanner(System.in);

        try {
            // Conexión a la base de datos
            Connection dbConn = DriverManager.getConnection(URL_MYSQL, USER, PASSWORD);

            while (true) {
                System.out.println("---- M E N Ú  A D M I N I S T R A T I V O ----");
                System.out.println("1. Ver tablas en la base de datos");
                System.out.println("2. Agregar un nuevo socio");
                System.out.println("3. Salir");
                System.out.print("Elige una opción: ");
                int opcion = entrada.nextInt();
                entrada.nextLine();

                if (opcion == 1) {
                    mostrarTablas(dbConn);
                } else if (opcion == 2) {
                    agregarSocio(dbConn, entrada);
                } else if (opcion == 3) {
                    System.out.println("Saliendo del programa...");
                    break;
                } else {
                    System.out.println("E R R O R: Opción no válida.");
                }
            }


            dbConn.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entrada.close();
        }
    }

    // Método para mostrar las tablas de la base de datos
    public static void mostrarTablas(Connection dbConn) {
        try {
            String query = "SHOW TABLES";
            PreparedStatement pstmt = dbConn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();

            System.out.println("Tablas en la base de datos:");
            while (rs.next()) {
                System.out.println("- " + rs.getString(1));
            }

            rs.close();
            pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void agregarSocio(Connection dbConn, Scanner scanner) {
        try {
            System.out.println("Agregar un nuevo socio:");

            System.out.print("DNI: ");
            String dni = scanner.nextLine();

            System.out.print("Nombre: ");
            String nombre = scanner.nextLine();

            System.out.print("Primer apellido: ");
            String primerApellido = scanner.nextLine();

            System.out.print("Segundo apellido: ");
            String segundoApellido = scanner.nextLine();
            if (segundoApellido.isEmpty()) {
                segundoApellido = null;
            }

            System.out.print("Teléfono: ");
            String telefono = scanner.nextLine();

            System.out.print("Email: ");
            String email = scanner.nextLine();



            System.out.print("Dirección: ");
            String direccion = scanner.nextLine();



            System.out.print("Fecha de inscripción (YYYY-MM-DD): ");
            String fechaInscripcion = scanner.nextLine();

            System.out.print("Estado (Activo/Inactivo): ");
            String estado = scanner.nextLine();



            String fechaInactivo = null;
            if (estado.equalsIgnoreCase("Inactivo")) {
                System.out.print("Fecha de inactividad (YYYY-MM-DD): ");
                fechaInactivo = scanner.nextLine();
            }


            System.out.print("ID del plan de pago (1: Básico, 2: Premium, 3: Familiar): ");
            int idPlan = scanner.nextInt();
            scanner.nextLine();

            // insertar elos datos en la base de datos
            String sql = "INSERT INTO socios (dni, nombre, primer_apellido, segundo_apellido, telefono, email, direccion, fecha_inscripcion, estado, fecha_inactivo, id_plan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement pstmt = dbConn.prepareStatement(sql);
            pstmt.setString(1, dni);
            pstmt.setString(2, nombre);
            pstmt.setString(3, primerApellido);
            pstmt.setString(4, segundoApellido);
            pstmt.setString(5, telefono);
            pstmt.setString(6, email);
            pstmt.setString(7, direccion);
            pstmt.setString(8, fechaInscripcion);
            pstmt.setString(9, estado);
            pstmt.setString(10, fechaInactivo);
            pstmt.setInt(11, idPlan);



            int filasInsertadas = pstmt.executeUpdate();
            if (filasInsertadas > 0) {
                System.out.println("Socio añadido correctamente");
            }



            pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
