require "fileutils"
require "pathname"

def execute_cmd(cmd, sudo)
	action = []
	action << "sudo -n" if sudo
	action << cmd
	`#{action.join(' ')}`
end

def select_channel(backup_path)
	# Todo: should be moved to the backup_path directory and we'd be reading it from there
	directory_mapping = [
		# Apps
		{
			backup_path: "/Applications/Xamarin Studio.app",
			final_path: "/Applications/Xamarin Studio.app",
			admin: false
		},
		{
			backup_path: "/Applications/Xamarin.iOS Build Host.app",
			final_path: "/Applications/Xamarin.iOS Build Host.app",
			admin: false
		},
		# Frameworks
		{
			backup_path: "/Library/Frameworks/Xamarin.iOS.framework",
			final_path: "/Library/Frameworks/Xamarin.iOS.framework",
			admin: true
		},
		{
			backup_path: "/Library/Frameworks/Mono.framework",
			final_path: "/Library/Frameworks/Mono.framework",
			admin: true
		},
		{
			backup_path: "/Library/LaunchAgents/com.xamarin.mtvs.buildserver.plist",
			final_path: "/Library/LaunchAgents/com.xamarin.mtvs.buildserver.plist",
			admin: true
		},
		# Developer
		{
			backup_path: "/Developer/MonoTouch",
			final_path: "/Developer/MonoTouch",
			admin: true
		},
		# Home
		{
			backup_path: "/Users/Birmacher/Library/Preferences/Xamarin*",
			final_path: "#{ENV['HOME']}/Library/Preferences/Xamarin*"
		},
	]

	# Copy Xamarin files
	directory_mapping.each do |mapping|
		Dir[mapping[:final_path]].each do |directory|
			if File.exists?(directory)
				if File.lstat(directory).symlink?
					execute_cmd("rm \"#{directory}\"", mapping[:admin])
				else
					puts "Path is not empty: #{directory}"
					exit 1
				end
			end
		end

		execute_cmd("mkdir -p \"#{Pathname.new(mapping[:final_path]).dirname}\"", mapping[:admin])
		execute_cmd("ln -s \"#{File.join(backup_path, mapping[:backup_path])}\" \"#{mapping[:final_path]}\"", mapping[:admin])
	end
end

if ARGV.count < 2
	puts "Not enough argumets"
	exit(1)
end

puts "Switching to #{ARGV[1]}..."
select_channel(File.join(ARGV[0], "xamarin_#{ARGV[1]}"))
