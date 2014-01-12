package database;

import java.util.*;
import java.sql.*;

public interface DataBase {

	public Connection connect(String driver, String url, String username, String password) throws SQLException, ClassNotFoundException;
	public List<Map<String, Object>> getAll() throws SQLException;
	public Map<String, Object> get(int id) throws SQLException;
	public void remove(int id) throws SQLException;
	public void add(Object... args) throws SQLException;
	public void modify(Object... args) throws SQLException;
	public List<Integer> getAllIds() throws SQLException;
}