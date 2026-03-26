package org.example;
import java.sql.*;


/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        String url = "jdbc:postgresql://localhost:5433/sqldatabase";
        String username = "sqluser";
        String password = "sqlpassword";

        try {
           // Class.forName("org.postgresql.Driver");

            Connection con = DriverManager.getConnection(url, username, password);
           // System.out.println("Connected successfully!");
            Statement stmt = con.createStatement();

            // create the login table
            String createTable = "CREATE TABLE IF NOT EXISTS login (" +
                    "id SERIAL PRIMARY KEY, " +
                    "username VARCHAR(50), " +
                    "password VARCHAR(50))";

            stmt.executeUpdate(createTable);
            System.out.println("Login table created!");

            // delete the value from the table before running the program
            stmt.executeUpdate("DELETE FROM login");
            // insert the value into the table
            stmt.executeUpdate("INSERT INTO login(username, password)" +
                    "VALUES('admin','admin123')");

            stmt.executeUpdate("INSERT INTO login(username, password)" +
                    "VALUES('user','user123')");

System.out.println("Data inserted!");

//stmt.executeUpdate("DELETE FROM people");
         // perform prepared Statements
       String q="INSERT INTO login(username, password) VALUES(?,?)";

       PreparedStatement pstmt= con.prepareStatement(q);

       pstmt.setString(1,"Surbhi");
       pstmt.setString(2,"surbhi123");

       pstmt.executeUpdate();
       System.out.println("inserted..");

       // perform prepared statement to insert the value into people table
       String a="INSERT INTO people(first_name,last_name) VALUES(?,?)";

       PreparedStatement pt=con.prepareStatement(a);

       pt.setString(1,"Surbhi");
       pt.setString(2,"Gupta");

       pt.executeUpdate();
            System.out.println("insert the new name");

       // print the all members from the people table
            ResultSet rs=stmt.executeQuery("SELECT * FROM people");
            while(rs.next())
            {
                System.out.println(rs.getString("first_name"));
            }


// performing  SQL injection

            // statement
            String input = "' OR '1'='1";
            String query="SELECT * FROM login WHERE username='" + input + "'";
            ResultSet r1=stmt.executeQuery(query);

            if(r1.next())
                System.out.println("Login Successful and it is hacked");

        // prepared statement
            String input2 = "' OR '1'='1";

            String query2="SELECT * FROM login WHERE username=?";
            PreparedStatement PS=con.prepareStatement(query2);
            PS.setString(1,input2);
            ResultSet r2= PS.executeQuery();
            if(r2.next())
            {
                System.out.println("Login Successful");
            } else {
                System.out.println("Login Failed and it is safe");
            }
            con.close();

        }
        catch(Exception e)
        {
            e.printStackTrace();
        }


    }
}
