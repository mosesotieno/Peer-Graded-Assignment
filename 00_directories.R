#---- Header  ----

#---- Name : 00_directories.R

#---- Purpose: Create directories needed in the project

#---- Author : Moses Otieno

#---- Date : 10 Aug 2020

#---- Body ----

if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("scripts")){dir.create("scripts")}
if(!dir.exists("figures")){dir.create("figures")}
if(!dir.exists("report")){dir.create("report")}

