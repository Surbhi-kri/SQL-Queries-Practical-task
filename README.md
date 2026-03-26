# JDBC Statement vs PreparedStatement (SQL Injection Demo)

## 📌 Project Overview

This project demonstrates how Java connects to a PostgreSQL database using **JDBC** and explains the difference between **Statement** and **PreparedStatement**.

It also includes a real-world demonstration of **SQL Injection vulnerability** and how it can be prevented using PreparedStatement.

---

## 🎯 Objectives

* Establish database connection using JDBC
* Perform operations using Statement and PreparedStatement
* Understand SQL Injection vulnerability
* Prevent SQL Injection using parameterized queries

---

## 🚀 Technologies Used

* Java
* JDBC
* PostgreSQL
* Maven
* Docker

---

## 🐳 Database Setup (Docker)

```env
POSTGRES_USER=sqluser
POSTGRES_PASSWORD=sqlpassword
POSTGRES_DB=sqldatabase
POSTGRES_PORT=5433
```

---

## ⚙️ JDBC Connection

```java
Connection con = DriverManager.getConnection(
    "jdbc:postgresql://localhost:5433/sqldatabase",
    "sqluser",
    "sqlpassword"
);
```

---

## 📂 Database Tables

### Login Table

```sql
CREATE TABLE login (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50)
);
```

### People Table

```sql
CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
```

---

## 🧪 Operations Performed

### ✔ Using Statement

* Create table
* Insert data
* Fetch data

```java
Statement stmt = con.createStatement();
stmt.executeUpdate("INSERT INTO login VALUES('admin','admin123')");
```

---

### ✔ Using PreparedStatement

* Insert data securely
* Prevent SQL injection

```java
PreparedStatement ps = con.prepareStatement(
    "INSERT INTO login(username, password) VALUES(?, ?)"
);

ps.setString(1, "Surbhi");
ps.setString(2, "surbhi123");
ps.executeUpdate();
```

---

## ⚠️ SQL Injection Demonstration

### 🔴 Using Statement (Vulnerable)

```java
String input = "' OR '1'='1";
String query = "SELECT * FROM login WHERE username='" + input + "'";
ResultSet rs = stmt.executeQuery(query);
```

👉 This makes the condition always true → unauthorized access.

---

### 🟢 Using PreparedStatement (Secure)

```java
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM login WHERE username = ?"
);

ps.setString(1, "' OR '1'='1");
ResultSet rs = ps.executeQuery();
```

👉 Input is treated as data → SQL Injection prevented.

---
## 🔍 Detailed Difference Between Statement and PreparedStatement

### 1. Query Creation
- **Statement:** SQL query is created by directly concatenating values into the query string.
- **PreparedStatement:** SQL query is pre-written with placeholders (`?`) and values are set later.

---

### 2. Security
- **Statement:** Vulnerable to SQL Injection because user input is directly included in the query.
- **PreparedStatement:** Prevents SQL Injection by treating user input as data, not executable SQL.

---

### 3. Performance
- **Statement:** Query is compiled every time it is executed → slower.
- **PreparedStatement:** Query is precompiled once → faster for repeated execution.

---

### 4. Readability & Maintainability
- **Statement:** Harder to read and maintain when queries become complex.
- **PreparedStatement:** Cleaner and easier to maintain due to parameterized queries.

---

### 5. Reusability
- **Statement:** Cannot reuse query efficiently.
- **PreparedStatement:** Can reuse the same query with different values.

---

### 6. Execution Type
- **Statement:** Suitable for static queries.
- **PreparedStatement:** Suitable for dynamic queries with user input.

---



## 🔍 Difference Between Statement and PreparedStatement

| Feature       | Statement    | PreparedStatement |
| ------------- | ------------ | ----------------- |
| Query Type    | Static       | Parameterized     |
| Security      | ❌ Vulnerable | ✅ Safe            |
| Performance   | Slower       | Faster            |
| SQL Injection | Possible     | Prevented         |
| Reusability   | ❌ No         | ✅ Yes             |

---

## ▶️ How to Run the Project

1. Start PostgreSQL using Docker:

```
docker compose up -d
```

2. Build the project:

```
mvn clean install
```

3. Run the application:

```
mvn exec:java -Dexec.mainClass="org.example.App"
```

---

## 🖥️ Sample Output

```
Login table created!
Data inserted!
Inserted using PreparedStatement!
insert the new name

Surbhi

Login Successful (HACKED ❌)
Login Failed (SAFE ✅)
```

---

## 📁 Project Structure

```
src/
 └── main/
     └── java/
         └── org/example/
             └── App.java
```

---

## 🎯 Key Learnings

* JDBC enables Java applications to interact with databases
* Statement is simple but vulnerable to SQL Injection
* PreparedStatement improves performance and security
* SQL Injection is a serious vulnerability in applications
* Parameterized queries prevent SQL Injection

---

## 🏁 Conclusion

This project demonstrates:

* JDBC database connectivity
* Practical difference between Statement and PreparedStatement
* Real-world SQL Injection attack
* Secure coding practices using PreparedStatement

👉 **PreparedStatement should always be preferred for handling user input in real-world applications.**

---

## 👩‍💻 Author

**Surbhi Kumari**
 | Java Intern 
