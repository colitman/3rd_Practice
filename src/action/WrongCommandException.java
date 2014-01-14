package action;

/**
 * Throws when wrong command occurs
 */
public class WrongCommandException extends Exception {
	private static final long serialVersionUID = 759715116745946L;

	public WrongCommandException() {
		// TODO Auto-generated constructor stub
	}

	public WrongCommandException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public WrongCommandException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	public WrongCommandException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

	public WrongCommandException(String message, Throwable cause,
			boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
		// TODO Auto-generated constructor stub
	}

}
