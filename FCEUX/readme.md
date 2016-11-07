
# HOW TO USE DATASET GENERATOR

1. `apt-get/yum/munki/whatever install csvigo`. You'll need this to actually generate a CSV.
2. Get FCEUX (windows included, debian archive included)
3. Make sure a directory `testdata` exists in the same directory the `Training_Data_Printer_TXT.lua`.
4. Open FCEUX
5. File -> Load ROM -> Super Mario Bros (included)
6. File -> Open LUA Script -> either open `Training_Data_Printer_TXT.lua` from recent scripts or browse.
7. Play for a bit. Recommendation of no more than 10 minutes, or 15 if your hard drive is big.
8. After a level or two, zip the *ENTIRE* contents of `testdata`. Empty `testdata` after you've archived the data.
