package util.gateway;

import java.util.*;
import java.sql.*;
import hibernate.dao.*;
import hibernate.logic.*;

public class CountryListGateway<T> implements Gateway<T> {
 
	private static int index = 1;
	private List<T> list = new ArrayList<T>();

	public void add(T entity) throws SQLException {
		((Country) entity).setID(index++);
		System.out.println(((Country) entity).getID());
		list.add(entity);
	}

	public void modify(T entity) throws SQLException {
		int id = ((Country) entity).getID();
		if (get(null, id) != null) {
			remove(get(null, id));
			add(entity);
		} else {
			add(entity);
		}
	}	

	public T get(Class<T> className, int id) throws SQLException {
		for (int i = 0;  i < size(); i++) {
			if (((Country) list.get(i)).getID() == id) {
				return list.get(i);
			}
		}
		return null;
	}

	public Collection<T> getAll(Class className) throws SQLException {
		return list;
	}

	public Collection<T> getAllBy(Class className, int parentID) throws SQLException {
		return getAll(className);
	}

	public void remove(T entity) throws SQLException {
		list.remove(entity);
	}

	public int size() {
		return list.size();
	}
}