package util;

import java.util.*;
import hibernate.dao.*;
import java.sql.*;

public class ListGateway<T> implements Gateway<T> {
	
	private List<T> list = new ArrayList<T>();

	public void add(T entity) throws SQLException {
		list.add(entity);
	}

	public void modify(T entity) throws SQLException {
		if (!list.contains(entity)) {
			list.add(entity);
		} else {
			list.remove(entity);
			list.add(entity);
		}
	}	

	public T get(Class<T> className, int id) throws SQLException {
		//for (int i = 0;  i < size(); i++) {
		//	if (className.cast(list.get(i)).getID() == id) {
		//		return list.get(i);
		//	}
		//}
		return null;
	}

	public Collection<T> getAll(Class className) throws SQLException {
		return list;
	}

	public Collection<T> getAllBy(Class className, int parentID) throws SQLException {
		//Collection<T> collection = new ArrayList<T>();
		//for (int i = 0; i < size(); i++) {
		//	if (list.get(i).getParentID() == parentID) {
		//		collection.add(list.get(i));
		//	}
		//}
		//return collection;
		return null;
	}

	public void remove(T entity) throws SQLException {
		list.remove(entity);
	}

	public int size() {
		return list.size();
	}
}