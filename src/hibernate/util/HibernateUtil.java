package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
	
	private static final SessionFactory sessionFactory = newSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() throws Exception {
		Configuration configuration = new Configuration().configure();
		StandardServiceRegistryBuilder builder = new StandardServiceRegistryBuilder().applySettings(configuration.getProperties());
		return configuration.buildSessionFactory(builder.build());
	}
}