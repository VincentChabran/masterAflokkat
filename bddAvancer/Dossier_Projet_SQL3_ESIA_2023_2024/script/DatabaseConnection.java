package script;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    private static final String URL = "jdbc:oracle:thin:@129.151.234.184:1521/PDBBIHAR.sub12051533510.vcnmiageuca.oraclevcn.com";
    private static final String USER = "CHABRANES2324";
    private static final String PASSWORD = "CHABRANES232401";

    public static Connection getConnection() throws SQLException {
        System.out.println("Avant connection Bdd");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
