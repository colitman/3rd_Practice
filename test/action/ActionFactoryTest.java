package action;

import static org.junit.Assert.*;
import action.*;
import org.junit.*;
import java.util.*;
import java.io.*;


public class ActionFactoryTest {
	
	private static Collection<String> actions;

	@Test(expected = WrongCommandException.class)
	public void nullTest() throws Exception {
		ActionFactory.getInstance().build(null);
	}

	@Test(expected = WrongCommandException.class)
	public void wrongCommandTest() throws WrongCommandException {
		try {
			ActionFactory.getInstance().build("zzzzzzzzzzzzzzzzzz");
		}
		catch (WrongCommandException e) {
			throw new WrongCommandException(e);
		}
		catch (Exception ex) {
			fail("Unexpected exception : " + getStackTrace(ex));
		}
	}

	@Test
	public void buildTest() throws Exception {
		for (String command : actions) {
			ActionFactory.getInstance().build(command);
		}
	}

	@BeforeClass
	public static void init() {
		actions = new ArrayList<String>();

		actions.add("addCity");
		actions.add("removeCity");
		actions.add("modifyCity");
		actions.add("showAllCityInRegion");
		
		actions.add("addRegion");
		actions.add("removeRegion");
		actions.add("modifyRegion");
		actions.add("showAllRegionInCountry");
		
		actions.add("addUniversity");
		actions.add("removeUniversity");
		actions.add("modifyUniversity");
		actions.add("showAllUniversityInCity");

		actions.add("addCountry");
		actions.add("removeCountry");
		actions.add("modifyCountry");
		actions.add("showAllCountry");
	}

	@AfterClass
	public static void deinit() {
		actions = null;
	}
	
	private static String getStackTrace(Throwable t) {
    		StringWriter sw = new StringWriter();
    		PrintWriter pw = new PrintWriter(sw, true);
    		t.printStackTrace(pw);
    		pw.flush();
    		sw.flush();
    		return sw.toString();
	}
}