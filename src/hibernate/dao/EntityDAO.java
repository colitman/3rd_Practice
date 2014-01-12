package hibernate.dao;

import java.sql.*;
import java.util.*;

public interface EntityDAO<T> {
	
	public void add(T entity) throws SQLException;
	public void modify(int id, T entity) throws SQLException;
	public T get(int id) throws SQLException;
	public Collection<T> getAll() throws SQLException;
	public void remove(T entity) throws SQLException;
}