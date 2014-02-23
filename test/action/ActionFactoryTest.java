package action;

import action.*;
import org.junit.*;
import java.util.*;

public class ActionFactoryTest {
	
	private static Collection<String> actions;

	@Test(expected = NullPointerException.class)
	public void nullTest() throws Exception {
		ActionFactory.getInstance().build(null);
	}

	@Test(expected = WrongCommandException.class)
	public void wrongCommandTest() throws Exception {
		ActionFactory.getInstance().build("zzzzzzzzzzzzzzzzzz");
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
}