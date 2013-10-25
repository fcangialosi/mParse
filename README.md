MCNP Output Parser
===

Ruby script to create spreadsheets, graphs, or pdfs from specific information within the excessive output files from MCNPX (Monte Carlo N-Particle eXtended) 

Created to assist in modeling particle interactions with the shielding cave for the miniTimeCube (mTC) scintillator-based antineutrino detector at the University of Maryland, College Park. The mTC is Expected to be complete by Spring 2014 for use at NIST.

Dependencies
------------
Requires Ruby 1.9.3 or higher: https://www.ruby-lang.org/en/downloads/

Installation (OS X)
---------
- Install the latest version of ruby
- Download and unzip mParse project
- Give the script executable permission: 


	chmod +x ./mparse


- Add a symlink:


	ln -s ~/location_to_folder/mparse /usr/local/bin



Execution
---------
Execute by simply calling

	mparse

This will open the mParse interpreter. The interpreter has its own commands, which can be discovered by typing "help" within the interpreter.
Type "done" at any time to exit mParse. 

Documentation
-------------
In progress.

