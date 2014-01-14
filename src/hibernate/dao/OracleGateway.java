package hibernate.dao;

import hibernate.util.*;
import hibernate.logic.*;
import java.sql.*;
import java.util.*;
import org.hibernate.*;

public class OracleGateway<T> implements Gateway<T> {
	
	@Override
	public void add(T entity) throws SQLException {
		Session session = null;
		try {
			session = getSession();
			session.beginTransaction();
			session.save(entity);
			session.getTransaction().commit();
		}
		finally {
			closeSession(session);
		}
	}

	public void modify(int id, T entity) throws SQLException {
		Session session = null;
		try {
			session = getSession();
			session.beginTransaction();
			session.update(entity);
			session.getTransaction().commit();
		}
 		finally {
			closeSession(session);
		}
	}
	public T get(int id) throws SQLException {
		Session session = null;
		T entity = null;
		try {
			session = getSession();
			entity = (T) session.load(T.class, id);
		}
 		finally {
			closeSession(session);
		}
		return entity;
	}
	public Collection<T> getAll() throws SQLException {
		Session session = null;
		List<T> entities = new ArrayList<T>();
		try {
			session = getSession();
			entities = session.createCriteria(T.class).list();
		}
 		finally {
			closeSession(session);
		}
		return entities;
	}

	public void remove(T entity) throws SQLException {
		Session session = null;
		try {
			session = getSession();
			session.beginTransaction();
			session.delete(entity);
			session.getTransaction().commit();
		}
 		finally {
			closeSession(session);
		}
	}

	private Session getSession() {
		return HibernateUtil.getSessionFactory().openSession();
	}

	private void closeSession(Session session) {
		if (session != null && session.isOpen()) {
			session.close();
		}
	}
}