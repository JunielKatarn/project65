using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace Project65.ClickOnce
{
	class Launcher
	{
		static void Main()
		{
			try
			{
				Environment.SpecialFolder folder = Environment.SpecialFolder.LocalApplicationData;
				string localPath = Environment.GetFolderPath(folder);
				string localAppPath = Path.Combine(localPath, "Hyvart Software", "Project65 CI");
				string configPath = Path.Combine(localAppPath, "Config");

				// If local config folder exists, offer to overwrite.
				if (ApplicationDeployment.CurrentDeployment.IsFirstRun && Directory.Exists(configPath))
				{
					string message = $"Current configuration at {configPath} exists.\nDo you wish to overwrite?\nWARNING: You will lose your current settigs.";
					DialogResult result = MessageBox.Show(message, "", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2);

					if (DialogResult.Yes == result)
						DeployConfigLocally(localAppPath);
				}
				else if(!Directory.Exists(configPath))
				{
					Directory.CreateDirectory(configPath);
					DeployConfigLocally(localAppPath);
				}

				string cfgPath = Path.Combine(localAppPath, "Config", "Project64.cfg");
				File.WriteAllText(Path.Combine("Config", "Project64.cfg"), string.Format("[Settings]\r\nConfigFile={0}\r\n", cfgPath));

				Process.Start("Project64.exe");
			}
			catch (Exception ex)
			{
				MessageBox.Show($"An error has been found\n\n{ex}");
			}
		}

		/// Create local (versin-independent) config path.
		static void DeployConfigLocally(string localAppPath)
		{
			File.Copy(Path.Combine("Config", "Project64.cfg"), Path.Combine(localAppPath, "Config", "Project64.cfg"), true);
		}
	}
}
