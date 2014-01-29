package hibernate.util;

import org.hibernate.*;
import org.hibernate.cfg.*;
import org.hibernate.service.*;
import java.util.Locale;
import java.io.File;

/**
*Utils
*/

public class HibernateUtil {
	
	private static SessionFactory sessionFactory;

	public static SessionFactory getSessionFactory() {
		if (sessionFactory == null) {
			sessionFactory = newSessionFactory();
		}
		return sessionFactory;
	}

	private static SessionFactory newSessionFactory() { 
		try {	
			Locale.setDefault(Locale.ENGLISH);
			//AnnotationConfiguration config  = new AnnotationConfiguration();
			//config.addAnnotatedClass(hibernate.logic.Country.class);
			//config.addAnnotatedClass(hibernate.logic.Region.class);
			//config.addAnnotatedClass(hibernate.logic.City.class);
			//config.addAnnotatedClass(hibernate.logic.University.class);
			//config.configure();
			Configuration conf = new Configuration().configure(new File("C:/Workspace/LAB3/Mego_Portal_XD/res/hibernate.cfg.xml"));
			ServiceRegistryBuilder builder = new ServiceRegistryBuilder().applySettings(conf.getProperties());
			return conf.buildSessionFactory(builder.buildServiceRegistry());
			//return config.buildSessionFactory();
		}
		catch (Exception e) {
			System.out.println("ERROR:");
			e.printStackTrace();
		}
		return null;
	}
}