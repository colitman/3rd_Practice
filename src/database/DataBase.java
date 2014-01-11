package database;

import java.util.*
import javax.sql.*;

public interface DataBase {

	public Connection connect(String driver, String url, String username, String password) throws SQLException;
	public List<Map<String, <T extends Object>>> getAll() throws SQLException;
	public Map<String, <T extends Object>> get(int id) throws SQLException;
	public void remove(int id) throws SQLException;
	public void add(Object... args) throws SQLException;
	public void modify(Object... args) throws SQLException;
	public List<Integer> getAllIds() throws SQLException;
}