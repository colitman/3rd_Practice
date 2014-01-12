package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
	
	private static final SessionFactory sessionFactory = newSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() throws Exception {
		return new Configuration().configure().buildSessionFactory();
	}
}