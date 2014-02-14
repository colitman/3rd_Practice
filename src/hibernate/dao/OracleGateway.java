package hibernate.dao;

import hibernate.util.*;
import hibernate.logic.*;
import java.sql.*;
import java.util.*;
import java.lang.reflect.*;
import org.hibernate.*;
import org.hibernate.criterion.*;
import org.apache.log4j.*;
import org.springframework.stereotype.Service;
import java.lang.InstantiationException;

@Service
public class OracleGateway<T> implements Gateway<T> {
	
	private static final Logger logger = Logger.getLogger(OracleGateway.class);	
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

	public void modify(T entity) throws SQLException {
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
	public T get(Class className, int id) throws SQLException {
		T entity = null;
		try {
			entity = (T) className.newInstance();
			setSession();
			session.load(entity, id);
		}
		catch (Exception e) {
			logger.error("Exception occured in OracleGateway", e);
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

	public Collection<T> getAllBy(Class childClass, int parentID) throws SQLException {
		List<T> entities = new ArrayList<T>();
		try {
			setSession();
			entities = session.createCriteria(childClass).add(Expression.eq("parentID", parentID)).list();
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
		logger.info("Setting session");
		session = HibernateUtil.getSessionFactory().openSession();
	}

	private void closeSession() {
		logger.info("Closing session");
		if (session != null && session.isOpen()) {
			session.close();
		}
	}

	private void  beginTransaction() {
		logger.info("Starting transaction");
		session.beginTransaction();
	}

	private void commit() {
		logger.info("Commiting");
		session.getTransaction().commit();
	}
}