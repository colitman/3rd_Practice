package database;

import java.util.*;
import java.sql.*;

public class CountryDataBase extends AbstractDataBase {

	private Connection conn;
		
	public CountryDataBase(String driver, String sql, String username, String password) {
		conn = connect(driver, sql, username, password);
	}

	@Override
	public String getDatabaseName() {
		return "Country";
	}
	
	@Override
	public List<String> getDatabaseFields() {
		List<String> list = new List<String>();
		list.add("ID");
		list.add("NAME");
		list.add("LANGUAGE");
		list.add("POPULATION");
		list.add("TIMEZONE");
		return list;
	}
}