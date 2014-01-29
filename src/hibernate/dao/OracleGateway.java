package hibernate.dao;

import hibernate.util.*;
import hibernate.logic.*;
import java.sql.*;
import java.util.*;
import java.lang.reflect.*;
import org.hibernate.*;
import org.springframework.stereotype.Service;

@Service
public class OracleGateway<T> implements Gateway<T> {
	
	private Session session;

	@Override
	public void add(T entity) throws SQLException {
		try {
			setSession();
			beginTransaction();
			session.save(entity);
			commit();
		}
		finally {
			closeSession();
		}
	}

	public void modify(int id, T entity) throws SQLException {
		try {
			setSession();
			beginTransaction();
			session.update(entity);
			commit();
		}
 		finally {
			closeSession();
		}
	}
	public T get(int id) throws SQLException {
		T entity = null;
		try {
			setSession();
			session.load(entity, id);
		}
 		finally {
			closeSession();
		}
		return entity;
	}
	public Collection<T> getAll(Class className) throws SQLException {
		List<T> entities = new ArrayList<T>();
		try {
			setSession();
			entities = session.createCriteria(className).list();
		}
 		finally {
			closeSession();
		}
		return entities;
	}

	public void remove(T entity) throws SQLException {
		try {
			setSession();
			beginTransaction();
			session.delete(entity);
			commit();
		}
 		finally {
			closeSession();
		}
	}

	private void setSession() {
		session = HibernateUtil.getSessionFactory().openSession();
	}

	private void closeSession() {
		if (session != null && session.isOpen()) {
			session.close();
		}
	}

	private void  beginTransaction() {
		session.beginTransaction();
	}

	private void commit() {
		session.getTransaction().commit();
	}
}