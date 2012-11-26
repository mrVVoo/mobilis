package de.tudresden.inf.rn.mobilis.gwtemulationserver.server;

import java.util.List;

public abstract class Command {
	
	public String receiver;
	public String methodName;
	public List<String> parameter;
	public List<String> parameterTypes;
}