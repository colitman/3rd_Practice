package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
	
	private static final SessionFactory sessionFactory = newSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() throws Exception {
<<<<<<< HEAD
		Configuration conf = new Counfiguration().confige("res/hibernate.cfg.xml");
		StandartServiceRegistryBuilder builder = new StandartServiceRegistryBuilder().applySettings(conf.getProperties());
		return conf.buildSessionFactory(builder.build());
=======
		Configuration configuration = new Configuration().configure();
		StandardServiceRegistryBuilder builder = new StandardServiceRegistryBuilder().applySettings(configuration.getProperties());
		return configuration.buildSessionFactory(builder.build());
>>>>>>> d0a1eaf1ea3545625dc8f4eaed8123647a7d619c
	}
}