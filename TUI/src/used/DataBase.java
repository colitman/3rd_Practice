package used;

import java.util.ArrayList;
import java.util.List;

public class DataBase {
	/*private Map<String, Map<String, Map<String, List<String>>>> db = new HashMap<String, Map<String, Map<String, List<String>>>>();*/
	private List<Country> db = new ArrayList<Country>();
	
	public DataBase() {
		init();
	}
	
	public List<Country> getCountries() {
		return db;
	}
	
	public Country getCountry(String name) {
		Country c = new Country("None", "none", "none");
		
		for(Country ct:db) {
			if(ct.getName().equals(name)) {
				c = ct;
			}
		}
		
		return c;
	}
	
	private void init() {
		Country ukr = new Country("Ukraine", "Kiev", "Ukrainian");
		Country usa = new Country("USA", "Washington", "English");
		db.add(usa);
		db.add(ukr);
		
		Region sumsky = new Region("Sumy region");
		Region kievsky = new Region("Kiev region");
		Region NY = new Region("NY region");
		Region WS = new Region("WS region");
		ukr.addRegion(sumsky);
		ukr.addRegion(kievsky);
		usa.addRegion(NY);
		usa.addRegion(WS);
		
		City sumy = new City("Sumy");
		City belop = new City("Belopolie");
		City kiev = new City("Kiev");
		City bila_ts = new City("Bila Tserkva");
		City ny = new City("New York");
		City ny2 = new City("Old York");
		City ws = new City("Washington");
		City ws2 = new City("Dirtington");
		sumsky.addCity(sumy);
		sumsky.addCity(belop);
		kievsky.addCity(kiev);
		kievsky.addCity(bila_ts);
		NY.addCity(ny);
		NY.addCity(ny2);
		WS.addCity(ws);
		WS.addCity(ws2);
		
		University uni1 = new University("Sumy Uni 1", 1);
		University uni2 = new University("Sumy Uni 2", 2);
		University uni3 = new University("Belop Uni 1", 3);
		University uni4 = new University("Belop Uni 2", 4);
		University uni5 = new University("Kiev Uni 1", 5);
		University uni6 = new University("Kiev Uni 2", 6);
		University uni7 = new University("BTS Uni 1", 7);
		University uni8 = new University("BTS Uni 2", 8);
		University uni9 = new University("NY Uni 1", 9);
		University uni10 = new University("NY Uni 2", 10);
		University uni11 = new University("OY Uni 1", 11);
		University uni12 = new University("OY Uni 2", 12);
		University uni13 = new University("WS Uni 1", 13);
		University uni14 = new University("WS Uni 2", 14);
		University uni15 = new University("DS Uni 1", 15);
		University uni16 = new University("DS Uni 2", 16);
		sumy.addUni(uni1);
		sumy.addUni(uni2);
		belop.addUni(uni3);
		belop.addUni(uni4);
		kiev.addUni(uni5);
		kiev.addUni(uni6);
		bila_ts.addUni(uni7);
		bila_ts.addUni(uni8);
		ny.addUni(uni9);
		ny.addUni(uni10);
		ny2.addUni(uni11);
		ny2.addUni(uni12);
		ws.addUni(uni13);
		ws.addUni(uni14);
		ws2.addUni(uni15);
		ws2.addUni(uni16);
		
		
		/*List<String> kiev_unis = new ArrayList<String>();
		kiev_unis.add("Kiev Uni 1");
		kiev_unis.add("Kiev Uni 2");
		kiev_unis.add("Kiev Uni 3");
		
		List<String> sumy_unis = new ArrayList<String>();
		sumy_unis.add("Sumy Uni 1");
		sumy_unis.add("Sumy Uni 2");
		sumy_unis.add("Sumy Uni 3");
		
		List<String> new_york_unis = new ArrayList<String>();
		new_york_unis.add("New York Uni 1");
		new_york_unis.add("New York Uni 2");
		new_york_unis.add("New York Uni 3");
		
		List<String> wash_unis = new ArrayList<String>();
		wash_unis.add("Washington Uni 1");
		wash_unis.add("Washington Uni 2");
		wash_unis.add("Washington Uni 3");
		////////////////
		Map<String, List<String>> kiev_cities = new HashMap<String, List<String>>();
		kiev_cities.put("Kiev", kiev_unis);
		
		Map<String, List<String>> sumy_cities = new HashMap<String, List<String>>();
		sumy_cities.put("Sumy", sumy_unis);
		
		Map<String, List<String>> NY_cities = new HashMap<String, List<String>>();
		NY_cities.put("New York", new_york_unis);
		
		Map<String, List<String>> WS_cities = new HashMap<String, List<String>>();
		WS_cities.put("New York", wash_unis);
		/////////////////////
		Map<String, Map<String, List<String>>> UA_regs = new HashMap<String, Map<String, List<String>>>();
		UA_regs.put("Kiev region", kiev_cities);
		UA_regs.put("Sumy region", sumy_cities);
		
		Map<String, Map<String, List<String>>> USA_regs = new HashMap<String, Map<String, List<String>>>();
		USA_regs.put("NY region", NY_cities);
		USA_regs.put("WDC region", WS_cities);
		////////////////////
		db.put("Ukraine", UA_regs);
		db.put("USA", USA_regs);*/
	}
}
