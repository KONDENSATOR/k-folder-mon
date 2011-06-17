fsmon
=====

Monitors file activity in a git repository folder. Whenever files are changed added or deleted, they are automatically commited and pushed to the central repository. The result is a git based DropBox clone.

Prerequisites
============

 * git - You need to install git on your system. If you have Snow Leopard, git should already be available. [http://git-scm.com/](http://git-scm.com/)
 * ruby - This should also be available if you're running Snow Leopard. Version 1.8.7 is default on my system and works fine.
 * real-growl - Follow installation [https://github.com/dewind/real-growl](https://github.com/dewind/real-growl)
 * fetool - This is the tool the whole service build upon. You find it in [fseventer](http://fernlightning.com/doku.php?id=software:fseventer:start) application bundle. After you have installed fseventer you right click the application bundle and chose "Show Package Contents". You find the fetool binary in Contents/Resources.

Installation
============

 * Install all the prerequisites. 
 * Clone this repository
  * git clone git://github.com/KONDENSATOR/k-folder-mon.git
  * Put it in any home directory folder.
  * Put the fetool binary within the k-folder-mon folder.
 * Create a file named ".fsmon" in the root of your home directory, and follow the instructions in the Configuration instructions.
 
Configuration
=============

The configuration is a simple hidden file within the root of your home directory called .fsmon. It should look something like this.

    user: fredrik
    folders:
      - ~/shared_folder
      - ~/another_shared_folder
    filters:
      - .ds_store
      - .git
    
The folders section is where you put your local reference to your local copies of the repositories that you want automatically synchronize.

Startup
=======

From within the k-folder-mon directory, just run
    
    sudo ./fsmond start
    ./fsfetchd start

Todo
====

Make daemon start at login.
