package logger;

import org.apache.log4j.*;

public class LoggerUtils {
	
	public static void info(Logger logger, String... args) {
		if (logger.isInfoEnabled()) {
			StringBuilder str = new StringBuilder();
			for (int i = 0; i < args.length; i++) {
				str.append(args[i]);
				str.append(" ");
			}
			logger.info(str.toString());
		}
	}

}