package com.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class ShellRunner
{
	public String runShell(String[] args)
	{
		return null;
	}

	public String runShell(String localIP, String localRootPasswd, String localMysqlUser, String localMysqlPasswd, String remoteIP, String remoteRootPasswd, String remoteMysqlUser,
			String remoteMysqlPasswd, String dataBases[], String[] tables)
	{
		String shpath = "src/com/util/dbReplication.sh";
		shpath += localIP + " " + localRootPasswd + " " + localMysqlUser + " " + localMysqlPasswd + " ";
		shpath += remoteIP + " " + remoteRootPasswd + " " + remoteMysqlUser + " " + remoteMysqlPasswd + " ";
		for (String database : dataBases)
		{
			shpath += database + " ";
		}
		for (String table : tables)
		{
			shpath += table + " ";
		}
		System.out.println(shpath);
		run(shpath);
		return null;
	}

	private void run(String shpath)
	{
		try
		{
			Process ps = Runtime.getRuntime().exec(shpath);
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
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	public static void main(String[] args)
	{
		ShellRunner shellRunner = new ShellRunner();
		String[] databases = new String[1];
		String[] tables = new String[1];
		shellRunner.runShell("LOCAL_IP", "LOCAL_ROOT_PASSWD", "LOCAL_MYSQL_USER", "LOCAL_MYSQL_PASSWD", "REMOTE_IP", "REMOTE_ROOT_PASSWD", "REMOTE_MYSQL_USER", "REMOTE_MYSQL_PASSWD", null, null);
	}
}
