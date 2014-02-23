package action;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	action.handlers.city.AddCityTest.class,
	action.handlers.city.RemoveCityTest.class,
	action.handlers.city.ModifyCityTest.class,
	action.handlers.city.ShowAllCityInRegionTest.class,

	action.handlers.region.AddRegionTest.class,
	action.handlers.region.RemoveRegionTest.class,
	action.handlers.region.ModifyRegionTest.class,
	action.handlers.region.ShowAllRegionInCountryTest.class,

	action.handlers.university.AddUniversityTest.class,
	action.handlers.university.RemoveUniversityTest.class,
	action.handlers.university.ModifyUniversityTest.class,
	action.handlers.university.ShowAllUniversityInCityTest.class,
	action.handlers.university.ShowOneUniversityTest.class,

	action.handlers.country.AddCountryTest.class,
	action.handlers.country.RemoveCountryTest.class,
	action.handlers.country.ModifyCountryTest.class,
	action.handlers.country.ShowAllCountryTest.class,

	action.ActionFactoryTest.class
})
public class AllTests {}