package database;

import java.util.*;
import java.sql.*;

public abstract class AbstractDataBase implements DataBase {
		
	protected Connection conn;	

	public abstract String getDatabaseName();
	public abstract List<String> getDatabaseFields();	

	public Connection connect(String driver, String url, String username, String password) throws SQLException, ClassNotFoundException {
		Locale.setDefault(Locale.ENGLISH);
		Class.forName(driver);
		return DriverManager.getConnection(url, username, password);
	}

	public List<Map<String, Object>> getAll() throws SQLException {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();	
		String query = "SELECT * FROM " + getDatabaseName();
		PreparedStatement ps = conn.prepareStatement(query);
		ResultSet res = ps.executeQuery();
		while (res.next()) {
			Map<String, Object> entity = new HashMap<String, Object>();
			List<String> fields = getDatabaseFields();
			for (int i = 0; i < fields.size(); i++) {
				Object value = recognize(res, i);
				entity.put(fields.get(i), value);
			}
			list.add(entity);
		}
		res.close();
		ps.close();
		return list;
	}

	public Map<String, Object> get(int id) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		String query = "SELECT * FROM " + getDatabaseName() + "Country WHERE id = ?";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ResultSet res = ps.executeQuery();
		res.next();
		List<String> fields = getDatabaseFields();
		for (int i = 0; i < fields.size(); i++) {
			Object value = recognize(res, i);
			map.put(fields.get(i), value);
		}
		res.close();
		ps.close();
		return map;
	}

	public void remove(int id) throws SQLException {
		String query = "DELETE FROM " + getDatabaseName() + " WHERE id = ?";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ps.execute();
		ps.close();
	}
	
	public void add(Object... args) throws SQLException {
		//--wrong
		String query = "INSERT INTO " + getDatabaseName() + " VALUES (?, ?, ?, ?, ?)";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ps.setString(2, name);
		ps.setString(3, language);
		ps.setInt(4, population);
		ps.setInt(5, timezone);
		ps.execute();
		ps.close();
	}

	public void modify(Object... args) throws SQLException {
		//--wrong
		Integer id = args[0];
		String name = args[1];
		String language = args[2];
		Integer population = args[3];
 		Integer timezone = args[4];

		String query = "SELECT * FROM " + getDatabaseName() + " WHERE id = ?";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ResultSet res = ps.executeQuery();
		res.next();
		res.updateString(2, name);
		res.updateString(3, language);
		res.updateInt(4, population);
		res.updateInt(5, timezone);
		res.close();
		ps.close();
	}

	public List<Integer> getAllIds() throws SQLException {
		List<Integer> ids = new ArrayList<Integer>();
		String query = "SELECT id FROM " + getDatabaseName();
		PreparedStatement ps = conn.prepareStatement(query);
		ResultSet res = ps.executeQuery();
		while (res.next) {
			ids.add(res.getInt(1));
		}
		res.close();
		ps.close();
		return ids;
	}
	
	private Object getFrom(ResultSet res, int i) {
		Object value = null;
		List<String> fields = getDatabaseFields();
		switch (fields.get(i)) {
			case "ID" : value = res.getInt(i + 1); break;
			case "PARENT_ID" : value = res.getInt(i + 1); break;
			case "NAME" : value = res.getString(i + 1); break;
			case "LANGUAGE" : value = res.getString(i + 1); break;
			case "POPULATION" : value = res.getInt(i + 1); break;
			case "TIMEZONE" : value = res.getInt(i + 1); break;
			case "SQUARE" : value = res.getInt(i + 1); break;
			case "DEPARTAMENTS_COUNT" : value = res.getString(i + 1); break;
			case "WWW" : value = res.getString(i + 1); break;
			default : value = null;
		}
		return value;
	}
	
	private void setTo(PreparedStatement ps, int i, Object value) {
		//--wrong
		Object value = null;
		List<String> fields = getDatabaseFields();
		switch (fields.get(i)) {
			case "ID" : value = res.getInt(i + 1); break;
			case "PARENT_ID" : value = res.getInt(i + 1); break;
			case "NAME" : value = res.getString(i + 1); break;
			case "LANGUAGE" : value = res.getString(i + 1); break;
			case "POPULATION" : value = res.getInt(i + 1); break;
			case "TIMEZONE" : value = res.getInt(i + 1); break;
			case "SQUARE" : value = res.getInt(i + 1); break;
			case "DEPARTAMENTS_COUNT" : value = res.getString(i + 1); break;
			case "WWW" : value = res.getString(i + 1); break;
			default : value = null;
		}
		
	}
}