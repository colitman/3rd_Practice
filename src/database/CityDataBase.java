package database;

import java.util.*;
import java.sql.*;

public class CityDataBase extends AbstractDataBase {

	private Connection conn;
		
	public CityDataBase(String driver, String sql, String username, String password) {
		conn = connect(driver, sql, username, password);
	}

	@Override
	public String getDatabaseName() {
		return "City";
	}

	@Override
	public List<String> getDatabaseFields() {
		List<String> list = new List<String>();
		list.add("PARENT_ID");
		list.add("ID");
		list.add("NAME");
		list.add("POPULATION");
		list.add("SQUARE");
		return list;
	}
}