package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;
import org.hibernate.service.*;

/**
*Utils
*/

public class HibernateUtil {
	
	private static final SessionFactory sessionFactory = newSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() { 
		try {
			Configuration conf = new Configuration().configure("res/hibernate.cfg.xml");
			ServiceRegistryBuilder builder = new ServiceRegistryBuilder().applySettings(conf.getProperties());
			return conf.buildSessionFactory(builder.build());
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}