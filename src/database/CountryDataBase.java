package database;

import java.util.*
import javax.sql.*;

public class CountryDataBase {

	private Connection conn;
		
	public CountryDataBase(String driver, String sql, String username, String password) {
		conn = connect(driver, sql, username, password);
	}

	public List<Map<String, <T extends Object>>> getAll() throws SQLException {
		List<Map<String, <T extends Object>>> list = new List<Map<String, <T extends Object>>>();	
		String query = "SELECT * FROM Country";
		PreparedStatement ps = conn.prepareStatement(query);
		ResultSet res = ps.executeQuery();
		while (res.next()) {
			Map<String, <T extends Object>>> entity = new Map<String, <T extends Object>>>();
			entity.put("ID", res.getInt(1));
			entity.put("NAME", res.getString(2));
			entity.put("LANGUAGE", res.getString(3));
			entity.put("POPULATION", res.getInt(4));
			entity.put("TIMEZONE", res.getInt(5));
			list.add(entity);
		}
		res.close();
		ps.close();
		return list;
	}

	public Map<String, <T extends Object>> get(int id) throws SQLException {
		Map<String, <T extends Object>> map = new Map<String, <T extends Object>>();
		String query = "SELECT * FROM Country WHERE id = ?";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ResultSet res = ps.executeQuery();
		res.next();
		map.put("ID", res.getInt(1));
		map.put("NAME", res.getString(2));
		map.put("LANGUAGE", res.getString(3));
		map.put("POPULATION", res.getInt(4));
		map.put("TIMEZONE", res.getInt(5));
		res.close();
		ps.close();
		return map;
	}

	public void remove(int id) throws SQLException {
		String query = "DELETE FROM Country WHERE id = ?";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ps.execute();
		ps.close();
	}
	
	public void add(Object... args) throws SQLException {
		String id = args[0];
		String name = args[1];
		String language = args[2];
		Integer population = args[3];
 		Integer timezone = args[4];
 	
		String query = "INSERT INTO Country VALUES (?, ?, ?, ?, ?)";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setInt(1, id);
		ps.setString(2, name);
		ps.setString(3, language);
		ps.setInteger(4, population);
		ps.setInteger(5, timezone);
		ps.execute();
		ps.close();
	}

	public void modify(Object... args) throws SQLException {
		String id = args[0];
		String name = args[1];
		String language = args[2];
		Integer population = args[3];
 		Integer timezone = args[4];

		String query = "SELECT * FROM Country WHERE id = ?";
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
		List<Integer> ids = new List<Integer>();
		String query = "SELECT id FROM Country";
		PreparedStatement ps = conn.prepareStatement(query);
		ResultSet res = ps.executeQuery();
		while (res.next) {
			ids.add(res.getInt(1));
		}
		res.close();
		ps.close();
		return ids;
	}
}