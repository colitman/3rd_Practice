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
			session = HibernateUtil.getSessionFactory().openSession();
			session.beginTransaction();
			session.save(entity);
			session.getTransaction().commit();
		}
		finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
	}

	public void modify(int id, T entity) throws SQLException {
		Session session = null;
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			session.beginTransaction();
			session.update(entity);
			session.getTransaction().commit();
		}
 		finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
	}
	public T get(int id) throws SQLException {
		Session session = null;
		T entity = null;
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			entity = (T) session.load(T.class, id);
		}
 		finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		return entity;
	}
	public Collection<T> getAll() throws SQLException {
		Session session = null;
		List<T> entities = new ArrayList<T>();
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			entities = session.createCriteria(T.class).list();
		}
 		finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		return entities;
	}

	public void remove(T entity) throws SQLException {
		Session session = null;
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			session.beginTransaction();
			session.delete(entity);
			session.getTransaction().commit();
		}
 		finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
	}
}