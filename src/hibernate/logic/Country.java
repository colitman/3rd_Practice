package hibernate.logic;

import java.util.*;
import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="Country")
public class Country {

	private int id;
	private String name;
	private String language;
	private String capital;
	private int population;
	private int timezone;
	private Set<Region> regions;

	public Country() {

	}
	
	public void setID(int id) {
		this.id = id;
	} 
	
	@Id
    	@GeneratedValue(generator="increment")
    	@GenericGenerator(name="increment", strategy = "increment")
    	@Column(name="id")
	public int getID() {
		return id;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name="name")
	public String getName() {
		return name;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	@Column(name="language")
	public String getLanguage() {
		return language;
	}
	
	public void setCapital(String capital) {
		this.capital = capital;
	}

	@Column(name="capital")
	public String getCapital() {
		return capital;
	}

	public void setPopulation(int population) {
		this.population = population;
	}

	@Column(name="population")
	public int getPopulation() {
		return population;
	}

	public void setTimezone(int timezone) {
		this.timezone = timezone;
	}

	@Column(name="timezone")
	public int getTimezone() {
		return timezone;
	}

	public void setRegions(Set<Region> regions) {
		this.regions = regions;
	}
	
	public Set<Region> getRegions() {
		return regions;
	}
}