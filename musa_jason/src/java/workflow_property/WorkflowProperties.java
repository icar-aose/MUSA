package workflow_property;

import ids.database.Table;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

//DA ELIMINARE
public class WorkflowProperties 
{
	//"run" o "jar"
	public static String getExecutionEnvironment()
	{
		return System.getProperty("musa.environment");
	}
	
	
	
	private static InputStream getConfigFileStream(String configFileName) throws FileNotFoundException
	{
		InputStream file_stream;

		if (System.getProperty("java.class.path").contains("org.eclipse.equinox.launcher"))
			file_stream = new FileInputStream(new File(configFileName));
		else
			file_stream = Table.class.getResourceAsStream("/"+configFileName);
		
		return file_stream;
	}
	
	private static InputStream getConfigFileStream() throws FileNotFoundException
	{
		InputStream file_stream;

		if (System.getProperty("java.class.path").contains("org.eclipse.equinox.launcher"))
			file_stream = new FileInputStream(new File("config.properties"));
		else
			file_stream = Table.class.getResourceAsStream("/config.properties");
		
		return file_stream;
	}
	
	public static String get_ip_address() throws FileNotFoundException
	{
		Properties prop = new Properties();
		
		try 
		{
			prop.load( getConfigFileStream() );
			return prop.getProperty("ip_address");
		} 
		catch (IOException e) {e.printStackTrace();}
		
		return null;
	}
	
	public static String get_port() throws FileNotFoundException
	{
		Properties prop = new Properties();
		
		try 
		{
			prop.load( getConfigFileStream() );
			return prop.getProperty("port");
		} 
		catch (IOException e) {e.printStackTrace();}
		
		return null;
	}
	
	public static String get_database() throws FileNotFoundException
	{
		Properties prop = new Properties();
		
		try 
		{
			prop.load( getConfigFileStream() );
			return prop.getProperty("database");
		} 
		catch (IOException e) {e.printStackTrace();}
		
		return null;
	}
	
	public static String get_user() throws FileNotFoundException
	{
		Properties prop = new Properties();
		
		try 
		{
			prop.load( getConfigFileStream() );
			return prop.getProperty("user");
		} 
		catch (IOException e) {e.printStackTrace();}
		
		return null;
	}
	
	public static String get_password() throws FileNotFoundException
	{
		Properties prop = new Properties();
		
		try 
		{
			prop.load( getConfigFileStream() );
			return prop.getProperty("password");
		} 
		catch (IOException e) {e.printStackTrace();}
		
		return null;
	}
}
