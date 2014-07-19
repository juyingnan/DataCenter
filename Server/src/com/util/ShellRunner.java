package com.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class ShellRunner
{
	private boolean mysqlMasterSyncRunner(Boolean mode, String localIP, String localUserName, String localUserPasswd, String localMysqlPasswd, String remoteIP, String remoteUsername,
			String remoteUserPasswd, String remoteMysqlPasswd, String dataBases[], String[] tables)
	{
		/*
		 * mode: false master_slave true master_master
		 */
		String shpath;
		shpath = "src/com/util/caller.sh ";
		if (mode)
			shpath += "dbReplication_mm.sh ";
		else
			shpath += "dbReplication_ms.sh ";
		shpath += localIP + " " + localUserName + " " + localUserPasswd + " " + localMysqlPasswd + " ";
		shpath += remoteIP + " " + remoteUsername + " " + remoteUserPasswd + " " + remoteMysqlPasswd + " ";
		shpath += "'";
		for (String database : dataBases)
		{
			shpath += database + ":";
		}
		shpath = shpath.trim();
		shpath = shpath.substring(0, shpath.length() - 1);
		shpath += "' ";
		shpath += "'";
		for (String table : tables)
		{
			shpath += table + ":";
		}
		shpath = shpath.trim();
		shpath = shpath.substring(0, shpath.length() - 1);
		shpath += "'";
		System.out.println(shpath);
		return run(shpath);
	}

	private boolean clusterSyncRunner(String myPasswd, Boolean isCopyTar, String filename, String localIP, String localUserName, String localUserPasswd, String remoteIP, String remoteUsername, String remoteUserPasswd)
	{
		/*
		 * mode: false master_slave true master_master
		 */
		String shpath;
		shpath = "src/com/util/cluster_caller.sh ";
		shpath += myPasswd + " ";
		shpath += isCopyTar + " " + filename + " ";
		shpath += localIP + " " + localUserName + " " + localUserPasswd + " ";
		shpath += remoteIP + " " + remoteUsername + " " + remoteUserPasswd;

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
		/*
		 * Master - Master / Slave Sync Test
		 */
		// shellRunner.mysqlMasterSync();

		/*
		 * Cluster Sync Test
		 */
		// parameters
		String myPasswd = "";
		boolean isCopyTar = false;
		String localIP = "";
		String localUserName = "";
		String localUserPasswd = "";
		String remoteIP = "";
		String remoteUsername = "";
		String remoteUserPasswd = "";

		// Management Init & Start Test
		shellRunner.clusterManagementInit(myPasswd, true, localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);

		// Data Node Add Test
		shellRunner.clusterDataNodeAdd(myPasswd, true, localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);

	}

	public void mysqlMasterSync()
	{
		String[] databases = new String[1];
		String[] tables = new String[2];
		databases[0] = "DATABASE0";
		tables[0] = "TABLE0";
		tables[1] = "TABLE1";
		// boolean result = shellRunner.runShell(true, "datacenter-adm.cloudapp.net", "work", "Sceri123", "root", "datacenter-slv.cloudapp.net", "work", "Sceri123", "root", databases, tables);
		boolean result = mysqlMasterSyncRunner(true, "datacenter-adm.cloudapp.net", "work", "Sceri123", "root", "datacenter-slv.cloudapp.net", "work", "Sceri123", "root", databases, tables);
		System.out.println(result);
	}

	public void clusterManagementInit(String myPasswd, Boolean isCopyTar, String localIP, String localUserName, String localUserPasswd, String remoteIP, String remoteUsername, String remoteUserPasswd)
	{

		boolean result = clusterSyncRunner(myPasswd, isCopyTar, "management_init.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		result = clusterSyncRunner(myPasswd, isCopyTar, "management_start.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		// System.out.println(result);
	}

	public void clusterDataNodeAdd(String myPasswd, Boolean isCopyTar, String localIP, String localUserName, String localUserPasswd, String remoteIP, String remoteUsername, String remoteUserPasswd)
	{

		boolean result = clusterSyncRunner(myPasswd, isCopyTar, "management_add.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		result = clusterSyncRunner(myPasswd, isCopyTar, "data_init.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		//result = clusterSyncRunner(myPasswd, isCopyTar, "management_start.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		result = clusterSyncRunner(myPasswd, isCopyTar, "data_start.sh", localIP, localUserName, localUserPasswd, remoteIP, remoteUsername, remoteUserPasswd);
		// System.out.println(result);
	}
}
