package com.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class ShellRunner
{
	public String runShell(String[] args)
	{
		return null;
	}

	public boolean runShell(Boolean mode, String localIP, String localUserPasswd, String localMysqlPasswd, String remoteIP, String remoteUsername, String remoteUserPasswd, String remoteMysqlPasswd,
			String dataBases[], String[] tables)
	{
		/*
		 * mode: false master_slave true master_master
		 */
		String shpath;
		if (mode)
			shpath = "src/com/util/dbReplication_mm.sh ";
		else
			shpath = "src/com/util/dbReplication_ms.sh ";
		shpath += localIP + " " + localUserPasswd + " " + localMysqlPasswd + " ";
		shpath += remoteIP + " " + remoteUsername + " " + remoteUserPasswd + " " + remoteMysqlPasswd + " ";
		shpath += "'";
		for (String database : dataBases)
		{
			shpath += database + " ";
		}
		shpath = shpath.trim();
		shpath += "' ";
		shpath += "'";
		for (String table : tables)
		{
			shpath += table + " ";
		}
		shpath = shpath.trim();
		shpath += "'";
		System.out.println(shpath);
		return run(shpath);
	}

	private boolean run(String shpath)
	{
		try
		{
			// Process ps = Runtime.getRuntime().exec(shpath);
			Process ps = Runtime.getRuntime().exec(new String[] { "/bin/bash", "-c", shpath }, null, null);
			ps.waitFor();

			BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
			StringBuffer sb = new StringBuffer();
			String line;
			while ((line = br.readLine()) != null)
			{
				sb.append(line).append("\n");
			}
			String result = sb.toString();
			System.out.println(result);
			if (result.contains("SUCCESSFUL!"))
				return true;
			else
				return false;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}

	public static void main(String[] args)
	{
		ShellRunner shellRunner = new ShellRunner();
		String[] databases = new String[1];
		String[] tables = new String[2];
		databases[0] = "DATABASE0";
		tables[0] = "TABLE0";
		tables[1] = "TABLE1";
		// shellRunner.runShell(false, "localhost", "iambunny", "root", "datacenter-adm.cloudapp.net", "work", "Sceri123", "root", databases, tables);
		boolean result = shellRunner.runShell(false, "localhost", "iambunny", "root", "datacenter-slv.cloudapp.net", "work", "Sceri123", "root", databases, tables);
		System.out.println(result);
	}
}
