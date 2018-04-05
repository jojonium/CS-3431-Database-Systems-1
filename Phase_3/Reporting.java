// Database Systems I: Phase 3 - Joseph Petitti and Nick Pingal

import java.sql.*;
import java.util.Scanner;


/* ++++++++++++++++++++++++++++++++++++++++++++++
  Make sure you did the following before execution
     1) Log in to CCC machine using your WPI account

     2) Set environment variables using the following command
       > source /cs/bin/oracle-setup

     3- Set CLASSPATH for java using the following command
       > export CLASSPATH=./:/usr/local/oracle11gr203/product/11.2.0/db_1/jdbc/lib/ojdbc6.jar

     4- Write your java code (say file name is OracleTest.java) and then compile it using the  following command
       > /usr/local/bin/javac OracleTest.java

     5- Run it
        > /usr/local/bin/java OracleTest
  ++++++++++++++++++++++++++++++++++++++++++++++  */


public class Reporting {

    public static void main(String[] argv) {

        System.out.println("-------- Step 1: Registering Oracle Driver ------");
        try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Oracle JDBC Driver? Did you follow the execution steps. ");
            System.out.println("");
            System.out.println("*****Open the file and read the comments in the beginning of the file****");
            System.out.println("");
            e.printStackTrace();
            return;
        }

        System.out.println("Oracle JDBC Driver Registered Successfully ! ");
		
		if (argv.length < 2) {
			System.out.println("Reporting <username> <password>");
			return;
		} else if (argv.length < 3) {
			System.out.println("1- Report Patients Basic Information\n"
				+ "2- Report Doctors Basic Information\n"
				+ "3- Report Admissions Information\n"
				+ "4- Update Admissions Payment");
			return;
		}	
		
		System.out.println("-------- Step 2: Building a Connection ------");
        Connection connection = null;
		
        try {
            connection = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", argv[0], argv[1]);
        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        }

        if (connection != null) {
            System.out.println("You made it. Connection is successful. Take control of your database now!");
        } else {
            System.out.println("Failed to make connection!");
        }
		
		// Create an empty statement
		Statement stmt = null;
		try {
			stmt = connection.createStatement();
		} catch (SQLException e) {
			System.out.println("Error in creating empty statement");
			e.printStackTrace();
			return;
		}
		
		
		Scanner uinput = new Scanner(System.in);
		int temp;
		if (argv[2].equals("1")) {
			System.out.print("Enter Patient SSN: ");
			temp = uinput.nextInt();
			try {
				ResultSet rset = stmt.executeQuery("SELECT * FROM Patient WHERE SSN=" + temp);
				rset.next();
				System.out.println("Patient SSN: " + rset.getInt("SSN"));
				System.out.println("Patient First Name: " + rset.getString("pFName"));
				System.out.println("Patient Last Name: " + rset.getString("pLName"));
				System.out.println("Patient Address: " + rset.getString("Address"));
				rset.close();
			} catch (SQLException e) {
				System.out.println("Error in querying database");
				e.printStackTrace();
				return;
			}
		} else if (argv[2].equals("2")) {
			System.out.print("Enter Doctor ID: ");
			temp = uinput.nextInt();
			try {
				ResultSet rset = stmt.executeQuery("SELECT * FROM Doctor WHERE dID=" + temp);
				rset.next();
				System.out.println("Doctor ID: " + rset.getInt("dID"));
				System.out.println("Doctor First Name: " + rset.getString("dFName"));
				System.out.println("Doctor Last Name: " + rset.getString("dLName"));
				System.out.println("Doctor Gender: " + rset.getString("Gender"));
				rset.close();
			} catch (SQLException e) {
				System.out.println("Error in querying database");
				e.printStackTrace();
				return;
			}
		} else if (argv[2].equals("3")) {
			System.out.print("Enter Admission Number: ");
			temp = uinput.nextInt();
			try {
				ResultSet rset = stmt.executeQuery("SELECT * FROM Admission WHERE AdmissionNum=" + temp);
				rset.next();
				System.out.println("Admission Number: " + rset.getInt("AdmissionNum"));
				System.out.println("Patient SSN: " + rset.getString("SSN"));
				System.out.println("Admission date (start date): " + rset.getDate("AdmissionDate"));
				System.out.println("Total Payment: " + rset.getFloat("TotalPayment"));
				
				rset = stmt.executeQuery("SELECT RoomNum, StartDate, EndDate FROM StayIn WHERE AdmissionNum=" + temp);
				System.out.println("Rooms:");
				while(rset.next()) {
					System.out.println("\tRoomNum: " + rset.getInt("RoomNum") 
						+ "\tFromDate: " + rset.getDate("StartDate")
						+ "\tToDate: " + rset.getDate("EndDate"));
				}
				
				rset = stmt.executeQuery("SELECT DISTINCT dID FROM Examine WHERE AdmissionNum=" + temp);
				System.out.println("Doctors examined the patient in this admission:");
				while(rset.next()) {
					System.out.println("\tDoctor ID: " + rset.getInt("dID"));
				}
			} catch (SQLException e) {
				System.out.println("Error in querying database");
				e.printStackTrace();
				return;
			} 
		} else if (argv[2].equals("4")) {
			try {
				System.out.print("Enter Admission Num: ");
				temp = uinput.nextInt();
				System.out.print("Enter the new total payment: ");
				float newPayment = uinput.nextFloat();
				stmt.executeUpdate("UPDATE Admission SET TotalPayment=" + newPayment + " WHERE AdmissionNum=" + temp);
				System.out.println("Admission Number " + temp + " Updated");
			} catch (SQLException e) {
				System.out.println("Error in querying database");
				e.printStackTrace();
				return;
			}
		}
		
		try {
			stmt.close();
			System.out.println("-------- Statement closed --------");
			connection.close();
			System.out.println("-------- Connection closed --------");
		} catch (SQLException e) {
			System.out.println("Error in closing statement and connection");
			e.printStackTrace();
			return;
		}
		
		
    }

}
