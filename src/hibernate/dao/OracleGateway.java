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
			session.load(entity, id);
		}
 		finally {
			closeSession(session);
		}
		return entity;
	}
	public Collection<T> getAll() throws SQLException {
		Session session = null;
		class EntityList extends ArrayList<T> {}
		List<T> entities = new EntityList();
		try {
			session = getSession();
			String entityClass = getGenericParameterClass(entities.getClass(), 0);
			entities = session.createCriteria(entityClass).list();
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
	
	private String getGenericParameterClass(Class actualClass, int parameterIndex) {
		ParameterizedType type = (ParameterizedType) actualClass.getGenericSuperclass();
		//Class<T> param = (Class<T>) type.getActualTypeArguments()[parameterIndex];
		//System.out.println(type);
		//System.out.println(param);
		return new StringBuilder().append(type.getActualTypeArguments()[parameterIndex]).toString();
 	}
}