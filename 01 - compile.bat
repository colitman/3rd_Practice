javac -cp WebContent/WEB-INF/lib/hibernate-core-4.2.5.Final.jar;WebContent/WEB-INF/lib/spring-2.5.6.jar;WebContent/WEB-INF/lib/javax.servlet.jar;WebContent\WEB-INF\lib\slf4j.jar;WebContent\WEB-INF\lib\jboss-logging.jar;WebContent\WEB-INF\lib\hibernate-jpa-2.1-api-1.0.0.Final.jar -d WebContent/WEB-INF/classes src/hibernate/logic/*.java src/hibernate/util/*.java src/hibernate/dao/*.java src/action/*.java src/action/handlers/country/*.java src/action/handlers/region/*.java src/action/handlers/city/*.java src/action/handlers/university/*.java src/action/handlers/homepage/*.java src/servlet/*.java
@pause