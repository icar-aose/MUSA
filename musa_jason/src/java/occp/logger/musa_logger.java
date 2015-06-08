package occp.logger;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * 
 * @author davide
 */
public class musa_logger 
{
	private static musa_logger musa_logger_instance;
	private Logger log;
	
	private musa_logger() throws IOException
	{
	/*	if (System.getProperty("java.class.path").contains("org.eclipse.equinox.launcher"))
		{
			PropertyConfigurator.configure("log4j.properties");
		}
		else
		{
			URL url = musa_logger.class.getResource("/log4j.properties");
			InputStream is = url.openStream();
			PropertyConfigurator.configure(is);
		}

		log = Logger.getLogger(musa_logger.class);*/
	}	
	
	private musa_logger(String log_fname)
	{
		PropertyConfigurator.configure("log4j.properties");
		log = Logger.getLogger(musa_logger.class);
	}
	
	public static musa_logger get_instance()
	{
		if(musa_logger_instance == null)
		{
			try 					{musa_logger_instance = new musa_logger();} 
			catch (IOException e) 	{e.printStackTrace();}
		}
		return musa_logger_instance;
	}
	
	
	public static musa_logger get_instance_and_set_log_fname(String fname)
	{
		if(musa_logger_instance == null)
			musa_logger_instance = new musa_logger(fname);
		
		return musa_logger_instance;
	}
	
	
	public void debug(String msg)
	{
//		log.debug(msg);
	}
	
	public void info(String msg)
	{
//		log.info(msg);
	}
	
	public void warn(String msg)
	{
//		log.warn(msg);
	}
	
	public void error(String msg)
	{
//		log.error(msg);
	}
	
	public void fatal(String msg)
	{
//		log.fatal(msg);
	}
	
}
