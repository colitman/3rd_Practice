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

@Service
public class OracleGateway<T> implements Gateway<T> {
	
	private static final Logger logger = Logger.getLogger("logger");	
	private Session session;

	@Override
	public void add(T entity) throws SQLException {
		try {
			logger.info("Adding some entity");
			
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
			logger.info("Modifing some entity");
	
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
		logger.info("Getting some entity");

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
		logger.info("Getting collection of entity");

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
		logger.info("Getting collection of entity where parent id = " + parentID);
		
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
			logger.info("Removing some entity");
		
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