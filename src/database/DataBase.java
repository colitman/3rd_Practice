package database;

import java.util.*
import javax.sql.*;

public abstract class AbstractDataBase {

	protected Connection connect(String driver, String url, String username, String password) throws SQLException, ClassNotFoundException {
		Locale.setDefault(Locale.ENGLISH);
		Class.forName(driver);
		return DriverManager.getConnection(url, username, password);
	}

	public abstract List<Map<String, <T extends Object>>> getAll() throws SQLException;
	public abstract Map<String, <T extends Object>> get(int id) throws SQLException;
	public abstract void remove(int id) throws SQLException;
	public abstract void add(Object... args) throws SQLException;
	public abstract void modify(Object... args) throws SQLException;
	public abstract List<Integer> getAllIds() throws SQLException;
}