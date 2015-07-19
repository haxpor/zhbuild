# zhbuild
A build script for Zombie Hero project (Xcode project)

Works, but mostly right now it uses fixed setting in the script. Thus change those for your project.

I will be working on it more for more flexible and general in use of the script. But it's not so soon.

I'm around on twitter, hit me @haxpor.

Commands
===
It involves using the following programs. Thus at this point, make sure you have them all installed in your system.

1. xcodebuild
2. ios-deploy
3. ios-sim
4. lldb

Commands support (*specific for this script and project)

* `zhbuild build`  
	Build Debug-build
	
* `zhbuild build-sim`  
	Build a project for simulator.

* `zhbuild clean`  
	Clean the whole project

* `zhbuild xcconfig`  
    Create an xcconfig file for Debug configuration of 'ZombieHero - Fast Build' scheme

* `zhbuild debug ipad`  
    Build, deploy and debug Debug-build on ipad device. Build process is the same as in 1.

* `zhbuild debug sim`
	Build, and launching simulator.

* `zhbuild debug`  
    Build, deploy and debug Debug-build on ipod touch device. Build process is the same as in 1.
