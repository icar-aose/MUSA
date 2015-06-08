package utility;

import java.awt.HeadlessException;

import jason.JasonException;
import jason.infra.centralised.CentralisedFactory;
import jason.infra.centralised.RunCentralisedMAS;

public class RunMAS
{
	public static void main(String[] args) throws JasonException 
	{
		RunCentralisedMAS runner = RunCentralisedMAS.getRunner();
        runner = new RunCentralisedMAS();
        System.setProperty("java.awt.headless", "true");
        runner.init(args);
        RunCentralisedMAS.setupDefaultConsoleLogger();
        runner.create();
        runner.start();
        runner.waitEnd();
        runner.finish();
    }
	
	
	
}
