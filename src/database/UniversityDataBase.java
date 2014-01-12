package database;

import java.util.*;
import java.sql.*;

public class UniversityDataBase extends AbstractDataBase {

	private Connection conn;
		
	public UniversityDataBase(String driver, String sql, String username, String password) {
		conn = connect(driver, sql, username, password);
	}

	@Override
	public String getDatabaseName() {
		return "University";
	}

	@Override
	public List<String> getDatabaseFields() {
		List<String> list = new List<String>();
		list.add("PARENT_ID");
		list.add("ID");
		list.add("NAME");
		list.add("DEPARTAMENTS_COUNT");
		list.add("WWW");
		return list;
	}
}