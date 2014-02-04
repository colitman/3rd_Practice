package hibernate.dao;

import hibernate.logic.*;
import java.sql.*;
import java.util.*;

public interface Gateway<T> {
	
	public void add(T entity) throws SQLException;
	public void modify(int id, T entity) throws SQLException;
	public T get(int id) throws SQLException;
	public Collection<T> getAll(Class className) throws SQLException;
	public Collection<T> getAllBy(Class className, OracleEntity parent) throws SQLException;
	public void remove(T entity) throws SQLException;
}