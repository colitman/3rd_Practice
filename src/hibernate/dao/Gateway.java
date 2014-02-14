package hibernate.dao;

import hibernate.logic.*;
import java.sql.*;
import java.util.*;

public interface Gateway<T> {
	
	public void add(T entity) throws SQLException;
	public void modify(T entity) throws SQLException;
	public T get(Class className, int id) throws SQLException;
	public Collection<T> getAll(Class className) throws SQLException;
	public Collection<T> getAllBy(Class className, int parentID) throws SQLException;
	public void remove(T entity) throws SQLException;
}