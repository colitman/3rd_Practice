package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
	
	private static final SessionFactory sessionFactory = newSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() throws Exception {
		Configuration conf = new Counfiguration().confige("res/hibernate.cfg.xml");
		StandartServiceRegistryBuilder builder = new StandartServiceRegistryBuilder().applySettings(conf.getProperties());
		return conf.buildSessionFactory(builder.build());
	}
}